/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Definición de Datos (DDL), Manipulación (DML) y Fundamentos de Esquemas
Descripción: Script de inicialización del modelo de datos de la librería. 
             Incluye la creación de tablas, restricciones de integridad, 
             poblado de registros (inserts estructurados) y notas de fundamentos.
================================================================================
*/

-- =============================================================================
-- SECCIÓN 1: DEFINICIÓN DE ESTRUCTURAS (DDL - CREATE TABLES)
-- =============================================================================

-- 1.1 Tabla base de Empleados (Esquema de Recursos Humanos)
CREATE TABLE employees (
    employee_id    NUMBER(6),
    first_name     VARCHAR2(20),
    last_name      VARCHAR2(25) CONSTRAINT emp_last_name_nn NOT NULL,
    email          VARCHAR2(25) CONSTRAINT emp_email_nn NOT NULL,
    phone_number   VARCHAR2(20),
    job_id         VARCHAR2(10) CONSTRAINT emp_job_nn NOT NULL,
    salary         NUMBER(8,2),
    commission_pct NUMBER(2,2),
    manager_id     NUMBER(6),
    department_id  NUMBER(4),
    hire_date      DATE         CONSTRAINT emp_hire_date_nn NOT NULL,
    CONSTRAINT emp_salary_min   CHECK (salary > 0),
    CONSTRAINT emp_email_uk     UNIQUE (email)
);

/*
================================================================================
NOTAS TÉCNICAS DE COPIADO DE TABLAS (CTAS - Create Table As Select):
--------------------------------------------------------------------------------
-- Clonación completa de estructura y datos:
-- CREATE TABLE employees_2 AS SELECT * FROM hr.employees;

-- Clonación de columnas específicas con filtrado de dominio:
-- CREATE TABLE employees_2 AS SELECT first_name, last_name FROM hr.employees WHERE department_id = 80;

-- Clonación alias de alias de proyección completa:
-- CREATE TABLE employees_2 AS SELECT e.* FROM hr.employees e;
================================================================================
*/

-- 1.2 Tabla de Libros / Títulos
CREATE TABLE Title (
    TitleID         NUMBER NOT NULL,
    TitleName       VARCHAR2(50) NOT NULL,
    Price           NUMBER(5,2) NOT NULL,
    Advance         NUMBER(8,2) NOT NULL,
    Royalty         NUMBER(5,2),
    PublicationDate DATE NOT NULL
);

-- 1.3 Tabla de Autores
CREATE TABLE Author (
    AuthorID      NUMBER NOT NULL,
    FirstName     VARCHAR2(30) NOT NULL,
    MiddleName    VARCHAR2(30),
    LastName      VARCHAR2(30) NOT NULL,
    PaymentMethod VARCHAR2(50) NOT NULL
);

-- 1.4 Tabla Intermedia: Relación Muchos a Muchos (Títulos y Autores)
CREATE TABLE TitleAuthor (
    TitleID     NUMBER(10) NOT NULL,
    AuthorID    NUMBER(10) NOT NULL,
    AuthorOrder NUMBER(10) NOT NULL
);

-- 1.5 Tabla de Clientes
CREATE TABLE Customer (
    CustomerID NUMBER(10) NOT NULL,
    FirstName  VARCHAR2(30) NOT NULL,
    LastName   VARCHAR2(30) NOT NULL,
    Address    VARCHAR2(50),
    City       VARCHAR2(50),
    State      VARCHAR2(5),
    Zip        VARCHAR2(10),
    Country    VARCHAR2(50)
);

-- 1.6 Tabla de Encabezado de Órdenes / Pedidos
CREATE TABLE OrderHeader (
    OrderID     NUMBER(10) NOT NULL,
    CustomerID  NUMBER(10) NOT NULL,
    PromotionID NUMBER(10),
    OrderDate   DATE NOT NULL
);

