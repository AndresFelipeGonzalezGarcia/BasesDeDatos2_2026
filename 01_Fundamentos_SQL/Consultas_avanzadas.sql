
/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Consultas Multitabla, Funciones de Agregación y Modelado Relacional
Descripción: Script enfocado en consultas SQL avanzadas usando el esquema HR
             de Oracle y posteriormente la construcción de un modelo relacional.
================================================================================
*/
-- =============================================================================
-- CONSULTA 1
-- Empleados que han tenido más de un cargo en la compañía
-- Uso de GROUP BY y HAVING para filtrar agregaciones
-- =============================================================================

SELECT
    E.FIRST_NAME,
    H.EMPLOYEE_ID,
    COUNT(*) AS JOB_COUNT
FROM HR.JOB_HISTORY H
INNER JOIN HR.EMPLOYEES E
    ON H.EMPLOYEE_ID = E.EMPLOYEE_ID
GROUP BY
    E.FIRST_NAME,
    H.EMPLOYEE_ID
HAVING COUNT(*) > 1;

-- =============================================================================
-- CONSULTA 2
-- Empleados que trabajan en Europa y tienen salario entre 6000 y 10000
-- Uso de joins encadenados entre regiones, países y departamentos
-- =============================================================================

SELECT
    E.FIRST_NAME || ' ' || E.LAST_NAME AS NOMBRE_COMPLETO,
    C.COUNTRY_NAME,
    E.SALARY
FROM HR.REGIONS R
INNER JOIN HR.COUNTRIES C
    ON R.REGION_ID = C.REGION_ID
INNER JOIN HR.LOCATIONS L
    ON C.COUNTRY_ID = L.COUNTRY_ID
INNER JOIN HR.DEPARTMENTS D
    ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN HR.EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE R.REGION_ID = 1
AND E.SALARY BETWEEN 6000 AND 10000;

-- =============================================================================
-- CONSULTA 3
-- Relación jerárquica entre empleados y jefes
-- Uso de SELF JOIN y funciones de texto
-- =============================================================================

SELECT
    E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLEADO,

    LPAD(SUBSTR(E.EMAIL, 1, 3), 9, '*')
        AS EMAIL_EMPLEADO,

    M.FIRST_NAME || ' ' || M.LAST_NAME
        AS JEFE,

    LPAD(SUBSTR(M.EMAIL, 1, 3), 9, '*')
        AS EMAIL_JEFE

FROM HR.EMPLOYEES E

LEFT JOIN HR.EMPLOYEES M
    ON E.MANAGER_ID = M.EMPLOYEE_ID

ORDER BY EMPLEADO;

-- =============================================================================
-- CONSULTA 4
-- Creación de copia completa de la tabla EMPLOYEES
-- Uso de CREATE TABLE AS SELECT
-- =============================================================================

CREATE TABLE EMPLEADOS AS
SELECT *
FROM HR.EMPLOYEES;

-- =============================================================================
-- MODELO RELACIONAL - SISTEMA EDITORIAL
-- Clase 11 de febrero
-- =============================================================================

-- =============================================================================
-- TABLA: TITLE
-- Almacena información de libros publicados
-- =============================================================================

CREATE TABLE TITLE (
    TITLEID          NUMBER NOT NULL,
    TITLENAME        VARCHAR2(50) NOT NULL,
    PRICE            NUMBER(5,2) NOT NULL,
    ADVANCE          NUMBER(8,2) NOT NULL,
    ROYALTY          NUMBER(5,2),
    PUBLICATIONDATE  DATE NOT NULL
);

-- =============================================================================
-- TABLA: AUTHOR
-- Información de autores
-- =============================================================================

CREATE TABLE AUTHOR (
    AUTHORID         NUMBER NOT NULL,
    FIRSTNAME        VARCHAR2(30) NOT NULL,
    MIDDLENAME       VARCHAR2(30),
    LASTNAME         VARCHAR2(30) NOT NULL,
    PAYMENTMETHOD    VARCHAR2(50) NOT NULL
);

-- =============================================================================
-- TABLA: TITLEAUTHOR
-- Relación muchos a muchos entre libros y autores
-- =============================================================================

CREATE TABLE TITLEAUTHOR (
    TITLEID       NUMBER(10) NOT NULL,
    AUTHORID      NUMBER(10) NOT NULL,
    AUTHORORDER   NUMBER(10) NOT NULL
);

-- =============================================================================
-- TABLA: CUSTOMER
-- Información de clientes
-- =============================================================================

CREATE TABLE CUSTOMER (
    CUSTOMERID    NUMBER(10) NOT NULL,
    FIRSTNAME     VARCHAR2(30) NOT NULL,
    LASTNAME      VARCHAR2(30) NOT NULL,
    ADDRESS       VARCHAR2(50),
    CITY          VARCHAR2(50),
    STATE         VARCHAR2(5),
    ZIP           VARCHAR2(10),
    COUNTRY       VARCHAR2(50)
);

