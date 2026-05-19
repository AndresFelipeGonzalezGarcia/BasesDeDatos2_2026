/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Comparativo de Cursores y Análisis de Rendimiento
Descripción: Evaluación técnica entre Cursores Explícitos (control manual de ciclo)
             y Cursores Implícitos (FOR Loops optimizados por el compilador). 
             Mide tiempos exactos mediante instrumentación con SYSTIMESTAMP.
================================================================================
*/

SET SERVEROUTPUT ON;

-- =============================================================================
-- ENFOQUE 1: CURSOR EXPLÍCITO CON CONTROL MANUAL DE CICLO DE VIDA
-- =============================================================================
-- Características: Requiere definición formal, apertura (OPEN), recuperación 
-- manual (FETCH) estructurada fila por fila y cierre obligatorio (CLOSE).

DECLARE
    -- Variables métricas de control y tiempo
    vv_total_nomina    NUMBER(12, 2) := 0;
    vv_contador        NUMBER        := 0;
    vv_inicio          TIMESTAMP;
    vv_fin             TIMESTAMP;
    vv_segundos        NUMBER;

    -- Variables de mapeo de columnas
    vv_nombre_completo VARCHAR2(50);
    vv_departamento    VARCHAR2(30);
    vv_cargo           VARCHAR2(35);
    vv_salario         NUMBER(8, 2);

    -- Declaración formal del Cursor Explícito con operaciones Join multitabla
    CURSOR vv_cursor_empleados IS
        SELECT e.first_name || ' ' || e.last_name AS nombre_completo,
               d.department_name                   AS departamento,
               j.job_title                         AS cargo,
               e.salary                            AS salario
        FROM   employees   e,
               departments d,
               jobs        j
        WHERE  e.department_id = d.department_id
        AND    e.job_id        = j.job_id
        ORDER BY e.department_id, e.salary DESC;

BEGIN
    -- Captura del tiempo inicial de procesamiento
    vv_inicio := SYSTIMESTAMP;

    -- 1. Apertura del cursor asignando recursos en memoria
    OPEN vv_cursor_empleados;

    LOOP
        -- 2. Extracción secuencial del registro actual del búfer hacia variables locales
        FETCH vv_cursor_empleados
          INTO vv_nombre_completo,
               vv_departamento,
               vv_cargo,
               vv_salario;

        -- Cláusula de escape obligatoria: detiene el bucle si no hay más filas
        EXIT WHEN vv_cursor_empleados%NOTFOUND;

        -- Acumulación de estadísticas
        vv_contador     := vv_contador + 1;
        vv_total_nomina := vv_total_nomina + vv_salario;

        -- Impresión formateada con alineación de columnas (LPAD / RPAD)
        DBMS_OUTPUT.PUT_LINE(
          LPAD(vv_contador, 3)              || ' | ' ||
          RPAD(vv_nombre_completo, 22)      || ' | ' ||
          RPAD(vv_departamento, 20)         || ' | ' ||
          RPAD(vv_cargo, 30)                || ' | ' ||
          TO_CHAR(vv_salario, '999,999')
        );
    END LOOP;

    -- 3. Liberación obligatoria de recursos en servidor
    CLOSE vv_cursor_empleados;

    -- Cálculo final y extracción del delta de tiempo
    vv_fin      := SYSTIMESTAMP;
    vv_segundos := EXTRACT(SECOND FROM (vv_fin - vv_inicio));

    DBMS_OUTPUT.PUT_LINE('======================================================================');
    DBMS_OUTPUT.PUT_LINE('MÉTRICAS: ENFOQUE CURSOR EXPLÍCITO');
    DBMS_OUTPUT.PUT_LINE('Total empleados : ' || vv_contador);
    DBMS_OUTPUT.PUT_LINE('Total nomina    : ' || TO_CHAR(vv_total_nomina, '999,999,999'));
    DBMS_OUTPUT.PUT_LINE('Tiempo (seg)    : ' || vv_segundos);
    DBMS_OUTPUT.PUT_LINE('======================================================================');

EXCEPTION
    WHEN OTHERS THEN
        -- Patrón de seguridad: Asegura el cierre del cursor ante fallos imprevistos
        IF vv_cursor_empleados%ISOPEN THEN
            CLOSE vv_cursor_empleados;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Error en Bloque Explícito: ' || SQLERRM);
END;
/


-- =============================================================================
-- ENFOQUE 2: CURSOR IMPLÍCITO (CURSOR FOR LOOP OPTIMIZADO)
-- =============================================================================
-- Características: El motor PL/SQL gestiona de forma nativa e implícita la 
-- apertura, lectura masiva (Bulk Fetch interno) y el cierre seguro del objeto.

DECLARE
    -- Variables de control y tiempo para el segundo escenario
    vv_nombre_completo VARCHAR2(50);
    vv_departamento    VARCHAR2(30);
    vv_cargo           VARCHAR2(35);
    vv_salario         NUMBER(8, 2);
    vv_total_nomina    NUMBER(12, 2) := 0;
    vv_contador        NUMBER        := 0;
    vv_inicio          TIMESTAMP;
    vv_fin             TIMESTAMP;
    vv_segundos        NUMBER;

BEGIN
    -- Captura de tiempo inicial
    vv_inicio := SYSTIMESTAMP;

    -- Ciclo FOR LOOP Implícito: No requiere variables locales previas para los datos
    FOR vv_reg IN (
        SELECT e.first_name || ' ' || e.last_name AS nombre_completo,
               d.department_name                   AS departamento,
               j.job_title                         AS cargo,
               e.salary                            AS salario
        FROM   employees   e,
               departments d,
               jobs        j
        WHERE  e.department_id = d.department_id
        AND    e.job_id        = j.job_id
        ORDER BY e.department_id, e.salary DESC
    ) LOOP

        vv_contador     := vv_contador + 1;
        vv_total_nomina := vv_total_nomina + vv_reg.salario;

        -- Impresión formateada accediendo directamente a los atributos del registro (vv_reg)
        DBMS_OUTPUT.PUT_LINE(
          LPAD(vv_contador, 3)              || ' | ' ||
          RPAD(vv_reg.nombre_completo, 22)  || ' | ' ||
          RPAD(vv_reg.departamento, 20)     || ' | ' ||
          RPAD(vv_reg.cargo, 30)            || ' | ' ||
          TO_CHAR(vv_reg.salario, '999,999')
        );
    END LOOP;

    -- Captura del tiempo final del procesamiento implícito
    vv_fin      := SYSTIMESTAMP;
    vv_segundos := EXTRACT(SECOND FROM (vv_fin - vv_inicio));

    DBMS_OUTPUT.PUT_LINE('======================================================================');
    DBMS_OUTPUT.PUT_LINE('MÉTRICAS: ENFOQUE CURSOR IMPLÍCITO (FOR LOOP)');
    DBMS_OUTPUT.PUT_LINE('Total empleados : ' || vv_contador);
    DBMS_OUTPUT.PUT_LINE('Total nomina    : ' || TO_CHAR(vv_total_nomina, '999,999,999'));
    DBMS_OUTPUT.PUT_LINE('Tiempo (seg)    : ' || vv_segundos);
    DBMS_OUTPUT.PUT_LINE('======================================================================');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en Bloque Implícito: ' || SQLERRM);
END;
/