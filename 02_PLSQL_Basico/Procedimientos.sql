/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Introducción a Subprogramas Almacenados y Parametrización (Procedures)
Descripción: Notas de clase y ejercicios prácticos del 23 de Febrero. 
             Concepto de objetos en esquema, paso de parámetros por defecto (DEFAULT)
             y exploración analítica de funciones de fecha sobre la tabla DUAL.
================================================================================
*/

/*
================================================================================
TEORÍA 1: CONCEPTOS DE SUBPROGRAMAS EN EL MOTOR DE BASE DE DATOS
================================================================================
* SUBPROGRAMAS: Ya viven dentro del motor de base de datos, se le asigna un nombre único por esquema.
  Tipos a trabajar: Procedimientos almacenados, funciones, triggers, subprogramas en bloques anónimos.

Convenciones de Sintaxis y Presentación:
  - [corchetes cuadrados es opcional]
  - <Etiquetas>
  - OBLIGATORIO PARA LA CLASE: Ponerle el nombre del procedimiento al END;
  - El símbolo || significa excluyente en las presentaciones de sintaxis.
  - / -> Se pone al final para indicar "Pase al siguiente paso".

¿Qué es un Procedimiento Almacenado?
  - Es como un "método" en Java pero acá no devuelve ningún valor directamente como retorno, 
    sino que devuelven parámetros (IN, OUT, IN OUT).
  - Los valores quemados directamente en el código se les dice LITERALES.
*/

/*
REFERENCIA DICTADA CLASE:
--------------------------------------------------------------------------------
-- DESPUES DE CADA CREATE, SELECT TODO
CREATE OR REPLACE PROCEDURE Actualiza_saldo(cuenta Number, new_saldo Number)
IS
    -- Declaracion de variables locales
BEGIN
    -- Sentencias
    UPDATE SALDOS_CUENTAS SET SALDO = new_saldo, FX ...
--------------------------------------------------------------------------------
*/

-- Configuración global del entorno para visualización de respuestas de consola
SET SERVEROUTPUT ON;

-- =============================================================================
-- EJERCICIO 1: Procedimiento Almacenado con Parámetros Obligatorios (IN)
-- =============================================================================
-- Enunciado de clase: Crear hola mundo recibiendo el parámetro varchar2 y el nombre de una persona que admire.

CREATE OR REPLACE PROCEDURE sp_mensaje (param_nombre IN VARCHAR2)
/*
Autor: Andrés González
Fecha: 23/02/2026
Descripcion: Este sp genera un texto saludando a alguien.
*/
IS
    vv_mensaje VARCHAR2(100);
BEGIN
    vv_mensaje := 'Hola mundo, el es campeon del mundo: ' || param_nombre || ' y cristiano llorando';
    DBMS_OUTPUT.PUT_LINE(vv_mensaje);
END sp_mensaje;
/

-- Invocación y ejecución del procedimiento sp_mensaje mediante bloque anónimo
BEGIN
    sp_mensaje('Messi'); 
END;
/

-- Comando de administración para remover el objeto del esquema (Ejemplo anotado):
-- DROP PROCEDURE messi; --- borrar


-- =============================================================================
-- EJERCICIO 2: Procedimiento Almacenado con Parámetros por Defecto (DEFAULT)
-- =============================================================================
CREATE OR REPLACE PROCEDURE sp_mensajeConDefault (param_nombre IN VARCHAR2 DEFAULT 'Messi')
/*
Autor: Andrés González
Fecha: 23/02/2026
Descripcion: Este sp genera un texto saludando a alguien usando valor en default.
*/
IS
    vv_mensaje VARCHAR2(100);
BEGIN
    vv_mensaje := 'Hola mundo, el es campeon del mundo: ' || param_nombre || ' y cristiano llorando';
    DBMS_OUTPUT.PUT_LINE(vv_mensaje);
END sp_mensajeConDefault;
/

-- Invocación sin argumentos: Toma automáticamente el valor 'Messi' definido por DEFAULT
BEGIN
    sp_mensajeConDefault(); 
END;
/

-- Nota de clase: Si se pone algo en los paréntesis se imprime el valor de la invocación.


-- =============================================================================
-- SECCIÓN 3: ANÁLISIS DE FUNCIONES DE FECHA (TABLA DUAL) Y DESAFÍOS
-- =============================================================================

-- Consulta 1: Obtener de forma exacta el último viernes del mes actual
SELECT NEXT_DAY (LAST_DAY(SYSDATE)-7,'VIERNES') AS ultimo_viernes_mes
FROM DUAL;

-- Consulta 2 (Apunte/Desafío de clase): Encontrar la forma de evaluarlo en otro mes como Septiembre.
SELECT NEXT_DAY (LAST_DAY(SYSDATE)-7,'VIERNES') AS desafio_septiembre
FROM DUAL;


/*
--------------------------------------------------------------------------------
APUNTE FINAL DE CIERRE DE CLASE:
--------------------------------------------------------------------------------
Llamado proyectado del procedimiento que integra fechas (Pendiente de implementación de cuerpo):

BEGIN
    sp_mensajeConDefaultYFecha(); 
END;
/
*/