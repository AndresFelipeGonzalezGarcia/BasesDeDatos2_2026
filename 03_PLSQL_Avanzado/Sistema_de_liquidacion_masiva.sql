/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Motor de Liquidación y Procesamiento Masivo de Nómina (PL/SQL Avanzado)
Descripción: Arquitectura para la asignación de contratos, cálculo 
             de devengados, deducciones legales y generación batch (por lotes) 
             de colillas de pago (payslips) con control de tolerancia a fallos.
================================================================================
*/

SET SERVEROUTPUT ON;

-- =============================================================================
-- SECCIÓN 1: CONFIGURACIÓN DE CONTRATOS SINTÉTICOS (DML AVANZADO)
-- =============================================================================
-- Objetivo: Poblar la tabla de contratos asignando el tipo de nómina (Mensual, 
-- Quincenal, Semanal) mediante subconsultas dinámicas basadas en rangos de IDs.

PRINT 'Iniciando fase de preparación y asignación de contratos...';

INSERT INTO pay_emp_contracts (
    employee_id,
    payroll_type_id,
    base_salary,
    hours_per_month,
    start_date,
    status
)
SELECT
    e.employee_id,
    CASE
        WHEN e.employee_id <= 2000 THEN
            (SELECT payroll_type_id FROM pay_payroll_types WHERE code = 'MENSUAL')
        WHEN e.employee_id <= 4000 THEN
            (SELECT payroll_type_id FROM pay_payroll_types WHERE code = 'QUINCENAL')
        ELSE
            (SELECT payroll_type_id FROM pay_payroll_types WHERE code = 'SEMANAL')
    END,
    e.salary,
    240, -- Horas estándar mensuales
    SYSDATE,
    'ACTIVO'
FROM employees e;

COMMIT;


-- =============================================================================
-- SECCIÓN 2: PROCEDIMIENTO TRANSACCIONAL DE LIQUIDACIÓN INDIVIDUAL
-- =============================================================================
-- Objetivo: Liquidar la colilla de pago de un empleado específico para un periodo.
-- Calcula salario neto, deducciones de salud/pensión e inserta cabecera y líneas.

CREATE OR REPLACE PROCEDURE ingresar_nomina (
    p_employee_id IN NUMBER,
    p_period_code IN VARCHAR2
) IS
    -- Variables con herencia de tipos basada en el diccionario de datos (%TYPE)
    vv_period_id        pay_periods.period_id%TYPE;
    vv_salary           pay_emp_contracts.base_salary%TYPE;
    vv_payroll_type_id  pay_emp_contracts.payroll_type_id%TYPE;
    vv_period_salary    NUMBER(12, 2);
    vv_salud_rate       pay_concepts.default_rate%TYPE;
    vv_pension_rate      pay_concepts.default_rate%TYPE;
    vv_salud            NUMBER(12, 2);
    vv_pension          NUMBER(12, 2);
    vv_payslip_id       pay_payslips.payslip_id%TYPE;
    vv_sal_base_id      pay_concepts.concept_id%TYPE;
    vv_salud_id         pay_concepts.concept_id%TYPE;
    vv_pension_id       pay_concepts.concept_id%TYPE;
    vv_payroll_code     pay_payroll_types.code%TYPE;
