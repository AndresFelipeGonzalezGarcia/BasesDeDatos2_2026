-- Inserción de 5000 empleados
BEGIN
  FOR i IN 207..5100 LOOP
    INSERT INTO tduartec.employees VALUES (
        i,                                           
        'Nombre' || i,                               
        'Apellido' || i,                            
        'USER' || i,                                 
        '1.555.000.' || LPAD(i,4,'0'),               
        TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 3650)), 
        CASE MOD(i,6)
            WHEN 0 THEN 'IT_PROG'
            WHEN 1 THEN 'SA_REP'
            WHEN 2 THEN 'FI_ACCOUNT'
            WHEN 3 THEN 'ST_CLERK'
            WHEN 4 THEN 'SH_CLERK'
            ELSE 'PU_CLERK'
        END,                                         
        TRUNC(DBMS_RANDOM.VALUE(2500,15000)),         
        CASE 
            WHEN MOD(i,4) = 0 THEN ROUND(DBMS_RANDOM.VALUE(0.05,0.30),2)
            ELSE NULL
        END,                                          
        TRUNC(DBMS_RANDOM.VALUE(100, 206)),           
        CASE MOD(i,5)
            WHEN 0 THEN 10
            WHEN 1 THEN 20
            WHEN 2 THEN 50
            WHEN 3 THEN 80
            ELSE 60
        END                                           
    );
  END LOOP;

  COMMIT;
END;
/
