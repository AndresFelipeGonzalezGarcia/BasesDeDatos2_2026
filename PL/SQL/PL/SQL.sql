-- Se escribe esto para poder ver la respuesta del codigo en la consola
SET SERVEROUTPUT ON;

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
-------------------------------------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------------------------------------
-- Estructuras de control
-- IF
DECLARE
    vd_current_date NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'DD')); 
BEGIN
    IF vd_current_date IN (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31) THEN
        dbms_output.put_line('HOLA PRIMO');
    ELSE 
        dbms_output.put_line('NO ES PRIMO');
    END IF; 
END;
/
-------------------------------------------------------------------------------------------------------------------------------------------------
-- GOTO
DECLARE
    vd_current_date NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'DD')); 
BEGIN
    IF vd_current_date IN (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31) THEN
        GOTO primo;
    ELSE 
        GOTO noprimo;
    END IF; 
-------------------------------------------------------------------------------------------------------------------------------------------------
-- LOOP
 
DECLARE 
    vn_a NUMBER := 0;
    vn_b NUMBER := 1;
    vn_c NUMBER;
BEGIN
 
    loop 
    EXIT WHEN a > 100;
    DBMS_OUTPUT.PUT_LINE(a);
    vn_c := vn_a + vn_b;
    vn_a := vn_b;
    vn_b := vn_c;
    END LOOP;
END;
/
-------------------------------------------------------------------------------------------------------------------------------------------------
-- WHILE 
DECLARE
   a NUMBER := 12;
   b NUMBER := 18;
   mcd NUMBER;
   mcm NUMBER;
   x NUMBER;
   y NUMBER;
BEGIN
   x := a;
   y := b;
 
 
   WHILE y != 0 LOOP
      mcd := MOD(x, y);
      x := y;
      y := mcd;
   END LOOP;
 
   mcd := x;
 
 
   mcm := (a * b) / mcd;
 
   DBMS_OUTPUT.PUT_LINE('El MCM es: ' || mcm);
END;
/
-------------------------------------------------------------------------------------------------------------------------------------------------
-- FOR
BEGIN
FOR X IN REVERSE 1..50 LOOP
	dbms_output.put_line(2*X);
	END LOOP;
END;

DECLARE
    vn_numerouno NUMBER := 49;
    vn_numeroraiz NUMBER := 0;
 
BEGIN
    FOR vn_numeroraiz IN 1..SQRT(vn_numerouno) LOOP
        IF ((vn_numeroraiz * vn_numeroraiz)= vn_numerouno) THEN 
            dbms_output.put_line(vn_numeroraiz);
        END IF;
    END LOOP;
END;
/
-------------------------------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO ALMACENADO
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE sp_saludo ( --> sp es el proceso almacenado o el nombre del método
    param_lala IN VARCHAR2
)
/*
Autor: Andres Gonzalez
Fecha: 23/02/26
Descripcion: Trabajo en clase
*/ IS
    vv_mensaje_final VARCHAR2(100);
BEGIN
    vv_mensaje_final := 'hola mundo ' || param_lala; --> || concatena ´´ lo que esta dentro de las comillas simples se llama literales
    dbms_output.put_line(vv_mensaje_final);
END;
/

BEGIN
    sp_saludo('lala');
END;
/ --> salto de linea
-- Para borrar el procedimiento se hace
DROP PROCEDURE sp_saludo;

-- CONSULTA PARA CADA ULTIMO VIERNES DE CUALQUIER MES
SELECT NEXT_DAY(LAST_DAY (SYSDATE)-7, 'VIERNES')  
FROM DUAL 