-- 1.7 Tabla de Detalle de Órdenes (Líneas de Pedido)
CREATE TABLE OrderItem (
    OrderID   NUMBER(10) NOT NULL,
    OrderItem NUMBER(10) NOT NULL,
    TitleID   NUMBER(10) NOT NULL,
    Quantity  NUMBER(10) NOT NULL,
    ItemPrice NUMBER(5,2) NOT NULL
);

-- 1.8 Tabla de Promociones y Campañas Comerciales
CREATE TABLE Promotion (
    PromotionID        NUMBER(10) NOT NULL,
    PromotionCode      VARCHAR2(10) NOT NULL,
    PromotionStartDate DATE NOT NULL,
    PromotionEndDate   DATE NOT NULL
);

-- 1.9 Tabla de Pruebas Iniciales
CREATE TABLE MyFirstQuery (
    Outcome VARCHAR2(20) NOT NULL
);


-- =============================================================================
-- SECCIÓN 2: POBLADO DE DATOS (DML - INSERTS)
-- =============================================================================

-- 2.1 Inserciones en la tabla Title
INSERT INTO Title VALUES (101, 'Pride and Predicates', 9.95, 5000, 15, TO_DATE('2015-04-30', 'YYYY-MM-DD'));
INSERT INTO Title VALUES (102, 'The Join Luck Club', 9.95, 6000, 12, TO_DATE('2016-02-06', 'YYYY-MM-DD'));
INSERT INTO Title VALUES (103, 'Catcher in the Try', 8.95, 5000, 10, TO_DATE('2017-04-03', 'YYYY-MM-DD'));
INSERT INTO Title VALUES (104, 'Anne of Fact Tables', 12.95, 10000, 15, TO_DATE('2018-01-12', 'YYYY-MM-DD'));
INSERT INTO Title VALUES (105, 'The DateTime Machine', 7.95, 5500, 15, TO_DATE('2019-02-04', 'YYYY-MM-DD'));
INSERT INTO Title VALUES (106, 'The Great GroupBy', 10.95, 0, 20, TO_DATE('2019-12-23', 'YYYY-MM-DD'));
INSERT INTO Title VALUES (107, 'The Call of the While', 8.95, 2500, 15, TO_DATE('2020-03-14', 'YYYY-MM-DD'));
INSERT INTO Title VALUES (108, 'The Sum Also Rises', 7.95, 5000, 12, TO_DATE('2021-11-12', 'YYYY-MM-DD'));

-- 2.2 Inserciones en la tabla Author
INSERT INTO Author VALUES (1, 'Paul', 'K', 'Tripp', 'Cash');
INSERT INTO Author VALUES (2, 'Doug', NULL, 'Li', 'Check');
INSERT INTO Author VALUES (3, 'Jen', NULL, 'Strong', 'Check');
INSERT INTO Author VALUES (4, 'Jorge', 'Armando', 'Guerra', 'Check');
INSERT INTO Author VALUES (5, 'Robert', 'Grant', 'Davidson', 'Check');
INSERT INTO Author VALUES (6, 'Gail', 'Anne', 'Shawn', 'Check');
INSERT INTO Author VALUES (7, 'Rebecca', NULL, 'Miller', 'Check');
INSERT INTO Author VALUES (8, 'Andy', NULL, 'Melkin', 'Direct Deposit');
INSERT INTO Author VALUES (9, 'Buck', NULL, 'Fernandez', 'Cash');
INSERT INTO Author VALUES (10, 'Chris', NULL, 'Walenski', 'Direct Deposit');
INSERT INTO Author VALUES (11, 'Deepthi', NULL, 'Mahadevan', 'Direct Deposit');

-- 2.3 Inserciones en la tabla TitleAuthor
INSERT INTO TitleAuthor VALUES (101, 2, 1);
INSERT INTO TitleAuthor VALUES (102, 3, 1);
INSERT INTO TitleAuthor VALUES (103, 4, 1);
INSERT INTO TitleAuthor VALUES (104, 5, 1);
INSERT INTO TitleAuthor VALUES (105, 6, 1);
INSERT INTO TitleAuthor VALUES (106, 7, 1);
INSERT INTO TitleAuthor VALUES (107, 11, 1);
INSERT INTO TitleAuthor VALUES (107, 1, 2);
INSERT INTO TitleAuthor VALUES (108, 8, 1);
INSERT INTO TitleAuthor VALUES (108, 9, 2);
INSERT INTO TitleAuthor VALUES (108, 10, 3);

