/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Guía Práctica de Fundamentos de PL/SQL y Estructuras de Control
Descripción: Documentación de conceptos esenciales de programación procedural en
             servidor Oracle: variables, %TYPE, %ROWTYPE, flujos condicionales,
             bucles, procedimientos almacenados y funciones de fecha.
================================================================================
*/

-- Configuración del entorno de desarrollo para salida en consola
SET SERVEROUTPUT ON;

-- =============================================================================
-- SECCIÓN 1: DECLARACIÓN DE VARIABLES Y HOLA MUNDO
-- =============================================================================

-- Sintaxis alternativa 1: Declaración y asignación separadas
DECLARE
    vv_mi_primera_variable VARCHAR2(50);
BEGIN
    vv_mi_primera_variable := 'Hola mundo';
    DBMS_OUTPUT.PUT_LINE(vv_mi_primera_variable);
END;
/

-- Sintaxis alternativa 2: Declaración con inicialización directa
DECLARE
    vv_mi_primera_variable VARCHAR2(50) := 'Hola mundo';
BEGIN    
    DBMS_OUTPUT.PUT_LINE(vv_mi_primera_variable);
END;
/

-- =============================================================================
-- SECCIÓN 2: INTERACCIÓN CON EL ESQUEMA (DML Y ATRIBUTOS DE DATOS)
-- =============================================================================

-- Bloque Anónimo: Captura de datos estructurados mediante cláusula INTO
DECLARE
    vv_nombre   VARCHAR2(50);
    vv_apellido VARCHAR2(50);
BEGIN
    SELECT first_name, last_name
    INTO vv_nombre, vv_apellido
    FROM hr.employees
    WHERE employee_id = 110;

    -- Uso de literales y operador de concatenación (||)
    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || vv_nombre || ' ' || vv_apellido);
END;
/

-- Uso del Atributo %TYPE: Garantiza el dinamismo y herencia del tipo de dato de la columna
DECLARE
    vv_nombre   hr.employees.first_name%TYPE;
    vv_apellido hr.employees.last_name%TYPE;
BEGIN
    SELECT first_name, last_name
    INTO vv_nombre, vv_apellido
    FROM hr.employees
    WHERE employee_id = 110;

    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es (con %TYPE): ' || vv_nombre || ' ' || vv_apellido);
END;
/

-- Uso del Atributo %ROWTYPE: Creación de un registro basado en la estructura completa de la tabla
DECLARE
    vr_empleado hr.employees%ROWTYPE;
BEGIN
    SELECT *
    INTO vr_empleado
    FROM hr.employees
    WHERE employee_id = 110;

    -- Acceso a campos específicos a través de la notación de punto
    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es (con %ROWTYPE): ' || vr_empleado.first_name);
END;
/

-- =============================================================================
-- SECCIÓN 3: ESTRUCTURAS DE CONTROL Y FLUJOS CONDICIONALES
-- =============================================================================

-- Condicional IF-ELSE: Evaluación analítica del día actual (Días Primos)
DECLARE
    vn_current_date NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'DD')); 
BEGIN
    IF vn_current_date IN (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31) THEN
        DBMS_OUTPUT.PUT_LINE('HOLA PRIMO. El día ' || vn_current_date || ' es un número primo.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('NO ES PRIMO. El día ' || vn_current_date || ' no pertenece al conjunto.');
    END IF; 
END;
/

-- Bifurcación con GOTO: Demostración de saltos de etiquetas (Código depurado y funcional)
DECLARE
    vn_current_date NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'DD')); 
BEGIN
    IF vn_current_date IN (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31) THEN
        GOTO etiqueta_primo;
    ELSE 
        GOTO etiqueta_noprimo;
    END IF; 

    <<etiqueta_primo>>
    DBMS_OUTPUT.PUT_LINE('GOTO: El día es primo.');
    GOTO fin_proceso;

    <<etiqueta_noprimo>>
    DBMS_OUTPUT.PUT_LINE('GOTO: El día no es primo.');
    
    <<fin_proceso>>
    NULL; -- Sentencia requerida para cerrar bloques de etiquetas
