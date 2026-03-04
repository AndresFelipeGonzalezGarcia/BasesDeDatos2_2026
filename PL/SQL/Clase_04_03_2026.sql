-- Devolver VARCHAR y recibir un nombre
SET SERVEROUTPUT ON;

CREATE OR REPLACE
FUNCTION fn_saludar_A_Alguien (vv_saludar VARCHAR2)
RETURN VARCHAR2
IS
    vv_resultado VARCHAR2(20):='messi ';
BEGIN
return (vv_resultado || vv_saludar );
END;
/

DECLARE
mensa VARCHAR2(20);
BEGIN
mensa := fn_saludar_A_Alguien('Hola chiquita');
 dbms_output.put_line(mensa);
END;
/3