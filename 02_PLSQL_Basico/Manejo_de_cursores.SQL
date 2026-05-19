/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Control de Estructuras de Datos mediante Cursores (Explícitos e Implícitos)
Descripción: Implementación de soluciones para el procesamiento fila por fila 
             de conjuntos de resultados. Uso de atributos de cursores (%NOTFOUND) 
             y estructuras de repetición para el control de memoria en el servidor.
================================================================================
*/

-- Configuración del entorno para salida en consola
SET SERVEROUTPUT ON;

-- =============================================================================
-- SECCIÓN 1: CURSORES EXPLÍCITOS (Ciclo de Vida Básico)
-- =============================================================================
-- Objetivo: Extraer un único registro del conjunto de resultados mapeando 
-- correctamente el orden del búfer de memoria a variables locales.

DECLARE
    -- 1. Declaración del cursor con restricción de dominio (Departamento 80)
    CURSOR cursor_empleados IS 
        SELECT first_name, last_name, department_id
        FROM tduartec.employees
        WHERE department_id = 80;
    
    -- Variables locales alineadas al tipo de dato del esquema
    vv_first_name   VARCHAR2(100);
    vv_last_name    VARCHAR2(100);
    vn_department_id NUMBER(9);
BEGIN
    -- 2. Apertura del cursor: Se ejecuta la consulta y se genera el active set
    OPEN cursor_empleados;
    
    -- 3. Recuperación (FETCH): Corrección de asignación (First_name -> vv_first_name)
    FETCH cursor_empleados INTO vv_first_name, vv_last_name, vn_department_id;
    
    -- Despliegue del primer registro recuperado
    DBMS_OUTPUT.PUT_LINE('Primer registro recuperado: ' || vv_first_name || ' ' || vv_last_name || ' | Dept: ' || vn_department_id);
    
    -- 4. Cierre del cursor: Liberación de recursos de memoria en el servidor
    CLOSE cursor_empleados;
END;
/

-- =============================================================================
-- SECCIÓN 2: CURSORES EXPLÍCITOS CON ESTRUCTURAS DE REPETICIÓN (LOOP)
-- =============================================================================
-- Objetivo: Procesar de forma secuencial la totalidad de los registros devueltos
-- por el cursor, controlando el desborde mediante el atributo %NOTFOUND.

DECLARE
    CURSOR cursor_empleados IS
        SELECT first_name, last_name, department_id
        FROM tduartec.employees
        WHERE department_id = 80;

    vv_first_name   VARCHAR2(100);
    vv_last_name    VARCHAR2(100);
    vn_department_id NUMBER(9);
BEGIN
    OPEN cursor_empleados;
    
    -- Ciclo de procesamiento masivo fila por fila
    LOOP
        FETCH cursor_empleados INTO vv_first_name, vv_last_name, vn_department_id;
        
        -- Cláusula de escape: Evalúa si el FETCH anterior arrojó resultados válidos
        EXIT WHEN cursor_empleados%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Empleado: ' || vv_last_name || ', ' || vv_first_name || ' | Dept: ' || vn_department_id);
    END LOOP;
    
    CLOSE cursor_empleados;
END;
/   

-- =============================================================================
-- SECCIÓN 3: CURSORES IMPLICITOS (Consultas Singulares INTO)
-- =============================================================================
-- Objetivo: Demostración de cursores gestionados automáticamente por Oracle.
-- Nota: Requieren obligatoriamente retornar una única fila para evitar excepciones
-- del tipo NO_DATA_FOUND o TOO_MANY_ROWS.

DECLARE
    vv_descripcion VARCHAR2(50);
BEGIN
    -- El cursor implícito ejecuta, abre, recupera y cierra en una sola sentencia
    SELECT descripcion
    INTO vv_descripcion
    FROM paises
    WHERE co_pais = 'ESP';

    DBMS_OUTPUT.PUT_LINE('La lectura del cursor implícito es: ' || vv_descripcion);
END;
/