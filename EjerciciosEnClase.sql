-- 1. Cuantos empleados han pasado por mas de un cargo en la compañía
SELECT 
    E.FIRST_NAME, H.EMPLOYEE_ID, COUNT(*) AS job_count
FROM 
        HR.JOB_HISTORY H 
    JOIN HR.EMPLOYEES E ON H.EMPLOYEE_ID = E.EMPLOYEE_ID
GROUP BY
    E.FIRST_NAME, H.EMPLOYEE_ID
HAVING COUNT (*) > 1;
-- 2. Identifique todos los empleados que vivan o trabajen en Europa y tengan rango entre un salario entre 4 mil dólares y 6 mil dólares .
-- Mostrar Columnas
-- 1.Nombre y apellidos una solo columna
-- 2.País al que pertenece
-- 3.Salario que tiene
SELECT
    E.FIRST_NAME|| ' ' ||  E.LAST_NAME AS NOMBRECOMPLETO,
    C.COUNTRY_NAME,
    E.SALARY
FROM
         HR.REGIONS R
    INNER JOIN HR.COUNTRIES   C ON R.REGION_ID = C.REGION_ID
    INNER JOIN HR.LOCATIONS   L ON C.COUNTRY_ID = L.COUNTRY_ID
    INNER JOIN HR.DEPARTMENTS D ON L.LOCATION_ID = D.LOCATION_ID
    INNER JOIN HR.EMPLOYEES   E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE
    R.REGION_ID = 10 AND E.SALARY BETWEEN 6000 AND 10000;

-- 3. Proyectar orden jerarquico de los cargos de los empleados, mostrar el nombre del empelado y sus jefes y extraer emails de los dos (Las primeras 3 letras, Luego rellenar 6 asteriscos a la izquierda)
 SELECT
  
    E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLEADO,
    LPAD(SUBSTR(E.EMAIL, 1, 3), 9, '*') AS EMAIL_EMPLEADO,

    M.FIRST_NAME || ' ' || M.LAST_NAME AS JEFE,
    LPAD(SUBSTR(M.EMAIL, 1, 3), 9, '*') AS EMAIL_JEFE
FROM
    HR.EMPLOYEES E
    LEFT JOIN HR.EMPLOYEES M
        ON E.MANAGER_ID = M.EMPLOYEE_ID

ORDER BY
    EMPLEADO;
-- 4. Creación de tabla propia pero duplicada
CREATE TABLE EMPLEADOS AS SELECT  
    * 
FROM 
    HR.EMPLOYEES;
-- 5...