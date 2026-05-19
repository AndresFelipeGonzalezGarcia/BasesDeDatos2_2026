
/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Creación de Modelo Relacional y Carga Inicial de Datos

Descripción: Script de práctica orientado al modelado de una base de datos editorial.
             Incluye creación de tablas, inserción masiva de registros y manejo básico
             de relaciones entre entidades.
================================================================================
*/


-- =============================================================================
-- TABLA: TITLE
-- Guarda la información de libros publicados
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
-- Relación entre libros y autores
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
-- Detalle de productos asociados a cada pedido
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
-- TABLA: MYFIRSTQUERY
-- Tabla simple usada para pruebas iniciales
-- =============================================================================

CREATE TABLE MYFIRSTQUERY (
    OUTCOME VARCHAR2(20) NOT NULL
);

-- =============================================================================
-- INSERCIÓN DE DATOS EN TITLE
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

INSERT INTO TITLE VALUES
(104, 'Anne of Fact Tables', 12.95, 10000, 15,
TO_DATE('2018-01-12', 'YYYY-MM-DD'));

-- =============================================================================
-- INSERCIÓN DE DATOS EN AUTHOR
-- =============================================================================

INSERT INTO AUTHOR VALUES
(1, 'Paul', 'K', 'Tripp', 'Cash');

INSERT INTO AUTHOR VALUES
(2, 'Doug', NULL, 'Li', 'Check');

INSERT INTO AUTHOR VALUES
(3, 'Jen', NULL, 'Strong', 'Check');

-- =============================================================================
-- INSERCIÓN DE DATOS EN TITLEAUTHOR
-- =============================================================================

INSERT INTO TITLEAUTHOR VALUES (101, 2, 1);
INSERT INTO TITLEAUTHOR VALUES (102, 3, 1);
INSERT INTO TITLEAUTHOR VALUES (103, 4, 1);

-- =============================================================================
-- INSERCIÓN DE DATOS EN CUSTOMER
-- =============================================================================

INSERT INTO CUSTOMER VALUES
(1, 'Chris', 'Dixon', '212 N Rose St',
'Lakewood', 'CO', '80215', 'USA');

INSERT INTO CUSTOMER VALUES
(2, 'David', 'Power', '44 Wiley St',
'Henderson', 'NV', '89002', 'USA');

-- =============================================================================
-- INSERCIÓN DE DATOS EN PROMOTION
-- =============================================================================

INSERT INTO PROMOTION VALUES
(
    1,
    '2OFF2015',
    TO_DATE('2011-11-01', 'YYYY-MM-DD'),
    TO_DATE('2011-11-30', 'YYYY-MM-DD')
);

-- =============================================================================
-- INSERCIÓN MASIVA EN ORDERHEADER
-- Uso de INSERT ALL para múltiples registros
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
-- INSERCIÓN MASIVA EN ORDERITEM
-- =============================================================================

INSERT ALL

    INTO ORDERITEM VALUES
    (1001, 1, 101, 1, 9.95)

    INTO ORDERITEM VALUES
    (1002, 1, 101, 1, 9.95)

    INTO ORDERITEM VALUES
    (1003, 1, 101, 1, 9.95)

SELECT * FROM DUAL;

-- =============================================================================
-- PRUEBA BÁSICA DE INSERCIÓN
-- =============================================================================

INSERT INTO MYFIRSTQUERY
VALUES ('Hello, World!');

-- =============================================================================
-- CONFIRMACIÓN DE TRANSACCIONES
-- =============================================================================

COMMIT;