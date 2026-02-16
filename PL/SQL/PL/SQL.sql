-- PRIMER HOLA MUNDO
-- Manera uno:
DECLARE
    vv_miPrimeraVariable VARCHAR2(50);
BEGIN
        vv_miPrimeraVariable := 'Hola mundo';
	dbms_output.put_line(vv_miPrimeraVariable);
END;
/
-- Manera dos:
DECLARE
    vv_miPrimeraVariable VARCHAR2(50) := 'Hola mundo' ;
BEGIN    
	dbms_output.put_line(vv_miPrimeraVariable);
END;
/
-- Como llamar un dato de una base de datos y mostrarlo como informacion
DECLARE
    vv_nombre VARCHAR2(50) ; --> Variables
    vv_apellido VARCHAR2(50) ;
BEGIN
SELECT
    first_name,
    last_name
INTO
    vv_nombre,
    vv_apellido
FROM
    hr.employees
WHERE
    employee_id = 110;
dbms_output.put_line('El nombre del empleado es: ' --> Esto es un literal
                     || vv_nombre --> || se usa para concatenar
                     || vv_apellido);
end;
/
-- Como tener una variable "universal" em PLSQL
DECLARE
    vv_nombre   HR.EMPLOYEES.FIRST_NAME%TYPE; --> El %TYPE pone el tipo de dato universal
    vv_apellido HR.EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    SELECT
        first_name,
        last_name
    INTO
        vv_nombre,
        vv_apellido
    FROM
        hr.employees
    WHERE
        employee_id = 110;

dbms_output.put_line('El nombre del empleado es: '
                     || vv_nombre || ' ' 
                     || vv_apellido );
        end;
/
-- Como llamar toda la info de las columnas
DECLARE
    vv_empleado HR.EMPLOYEES%ROWTYPE; --> Se usa ROWTYPE para llamar todas las columnas
BEGIN
SELECT
    *
INTO
    vv_empleado
FROM
    hr.employees
WHERE
    employee_id = 110; --> Bloque anonimo desde select hasta el where

dbms_output.put_line('El nombre del empleado es: '
                     || vv_empleado.FIRST_NAME); --> Si quiero llamar un dato especifico de la base
        end;
/