-- 2.4 Inserciones en la tabla Customer
INSERT INTO Customer VALUES (1, 'Chris', 'Dixon', '212 N Rose St', 'Lakewood', 'CO', '80215', 'USA');
INSERT INTO Customer VALUES (2, 'David', 'Power', '44 Wiley St', 'Henderson', 'NV', '89002', 'USA');
INSERT INTO Customer VALUES (3, 'Arnold', 'Hinchcliffe', '7333 E Levine St', 'Atlanta', 'GA', '30303', 'USA');
INSERT INTO Customer VALUES (4, 'Keanu', 'O''Ward', '415 N Hinson St', 'Madison', 'WI', '53703', 'USA');
INSERT INTO Customer VALUES (5, 'Lisa', 'Rosenqvist', '56 S Burnett St', 'Reston', 'VA', '20190', 'USA');
INSERT INTO Customer VALUES (6, 'Maggie', 'Ilott', '111 Fuson St', 'Flagstaff', 'AZ', '86015', 'USA');
INSERT INTO Customer VALUES (7, 'Cora', 'Daly', '55 S Brandt St', 'Anaheim', 'CA', '92802', 'USA');
INSERT INTO Customer VALUES (8, 'Dan', 'Wilson', '29 W Pousson St', 'Seattle', 'WA', '98104', 'USA');
INSERT INTO Customer VALUES (9, 'Kelly', 'Wheldon', '300 Dewsnup St', 'Boise', 'ID', '83703', 'USA');
INSERT INTO Customer VALUES (10, 'Bhaskar', 'Palou', '3443 E Ramella St', 'Evansville', 'IN', '47702', 'USA');
INSERT INTO Customer VALUES (11, 'Kevin', 'Daly', '123 Terry St', 'Rochester', 'NY', '02345', 'USA');
INSERT INTO Customer VALUES (12, 'Jordan', 'Ericsson', '187 E Boich St', 'Gilbert', 'AZ', '85296', 'USA');
INSERT INTO Customer VALUES (13, 'Ming', 'Zhou', '42 S Walsh St', 'Portsmouth', 'NH', '03801', 'USA');
INSERT INTO Customer VALUES (14, 'Jack', 'Sato', '242 S Corbett St', 'Burlington', 'VT', '05401', 'USA');
INSERT INTO Customer VALUES (15, 'Joe', 'Pagenaud', '59 E Fleming St', 'Detroit', 'MI', '48202', 'USA');
INSERT INTO Customer VALUES (16, 'Tara', 'Di Silvestro', '789 N Kizer St', 'San Diego', 'CA', '92101', 'USA');
INSERT INTO Customer VALUES (17, 'Sandra', 'Calderon', '5 W Delany St', 'Denver', 'CO', '80014', 'USA');
INSERT INTO Customer VALUES (18, 'Margaret', 'Montoya', '48 Clark St', 'Monterey', 'CA', '93940', 'USA');
INSERT INTO Customer VALUES (19, 'Monica', 'Newgarden', '99 Lynn St', 'Clayton', 'MO', '63105', 'USA');
INSERT INTO Customer VALUES (20, 'Mia', 'Rossi', '276 N Morrison St', 'Orlando', 'FL', '32801', 'USA');