BEGIN

    -- 1. Recuperación del identificador del periodo de nómina
    SELECT period_id
    INTO vv_period_id
    FROM pay_periods
    WHERE period_code = p_period_code;

    -- 2. Extracción de condiciones contractuales del empleado activo
    SELECT c.base_salary, c.payroll_type_id, t.code
    INTO vv_salary, vv_payroll_type_id, vv_payroll_code
    FROM pay_emp_contracts c
    JOIN pay_payroll_types t ON c.payroll_type_id = t.payroll_type_id
    WHERE c.employee_id = p_employee_id
      AND c.status = 'ACTIVO';

    -- 3. Regla de Negocio: Prorrateo del salario base según la periodicidad del pago
    IF vv_payroll_code = 'MENSUAL' THEN
        vv_period_salary := vv_salary;
    ELSIF vv_payroll_code = 'QUINCENAL' THEN
        vv_period_salary := vv_salary / 2;
    ELSIF vv_payroll_code = 'SEMANAL' THEN
        vv_period_salary := vv_salary / 4;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Error Crítico: Tipo de nómina no parametrizado: ' || vv_payroll_code);
    END IF;

    -- 4. Captura de Conceptos de Nómina y Tasas Impositivas / Legales
    SELECT concept_id, default_rate INTO vv_salud_id, vv_salud_rate
    FROM pay_concepts WHERE code = 'SALUD_EE';

    SELECT concept_id, default_rate INTO vv_pension_id, vv_pension_rate
    FROM pay_concepts WHERE code = 'PENSION_EE';

    SELECT concept_id INTO vv_sal_base_id
    FROM pay_concepts WHERE code = 'SAL_BASE';

    -- 5. Algoritmo de Cálculo de Deducciones de Ley
    vv_salud   := vv_period_salary * vv_salud_rate;
    vv_pension := vv_period_salary * vv_pension_rate;

    -- 6. Inserción de Cabecera (Uso estratégico de RETURNING para evitar consultas extra)
    INSERT INTO pay_payslips (
        period_id, employee_id, gross_total, ded_total, net_total
    ) VALUES ( 
        vv_period_id, p_employee_id, 0, 0, 0 
    ) RETURNING payslip_id INTO vv_payslip_id;

    -- 7. Inserción de Detalle: Línea de Salario Base Devengado
    INSERT INTO pay_payslip_lines (
        payslip_id, concept_id, qty, unit_value, line_total
    ) VALUES ( 
        vv_payslip_id, vv_sal_base_id, 1, vv_period_salary, vv_period_salary 
    );

    -- 8. Inserción de Detalle: Línea de Deducción de Salud (Valor Negativo)
    INSERT INTO pay_payslip_lines (
        payslip_id, concept_id, qty, unit_value, line_total
    ) VALUES ( 
        vv_payslip_id, vv_salud_id, 1, -vv_salud, -vv_salud 
    );

    -- 9. Inserción de Detalle: Línea de Deducción de Pensión (Valor Negativo)
    INSERT INTO pay_payslip_lines (
        payslip_id, concept_id, qty, unit_value, line_total
    ) VALUES ( 
        vv_payslip_id, vv_pension_id, 1, -vv_pension, -vv_pension 
    );

    -- 10. Centralización y consolidación de Totales en la Cabecera
    UPDATE pay_payslips
    SET gross_total = vv_period_salary,
        ded_total   = vv_salud + vv_pension,
        net_total   = vv_period_salary - (vv_salud + vv_pension)
    WHERE payslip_id = vv_payslip_id;

    COMMIT;
END ingresar_nomina;
/


-- =============================================================================
-- SECCIÓN 3: ORQUESTADOR MASIVO (PROCESAMIENTO EN LOGICA BATCH)
-- =============================================================================
-- Objetivo: Recorrer de forma cruzada periodos y contratos activos mediante loops.
-- Aplica control de excepciones defensivo para garantizar la continuidad del lote.

CREATE OR REPLACE PROCEDURE generar_nomina_total IS
BEGIN
    -- Cursor implícito para la iteración secuencial de periodos cronológicos
    FOR vr_period IN (
        SELECT period_code FROM pay_periods ORDER BY period_code
    ) LOOP
    
        -- Cursor anidado para recuperar el universo de contratos aptos para pago
        FOR vr_emp IN (
            SELECT employee_id FROM pay_emp_contracts WHERE status = 'ACTIVO'
        ) LOOP
            BEGIN
                -- Invocación atómica del motor transaccional de liquidación
                ingresar_nomina(vr_emp.employee_id, vr_period.period_code);
                
            EXCEPTION
                WHEN OTHERS THEN
                    -- PATRÓN DEFENSIVO: Se implementa 'WHEN OTHERS THEN NULL' de manera
                    -- intencional aislada por bloque, garantizando que una anomalía en un 
                    -- contrato específico no rompa ni detenga la ejecución masiva del lote (Batch).
                    DBMS_OUTPUT.PUT_LINE('Advertencia: Error procesando empleado ID: ' || vr_emp.employee_id);
            END;
        END LOOP;
    END LOOP;
END generar_nomina_total;
/

-- Ejecución del motor global de nómina
BEGIN
    generar_nomina_total;
END;
/


-- =============================================================================
-- SECCIÓN 4: COMPONENTES COMPLEMENTARIOS Y GUÍAS DE ESCALABILIDAD
-- =============================================================================

-- 4.1 Ejemplo de Funciones Escalares: Saludo Parametrizado
CREATE OR REPLACE FUNCTION fn_saludar_empleado (
    vv_nombre IN VARCHAR2
) RETURN VARCHAR2 IS
    vv_prefijo VARCHAR2(30) := 'Sistema de Nómina - Operador: ';
BEGIN
    RETURN (vv_prefijo || vv_nombre);
END;
/

-- Ejecución de prueba de la función escalar
DECLARE 
    vv_salida VARCHAR2(100);
BEGIN
    vv_salida := fn_saludar_empleado('Andrés González');
    DBMS_OUTPUT.PUT_LINE(vv_salida);
END;
/
