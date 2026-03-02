-- CURSORES EXLICITOS

DECLARE
  /* AUTOR: Andres Gonzalez
    FECHA: 02/03/2026
    DESCRIPCIÓN: Cursor para obtener nombre y apellido del departamento 80
    */
  
	CURSOR cursor_empleados
	IS SELECT  FIRST_NAME, LAST_NAME,DEPARTMENT_ID
	FROM tduartec.employees
    WHERE DEPARTMENT_ID = 80;
	vv_F VARCHAR2(100);
	vv_L VARCHAR2(100);
	vv_D NUMBER(9);
BEGIN
	OPEN cursor_empleados;
	FETCH cursor_empleados INTO vv_L , vv_F, vv_D;
		dbms_output.put_line(vv_L || ' ' || vv_F || ' ' || vv_D);
	CLOSE cursor_empleados;
END;
/
--------------------------------------------------------------------------------------------------
-- CUrsor con loop
DECLARE
  /* AUTOR: Andres Gonzalez
    FECHA: 02/03/2026
    DESCRIPCIÓN: Cursor para obtener nombre y apellido del departamento 80
    */

    CURSOR cursor_empleados IS
    SELECT
        first_name,
        last_name,
        department_id
    FROM
        tduartec.employees
    WHERE
        department_id = 80;

    vv_f VARCHAR2(100);
    vv_l VARCHAR2(100);
    vv_d NUMBER(9);
BEGIN
    OPEN cursor_empleados;
    LOOP
        FETCH cursor_empleados INTO vv_l, vv_f, vv_d;
        EXIT WHEN cursor_empleados%notfound;
        dbms_output.put_line(vv_l|| ' '|| vv_f|| ' '|| vv_d);
    END LOOP;
    CLOSE cursor_empleados;
END;
/   

----------------------------------------------------------------------------------------------------------
-- Variable bind



----------------------------------------------------------------------------------------------------------
-- CURSORES IMPLICITOS

DECLARE
    vdescripcion VARCHAR2(50);
    BEGIN
SELECT
    descripcion
INTO vdescripcion
FROM
    paises
WHERE
    co_pais = 'ESP';

dbms_output.put_line('La lectura del cursor es: ' || vdescripcion);

end;
/

-- Pagar nomina del mes