-- =============================================================================
-- TABLA: ORDERHEADER
-- Encabezado principal de pedidos
-- =============================================================================

CREATE TABLE ORDERHEADER (
    ORDERID        NUMBER(10) NOT NULL,
    CUSTOMERID     NUMBER(10) NOT NULL,
    PROMOTIONID    NUMBER(10),
    ORDERDATE      DATE NOT NULL
);

-- =============================================================================
-- TABLA: ORDERITEM
-- Detalle de productos por pedido
-- =============================================================================

CREATE TABLE ORDERITEM (
    ORDERID      NUMBER(10) NOT NULL,
    ORDERITEM    NUMBER(10) NOT NULL,
    TITLEID      NUMBER(10) NOT NULL,
    QUANTITY     NUMBER(10) NOT NULL,
    ITEMPRICE    NUMBER(5,2) NOT NULL
);

-- =============================================================================
-- TABLA: PROMOTION
-- Información de promociones comerciales
-- =============================================================================

CREATE TABLE PROMOTION (
    PROMOTIONID          NUMBER(10) NOT NULL,
    PROMOTIONCODE        VARCHAR2(10) NOT NULL,
    PROMOTIONSTARTDATE   DATE NOT NULL,
    PROMOTIONENDDATE     DATE NOT NULL
);

-- =============================================================================
-- INSERCIÓN DE DATOS - TITLE
-- =============================================================================

INSERT INTO TITLE VALUES
(101, 'Pride and Predicates', 9.95, 5000, 15,
TO_DATE('2015-04-30', 'YYYY-MM-DD'));

INSERT INTO TITLE VALUES
(102, 'The Join Luck Club', 9.95, 6000, 12,
TO_DATE('2016-02-06', 'YYYY-MM-DD'));

INSERT INTO TITLE VALUES
(103, 'Catcher in the Try', 8.95, 5000, 10,
TO_DATE('2017-04-03', 'YYYY-MM-DD'));

-- =============================================================================
-- INSERCIÓN DE DATOS - AUTHOR
-- =============================================================================

INSERT INTO AUTHOR VALUES
(1, 'Paul', 'K', 'Tripp', 'Cash');

INSERT INTO AUTHOR VALUES
(2, 'Doug', NULL, 'Li', 'Check');

INSERT INTO AUTHOR VALUES
(3, 'Jen', NULL, 'Strong', 'Check');

-- =============================================================================
-- INSERCIÓN DE DATOS - TITLEAUTHOR
-- =============================================================================

INSERT INTO TITLEAUTHOR VALUES (101, 2, 1);
INSERT INTO TITLEAUTHOR VALUES (102, 3, 1);
INSERT INTO TITLEAUTHOR VALUES (103, 4, 1);

-- =============================================================================
-- INSERCIÓN DE DATOS - CUSTOMER
-- =============================================================================

INSERT INTO CUSTOMER VALUES
(1, 'Chris', 'Dixon', '212 N Rose St',
'Lakewood', 'CO', '80215', 'USA');

INSERT INTO CUSTOMER VALUES
(2, 'David', 'Power', '44 Wiley St',
'Henderson', 'NV', '89002', 'USA');

-- =============================================================================
-- INSERCIÓN DE DATOS - PROMOTION
-- =============================================================================

INSERT INTO PROMOTION VALUES
(
    1,
    '2OFF2015',
    TO_DATE('2011-11-01', 'YYYY-MM-DD'),
    TO_DATE('2011-11-30', 'YYYY-MM-DD')
);

-- =============================================================================
-- INSERCIÓN MASIVA - ORDERHEADER
-- Uso de INSERT ALL para carga múltiple
-- =============================================================================

INSERT ALL
    INTO ORDERHEADER VALUES
    (1001, 1, NULL, TO_DATE('2015-06-01', 'YYYY-MM-DD'))

    INTO ORDERHEADER VALUES
    (1002, 2, NULL, TO_DATE('2015-06-15', 'YYYY-MM-DD'))

    INTO ORDERHEADER VALUES
    (1003, 3, NULL, TO_DATE('2015-07-03', 'YYYY-MM-DD'))

SELECT * FROM DUAL;

-- =============================================================================
-- INSERCIÓN MASIVA - ORDERITEM
-- =============================================================================

INSERT ALL
    INTO ORDERITEM VALUES (1001, 1, 101, 1, 9.95)

    INTO ORDERITEM VALUES (1002, 1, 101, 1, 9.95)

    INTO ORDERITEM VALUES (1003, 1, 101, 1, 9.95)

SELECT * FROM DUAL;

-- =============================================================================
-- CONFIRMACIÓN DE TRANSACCIONES
-- =============================================================================

COMMIT;