-- 2.5 Inserciones en la tabla Promotion
INSERT INTO Promotion VALUES (1, '2OFF2015', TO_DATE('2011-11-01', 'YYYY-MM-DD'), TO_DATE('2011-11-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (2, '2OFF2016', TO_DATE('2012-11-01', 'YYYY-MM-DD'), TO_DATE('2012-11-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (3, '2OFF2017', TO_DATE('2013-11-01', 'YYYY-MM-DD'), TO_DATE('2013-11-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (4, '1OFF2018', TO_DATE('2014-06-01', 'YYYY-MM-DD'), TO_DATE('2014-06-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (5, '2OFF2018', TO_DATE('2014-11-01', 'YYYY-MM-DD'), TO_DATE('2014-11-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (6, '1OFF2019', TO_DATE('2015-06-01', 'YYYY-MM-DD'), TO_DATE('2015-06-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (7, '2OFF2019', TO_DATE('2015-11-01', 'YYYY-MM-DD'), TO_DATE('2015-11-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (8, '1OFF2020', TO_DATE('2016-06-01', 'YYYY-MM-DD'), TO_DATE('2016-06-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (9, '2OFF2020', TO_DATE('2016-11-01', 'YYYY-MM-DD'), TO_DATE('2016-11-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (10, '1OFF2021', TO_DATE('2017-06-01', 'YYYY-MM-DD'), TO_DATE('2017-06-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (11, '2OFF2021', TO_DATE('2017-11-01', 'YYYY-MM-DD'), TO_DATE('2017-11-30', 'YYYY-MM-DD'));
INSERT INTO Promotion VALUES (12, '3OFF2022', TO_DATE('2018-03-04', 'YYYY-MM-DD'), TO_DATE('2018-03-11', 'YYYY-MM-DD'));

-- 2.6 Inserciones por Lotes en la tabla OrderHeader (Uso de INSERT ALL)
INSERT ALL
    INTO OrderHeader VALUES (1001, 1, NULL, TO_DATE('2015-06-01', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1002, 2, NULL, TO_DATE('2015-06-15', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1003, 3, NULL, TO_DATE('2015-07-03', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1004, 4, NULL, TO_DATE('2015-08-12', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1005, 5, NULL, TO_DATE('2015-09-05', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1006, 6, 1, TO_DATE('2015-11-02', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1007, 7, 1, TO_DATE('2015-11-15', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1008, 8, 1, TO_DATE('2015-11-22', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1009, 9, NULL, TO_DATE('2016-02-12', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1010, 3, NULL, TO_DATE('2016-03-01', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1011, 10, NULL, TO_DATE('2016-06-30', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1012, 1, NULL, TO_DATE('2016-09-02', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1013, 6, 2, TO_DATE('2016-11-03', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1014, 11, 2, TO_DATE('2016-11-12', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1015, 5, 2, TO_DATE('2016-11-14', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1016, 7, 2, TO_DATE('2016-11-23', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1017, 12, NULL, TO_DATE('2016-12-08', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1018, 13, NULL, TO_DATE('2017-01-31', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1019, 3, NULL, TO_DATE('2017-04-05', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1020, 8, NULL, TO_DATE('2017-07-22', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1021, 14, NULL, TO_DATE('2017-10-16', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1022, 13, 3, TO_DATE('2017-11-01', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1023, 2, 3, TO_DATE('2017-11-14', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1024, 14, 3, TO_DATE('2017-11-20', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1025, 4, NULL, TO_DATE('2018-01-23', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1026, 5, NULL, TO_DATE('2018-05-25', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1027, 12, 4, TO_DATE('2018-06-14', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1028, 11, 5, TO_DATE('2018-11-01', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1029, 10, 5, TO_DATE('2018-11-11', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1030, 4, NULL, TO_DATE('2019-02-24', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1031, 15, 6, TO_DATE('2019-06-07', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1032, 16, NULL, TO_DATE('2019-08-11', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1033, 9, 7, TO_DATE('2019-11-04', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1034, 10, 7, TO_DATE('2019-11-14', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1035, 4, NULL, TO_DATE('2019-12-29', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1036, 3, NULL, TO_DATE('2020-01-18', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1037, 4, NULL, TO_DATE('2020-03-15', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1038, 17, NULL, TO_DATE('2020-05-22', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1039, 10, NULL, TO_DATE('2020-09-13', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1040, 7, 9, TO_DATE('2020-11-07', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1041, 8, 9, TO_DATE('2020-11-21', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1042, 6, NULL, TO_DATE('2021-01-29', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1043, 18, NULL, TO_DATE('2021-04-23', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1044, 19, NULL, TO_DATE('2021-06-06', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1045, 11, NULL, TO_DATE('2021-10-01', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1046, 4, NULL, TO_DATE('2021-11-13', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1047, 19, NULL, TO_DATE('2021-11-28', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1048, 16, NULL, TO_DATE('2021-01-15', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1049, 20, 12, TO_DATE('2021-03-05', 'YYYY-MM-DD'))
    INTO OrderHeader VALUES (1050, 1, 12, TO_DATE('2022-03-10', 'YYYY-MM-DD'))
SELECT * FROM dual;

-- 2.7 Inserciones por Lotes en la tabla OrderItem (Uso de INSERT ALL)
INSERT ALL
    INTO OrderItem VALUES (1001, 1, 101, 1, 9.95)
    INTO OrderItem VALUES (1002, 1, 101, 1, 9.95)
    INTO OrderItem VALUES (1003, 1, 101, 1, 9.95)
    INTO OrderItem VALUES (1004, 1, 101, 1, 9.95)
    INTO OrderItem VALUES (1005, 1, 101, 1, 9.95)
    INTO OrderItem VALUES (1006, 1, 101, 1, 7.95)
    INTO OrderItem VALUES (1007, 1, 101, 2, 7.95)
    INTO OrderItem VALUES (1008, 1, 101, 1, 7.95)
    INTO OrderItem VALUES (1009, 1, 101, 1, 9.95)
    INTO OrderItem VALUES (1010, 1, 102, 1, 9.95)
    INTO OrderItem VALUES (1011, 1, 102, 1, 9.95)
    INTO OrderItem VALUES (1011, 2, 101, 1, 9.95)
    INTO OrderItem VALUES (1012, 1, 101, 1, 9.95)
    INTO OrderItem VALUES (1012, 2, 102, 1, 9.95)
    INTO OrderItem VALUES (1013, 1, 101, 3, 7.95)
    INTO OrderItem VALUES (1014, 1, 101, 1, 7.95)
    INTO OrderItem VALUES (1014, 2, 102, 1, 7.95)
    INTO OrderItem VALUES (1015, 1, 102, 1, 7.95)
    INTO OrderItem VALUES (1016, 1, 101, 2, 7.95)
    INTO OrderItem VALUES (1017, 1, 102, 1, 9.95)
    INTO OrderItem VALUES (1018, 1, 102, 1, 9.95)
    INTO OrderItem VALUES (1019, 1, 103, 1, 8.95)
    INTO OrderItem VALUES (1020, 1, 103, 1, 8.95)
    INTO OrderItem VALUES (1021, 1, 101, 1, 7.95)
    INTO OrderItem VALUES (1021, 2, 102, 1, 7.95)
    INTO OrderItem VALUES (1021, 3, 103, 1, 6.95)
    INTO OrderItem VALUES (1022, 1, 101, 1, 7.95)
    INTO OrderItem VALUES (1022, 1, 103, 1, 6.95)
    INTO OrderItem VALUES (1023, 1, 102, 1, 7.95)
    INTO OrderItem VALUES (1024, 1, 101, 1, 7.95)
    INTO OrderItem VALUES (1025, 1, 104, 1, 12.95)
    INTO OrderItem VALUES (1026, 1, 103, 1, 7.95)
    INTO OrderItem VALUES (1027, 1, 101, 1, 8.95)
    INTO OrderItem VALUES (1028, 1, 102, 1, 7.95)
    INTO OrderItem VALUES (1028, 2, 103, 1, 6.95)
    INTO OrderItem VALUES (1029, 1, 103, 1, 6.95)
    INTO OrderItem VALUES (1030, 1, 105, 1, 7.95)
    INTO OrderItem VALUES (1031, 1, 105, 1, 6.95)
    INTO OrderItem VALUES (1032, 1, 105, 1, 7.95)
    INTO OrderItem VALUES (1033, 1, 102, 1, 7.95)
    INTO OrderItem VALUES (1033, 2, 103, 1, 6.95)
    INTO OrderItem VALUES (1034, 1, 102, 1, 7.95)
    INTO OrderItem VALUES (1034, 2, 103, 1, 6.95)
    INTO OrderItem VALUES (1034, 3, 104, 1, 10.95)
    INTO OrderItem VALUES (1034, 4, 105, 1, 5.95)
    INTO OrderItem VALUES (1035, 1, 106, 1, 10.95)
    INTO OrderItem VALUES (1036, 1, 105, 1, 7.95)
    INTO OrderItem VALUES (1037, 1, 107, 1, 8.95)
    INTO OrderItem VALUES (1038, 1, 101, 1, 9.95)
    INTO OrderItem VALUES (1039, 1, 105, 1, 7.95)
    INTO OrderItem VALUES (1040, 1, 105, 1, 5.95)
    INTO OrderItem VALUES (1041, 1, 105, 1, 5.95)
    INTO OrderItem VALUES (1041, 2, 107, 1, 6.95)
    INTO OrderItem VALUES (1042, 1, 105, 1, 7.95)
    INTO OrderItem VALUES (1043, 1, 105, 1, 7.95)
    INTO OrderItem VALUES (1044, 1, 105, 1, 6.95)
    INTO OrderItem VALUES (1044, 2, 103, 1, 7.95)
    INTO OrderItem VALUES (1045, 1, 105, 1, 7.95)
    INTO OrderItem VALUES (1046, 1, 108, 1, 5.95)
    INTO OrderItem VALUES (1047, 1, 108, 1, 5.95)
    INTO OrderItem VALUES (1047, 2, 101, 1, 7.95)
    INTO OrderItem VALUES (1048, 1, 105, 1, 7.95)
    INTO OrderItem VALUES (1049, 1, 101, 1, 6.95)
    INTO OrderItem VALUES (1049, 2, 102, 1, 6.95)
    INTO OrderItem VALUES (1049, 3, 103, 1, 5.95)
    INTO OrderItem VALUES (1050, 1, 108, 1, 4.95)
SELECT * FROM dual;

-- 2.8 Fila de control inicial
INSERT INTO MyFirstQuery VALUES ('Hello, World!');

-- Consolidación de transacciones en disco
COMMIT;


-- =============================================================================
-- ANEXO TEÓRICO: MARCO CONCEPTUAL DE ARQUITECTURA DE SERVIDOR (SQL vs PL/SQL)
-- =============================================================================
/*
* SQL: Lenguaje estructurado de consultas propio de las bases de datos relacionales.
* PL/SQL: SÍ es un LENGUAJE DE PROGRAMACIÓN --> Solo usarlo cuando se agoten las opciones SQL.

Flujos de comunicación nativos:
  APP <--- SENTENCIA SQL (Mundo Relacional) ---> BASE DE DATOS.
  SQL Developer ----- String -----> Base De Datos.

* PL/SQL es un lenguaje procedimental, propiedad de ORACLE. Las unidades de programa son 
  las estructuras lógicas complejas que desarrollamos en el servidor.
* PL/SQL NO es sensible a mayúsculas o minúsculas (Case-Insensitive).

Tipos de Datos de Control Estático:
  - Number: Almacena números enteros o flotantes de longitud variable.
  - Boolean: Soporta los estados lógicos independientes TRUE y FALSE.
  - Date: Almacena marcas temporales representadas internamente como datos numéricos.

Reglas estructurales del Bloque Anónimo:
  - DECLARE: Segmento opcional utilizado para la asignación en memoria de variables y objetos locales.
  - BEGIN: Segmento imperativo totalmente obligatorio que delimita la ejecución de la lógica.
  - El uso del punto y coma (;) es una buena práctica mandatoria que aporta organización, precisión y legibilidad.
*/

-- =============================================================================
-- COMPONENTE DE PRUEBAS 
-- =============================================================================

-- Inicialización de consola
SET SERVEROUTPUT ON;

-- Bloque de prueba de impresión de hora de servidor
DECLARE 
    fecha TIMESTAMP;
BEGIN 
    SELECT sysdate INTO fecha FROM dual;
    DBMS_OUTPUT.PUT_LINE('La fecha es: ' || fecha);
END;
/

-- Bloque anónimo básico de validación de búfer
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola mundo');
END;
/

/*
================================================================================
MANUAL DE ESTÁNDARES: PREFIJOS DE NOMENCLATURA REQUERIDOS
================================================================================
* VARIABLES LOCALES:
    - vn_xxxxx  ---> Estándar correcto para variables de tipo numérico (Number).
    - vd_xxxx   ---> Estándar correcto para variables de tipo temporal (Date / Timestamp).
    - vv_xxxx   ---> Estándar correcto para variables de tipo alfanumérico (Varchar2).
    - vdo_xxx   ---> Estándar correcto para variables de precisión flotante (Double).

* CONSTANTES DE ESQUEMA:
    - cn_xxx    ---> Estándar correcto para constantes numéricas.
    - cd_xxx    ---> Estándar correcto para constantes de tipo Date.
    - cv_xxx    ---> Estándar correcto para constantes alfanuméricas.
    - cdo_xxx   ---> Estándar correcto para constantes de tipo Double.
*/

-- Ejercicio Práctico 1: Bloque de asignación e impresión estática
DECLARE
    vv_miPrimeraVariable VARCHAR2(50);
BEGIN
    vv_miPrimeraVariable := 'Hola mundo';
    DBMS_OUTPUT.PUT_LINE(vv_miPrimeraVariable);
END;
/

-- Ejercicio Práctico 2: Inicialización directa en declaración
DECLARE
    vv_miPrimeraVariable VARCHAR2(50) := 'Hola mundo';
BEGIN
    DBMS_OUTPUT.PUT_LINE(vv_miPrimeraVariable);
END;
/

-- Ejercicio Práctico 3: Consulta relacional simple con cláusula INTO
DECLARE
    vv_nombre   VARCHAR2(50);
    vv_apellido VARCHAR2(50);
BEGIN
    SELECT first_name, last_name
    INTO vv_nombre, vv_apellido
    FROM hr.employees
    WHERE employee_id = 110;

    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || vv_nombre || ' ' || vv_apellido);
END;
/

-- Ejercicio Práctico 4: Enlace dinámico mediante atributo estructural %TYPE
DECLARE
    vv_nombre   hr.employees.first_name%TYPE;
    vv_apellido hr.employees.last_name%TYPE;
BEGIN
    SELECT first_name, last_name
    INTO vv_nombre, vv_apellido
    FROM hr.employees
    WHERE employee_id = 110;

    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es (vía %TYPE): ' || vv_nombre || ' ' || vv_apellido);
END;
/

-- Ejercicio Práctico 5: Enlace dinámico de registro completo vía %ROWTYPE
DECLARE
    vv_empleado hr.employees%ROWTYPE;
BEGIN
    SELECT *
    INTO vv_empleado
    FROM hr.employees
    WHERE employee_id = 110;

    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es (vía %ROWTYPE): ' || vv_empleado.first_name || ' ' || vv_empleado.last_name);
END;
/

-- Ejercicio Práctico 6: Demostración controlada de error de cardinalidad en consultas de tipo INTO singular
DECLARE
    vv_empleado hr.employees%ROWTYPE;
BEGIN
    -- NOTA COMPLEMENTARIA: Esta consulta generará la excepción TOO_MANY_ROWS porque viola la 
    -- restricción de fila única del INTO al intentar evaluar un conjunto multivaluado (110, 108).
    SELECT *
    INTO vv_empleado
    FROM hr.employees
    WHERE employee_id IN (110, 108);

    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || vv_empleado.first_name || ' ' || vv_empleado.last_name);
END;
/