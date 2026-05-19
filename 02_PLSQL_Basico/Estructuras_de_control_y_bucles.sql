/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Estructuras de Control, Bifurcaciones y Bucles 
Descripción: Notas de clase y ejercicios prácticos del 18 de Febrero. 
             Modelado de flujos condicionales (IF-ELSIF-ELSE), etiquetas GOTO 
             y análisis comparativo de iteradores (LOOP, WHILE, FOR).
================================================================================
*/

/*
================================================================================
TEORÍA 1: FLUJOS CONDICIONALES (IF-THEN-ELSIF-ELSE)
================================================================================
* En PL/SQL, solo se tiene la estructura de control "if" para evaluar expresiones booleanas.

Sintaxis Base:
    IF (expresion) THEN
        -- Instrucciones
    ELSIF (expresion) THEN
        -- Instrucciones
    ELSE
        -- Instrucciones
    END IF;
*/

-- Activación del canal de salida del servidor para pruebas
SET SERVEROUTPUT ON;

-- =============================================================================
-- EJERCICIO 1: Evaluación Analítica de Día Primo (Estructura IF-ELSIF)
-- =============================================================================
-- Enunciado de clase: Calcule si el día de hoy es primo o no, si es primo lance el mensaje "Es primo"
DECLARE
    vd_hoy INT;
BEGIN
    -- Captura y conversión del día del mes en curso
    SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'DD')) INTO vd_hoy FROM DUAL;
    
    IF vd_hoy = 2 THEN
        DBMS_OUTPUT.PUT_LINE(' ES PRIMO');
    ELSIF vd_hoy <= 1 OR MOD(vd_hoy, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE(' NO ES PRIMO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('HOLA PRIMO ');
    END IF;
END;
/

-- =============================================================================
-- EJERCICIO 2: Control de Saltos de Línea mediante GOTO y Etiquetas
-- =============================================================================
DECLARE
    dia NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'DD'));
BEGIN
    -- Evaluación del conjunto de días primos del mes
    IF dia IN (2,3,5,7,11,13,17,19,23,29,31) THEN
        GOTO primo;
    ELSE
        GOTO noprimo;
    END IF;
 
    <<primo>>
    DBMS_OUTPUT.PUT_LINE('HOLA PRIMO');
    GOTO fin;
 
    <<noprimo>>
    DBMS_OUTPUT.PUT_LINE('NO ES PRIMO');
 
    <<fin>>
    NULL; -- Sentencia obligatoria para finalizar el bloque de etiquetas GOTO
END;
/

/*
================================================================================
TEORÍA 2: ESTRUCTURAS DE REPETICIÓN (ITERADORES O BUCLES)
================================================================================
PL/SQL provee tres variantes de bucles para el control procedural: LOOP, WHILE y FOR.

1. BUCLE LOOP: Se repite tantas veces sea necesario hasta que se fuerza su salida 
   con la instrucción explícita EXIT o EXIT WHEN.
   
   Sintaxis:
       LOOP
           -- Instrucciones
           IF (expresion) THEN
               -- Instrucciones
               EXIT;
           END IF;
       END LOOP;

2. BUCLE WHILE: Ejecución condicionada a la veracidad de una expresión.
   
   Sintaxis:
       WHILE (expresion) LOOP 
           -- Instrucciones
       END LOOP;

3. BUCLE FOR: Iteración controlada por rangos numéricos fijos. Soporta reversión.
*/

-- =============================================================================
-- EJERCICIO 3: Generación de la Serie de Fibonacci usando LOOP
-- =============================================================================
-- Enunciado de clase: IMPRIMIR LA SERIE FIBONACCI HASTA EL TOPE DE 100 CON EL LOOP.
DECLARE 
    vn_a NUMBER := 0;
    vn_b NUMBER := 1;
    vn_c NUMBER;
BEGIN
    LOOP 
        EXIT WHEN vn_a > 100; -- Cláusula de escape del bucle infinito
        DBMS_OUTPUT.PUT_LINE(vn_a);
        
        vn_c := vn_a + vn_b;
        vn_a := vn_b;
        vn_b := vn_c;
    END LOOP;
END;
/

-- =============================================================================
-- EJERCICIO 4: Algoritmo de Euclides empleando bucle WHILE
-- =============================================================================
-- Enunciado de clase: Mínimo común múltiplo de un número cualquiera
DECLARE
    a   NUMBER := 12;
    b   NUMBER := 18;
    mcd NUMBER;
    mcm NUMBER;
    x   NUMBER;
    y   NUMBER;
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

-- =============================================================================
-- EJERCICIO 5: Raíces Cuadradas Exactas mediante bucle FOR
-- =============================================================================
-- Enunciado de clase: Encontrar 2 números que al cuadrado den un número x CON FOR
DECLARE
    vn_numerouno  NUMBER := 64;
    vn_numeroraiz NUMBER := 0;
BEGIN
    FOR vn_numeroraiz IN 1..SQRT(vn_numerouno) LOOP
        IF ((vn_numeroraiz * vn_numeroraiz) = vn_numerouno) THEN 
            DBMS_OUTPUT.PUT_LINE('Raíz cuadrada exacta encontrada: ' || vn_numeroraiz);
        END IF;
    END LOOP;
END;
/