END;
/

-- =============================================================================
-- SECCIÓN 4: ESTRUCTURAS DE REPETICIÓN (BUCLES Y LOOPS)
-- =============================================================================

-- Bucle Indefinido (LOOP): Generación controlada de la serie de Fibonacci
DECLARE 
    vn_a NUMBER := 0;
    vn_b NUMBER := 1;
    vn_c NUMBER;
BEGIN
    LOOP 
        EXIT WHEN vn_a > 100;
        DBMS_OUTPUT.PUT_LINE('Fibonacci: ' || vn_a);
        vn_c := vn_a + vn_b;
        vn_a := vn_b;
        vn_b := vn_c;
    END LOOP;
END;
/

-- Bucle Condicional (WHILE): Algoritmo de Euclides para MCD y MCM
DECLARE
    vn_a   NUMBER := 12;
    vn_b   NUMBER := 18;
    vn_mcd NUMBER;
    vn_mcm NUMBER;
    vn_x   NUMBER;
    vn_y   NUMBER;
BEGIN
    vn_x := vn_a;
    vn_y := vn_b;

    WHILE vn_y != 0 LOOP
        vn_mcd := MOD(vn_x, vn_y);
        vn_x := vn_y;
        vn_y := vn_mcd;
    END LOOP;

    vn_mcd := vn_x;
    vn_mcm := (vn_a * vn_b) / vn_mcd;

    DBMS_OUTPUT.PUT_LINE('Cálculo: MCD = ' || vn_mcd || ' | MCM = ' || vn_mcm);
END;
/

-- Bucle Iterativo (FOR REVERSE): Imprimir números pares en cuenta regresiva
BEGIN
    FOR x IN REVERSE 1..50 LOOP
        DBMS_OUTPUT.PUT_LINE('Par en reversa: ' || (2 * x));
    END LOOP;
END;
/

-- Bucle Iterativo (FOR): Búsqueda y validación de raíces cuadradas exactas
DECLARE
    vn_numerouno  NUMBER := 49;
    vn_numeroraiz NUMBER := 0;
BEGIN
    FOR vn_numeroraiz IN 1..SQRT(vn_numerouno) LOOP
        IF ((vn_numeroraiz * vn_numeroraiz) = vn_numerouno) THEN 
            DBMS_OUTPUT.PUT_LINE('La raíz exacta de ' || vn_numerouno || ' es: ' || vn_numeroraiz);
        END IF;
    END LOOP;
END;
/

-- =============================================================================
-- SECCIÓN 5: OBJETOS DE BASE DE DATOS (PROGRAMACIÓN DE SERVIDOR)
-- =============================================================================

-- Creación de un Procedimiento Almacenado con parámetros de entrada (IN)
CREATE OR REPLACE PROCEDURE sp_saludo (
    param_lala IN VARCHAR2
)
/*
Autor: Andres Gonzalez
Fecha de Modificación: 19/05/2026
Descripción: Procedimiento introductorio para la parametrización de salidas en consola.
*/ 
IS
    vv_mensaje_final VARCHAR2(100);
BEGIN
    vv_mensaje_final := 'Hola mundo, parámetro recibido: ' || param_lala;
    DBMS_OUTPUT.PUT_LINE(vv_mensaje_final);
END;
/

-- Ejecución del Procedimiento Almacenado mediante bloque anónimo
BEGIN
    sp_saludo('Ejecución Portafolio');
END;
/

-- Nota de administración: Para eliminar el objeto de la base de datos se ejecuta:
-- DROP PROCEDURE sp_saludo;

-- =============================================================================
-- SECCIÓN 6: CONSULTAS AVANZADAS CON FUNCIONES DE FECHA
-- =============================================================================

-- Consulta Dinámica: Cálculo exacto del último viernes del mes en curso
SELECT NEXT_DAY(LAST_DAY(SYSDATE) - 7, 'VIERNES') AS ultimo_viernes_mes  
FROM DUAL;