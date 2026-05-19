/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Introducción a PL/SQL, Arquitectura de Servidor y Estándares de Nomenclatura
Descripción: Notas de la sesión del 16 de Febrero. Establece las
             bases teóricas del lenguaje procedural, diccionarios de datos,
             tipos de atributos (%TYPE / %ROWTYPE) y prefijos institucionales.
================================================================================
*/

/*
================================================================================
CONCEPTO 1: SQL vs PL/SQL Y ARQUITECTURA DE COMUNICACIÓN
================================================================================
* SQL: Lenguaje estructurado de consultas propio de las bases de datos relacionales.
* PL/SQL: SÍ es un LENGUAJE DE PROGRAMACIÓN --> Solo usarlo cuando se agoten las opciones SQL.

Flujo de ejecución de sentencias:
  APP <--- SENTENCIA SQL (Hablando de las relacionales) ---> BASE DE DATOS.
  SQL Developer ----- String -----> Base De Datos. 
*/

/*
================================================================================
CONCEPTO 2: PROPIEDADES Y UNIDADES LÉXICAS DE PL/SQL
================================================================================
* PL/SQL -> Lenguaje procedimental, Propiedad de ORACLE, unidades de programa: 
            programas que nosotros vamos hacer.
* PL/SQL -> No es sensible a mayúsculas.
* PL/SQL -> Unidades léxicas: grupo de caracteres (5): Delimitadores, Identificadores, 
            Literales, Comentarios, Expresiones.

Definiciones de los grupos de caracteres:
  - Delimitadores: Operadores aritméticos, lógicos y relacionales. EJM: Suma
  - Identificador: Constantes, Cursores, variables, subprograma, excepciones, paquetes. 
                   EJM: v_frame, c_percent
  - Literal: Valor de tipo numérico.
  - Comentarios: Se declaran usando -- (línea simple) o bien / * varias líneas * /

Tipos de Datos Fundamentales:
  - Number: Almacena números enteros o de tipo flotante, virtualmente de cualquier longitud.
  - Boolean: Soporta estados TRUE - FALSE.
  - Date: Almacena fechas internamente como datos numéricos.

Estructura de Bloques:
  - DECLARE: No es necesario en todos los casos.
  - BEGIN: Totalmente necesario.
  - El punto y coma (;) es buena práctica y da más organización y precisión.
*/

-- COMANDO DE ENTORNO: Se ejecuta cada vez que entramos a la base de datos para habilitar la consola.
SET SERVEROUTPUT ON; 

-- Bloque de prueba de captura de tiempo de servidor
DECLARE 
    fecha TIMESTAMP;
BEGIN 
    SELECT sysdate INTO fecha FROM dual;
    DBMS_OUTPUT.PUT_LINE('La fecha es: ' || fecha);
END;
/

-- Bloque anónimo introductorio
-- Nota: Se denomina "Bloque anónimo" porque no le hemos puesto nombre a ese programa.
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola mundo');
END;
/

/*
================================================================================
CONCEPTO 3: MANUAL DE ESTÁNDARES Y PREFIJOS DEL PORTAFOLIO
================================================================================
A continuación se definen los prefijos correctos para garantizar la organización
en el desarrollo de scripts y objetos de base de datos en la clase:

PREFIJO PARA LAS VARIABLES:
  - vn_xxxxx  ---> Forma correcta de crear una variable numérica.
  - vd_xxxx   ---> Forma correcta de crear una variable de tipo Date.
  - vv_xxxx   ---> Forma correcta de crear una variable de tipo Varchar.
  - vdo_xxx   ---> Forma correcta de crear una variable de tipo double.

PREFIJO PARA LAS CONSTANTES:
  - cn_xxx    ---> Forma correcta de crear una constante numérica.
  - cd_xxx    ---> Forma correcta de crear una constante de tipo Date.
  - cv_xxx    ---> Forma correcta de crear una constante de tipo Varchar.
  - cdo_xxx   ---> Forma correcta de crear una constante de tipo double.

PREFIJOS DE OBJETOS Y COMPONENTES:
  - sp_xxx    ---> Prefijo para los procedimientos almacenados.
  - param_xxx ---> Prefijo para los parámetros.
  - fn_xxx    ---> Prefijo para funciones.
  - pck_xxx   ---> Prefijo para paquetes.
  - TGR_xxx   ---> Prefijo para triggers.
*/

-- =============================================================================
-- SECCIÓN DE EJERCICIOS PRÁCTICOS DE LA SESIÓN
-- =============================================================================

-- Ejercicio 1: Declaración y asignación de variables tradicionales
DECLARE
    vv_miPrimeraVariable VARCHAR2(50);
BEGIN
    vv_miPrimeraVariable := 'Hola mundo';
    DBMS_OUTPUT.PUT_LINE(vv_miPrimeraVariable);
END;
/

-- Ejercicio 2: Declaración con inicialización en una sola línea
DECLARE
    vv_miPrimeraVariable VARCHAR2(50) := 'Hola mundo';
BEGIN
    DBMS_OUTPUT.PUT_LINE(vv_miPrimeraVariable);
END;
/

-- Ejercicio 3: Captura de datos mediante SELECT INTO con tipos estáticos
BEGIN
DECLARE
    vv_nombre   VARCHAR2(50);
    vv_apellido VARCHAR2(50);
BEGIN
    SELECT first_name, last_name
    INTO vv_nombre, vv_apellido
    FROM hr.employees
    WHERE employee_id = 110;

    -- Nota teórica: Lo que va dentro de las comillas se llama LITERAL
    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || vv_nombre || ' ' || vv_apellido); 
END;
/

-- Ejercicio 4: Uso del atributo de tipo dinámico %TYPE
DECLARE
    vv_nombre   hr.employees.first_name%TYPE;
    vv_apellido hr.employees.last_name%TYPE;
BEGIN
    SELECT first_name, last_name
    INTO vv_nombre, vv_apellido
    FROM hr.employees
    WHERE employee_id = 110;

    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || vv_nombre || ' ' || vv_apellido);
END;
/

-- Ejercicio 5: Uso del atributo de registro completo %ROWTYPE
DECLARE
    vv_empleado hr.employees%ROWTYPE;
BEGIN
    SELECT *
    INTO vv_empleado
    FROM hr.employees
    WHERE employee_id = 110;

    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || vv_empleado.first_name || ' ' || vv_empleado.last_name);
END;
/

-- Ejercicio 6: Demostración de control de excepciones y restricciones del INTO singular
DECLARE
    vv_empleado hr.employees%ROWTYPE;
BEGIN
    SELECT *
    INTO vv_empleado
    FROM hr.employees
    WHERE employee_id = (110,108); ---> ESTO ASI NO FUNKA (Demostración de error de cardinalidad)

    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || vv_empleado.first_name || ' ' || vv_empleado.last_name);
END;
/

/*
================================================================================
CONCLUSIONES Y RECORDATORIOS CLAVE
================================================================================
* TIPOS DE ATRIBUTOS IMPORTANTES:
    - %TYPE: HEREDA EL TIPO DE DATO DE LA TABLA
    - %ROWTYPE: HEREDA TODOS LOS TIPOS DE DATOS DE LA TABLA (Toda la fila)

* REGLAS DE ORO DEL DESARROLLADOR:
    - Jamás olvidar el diccionario de datos para ser organizado en todo tipo de trabajos.
    - CONTROL + F7 HACE LA INDENTACIÓN automática en SQL Developer.
    - El operador || SE USA EXCLUSIVAMENTE PARA CONCATENAR cadenas de texto.
*/