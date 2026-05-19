/*
================================================================================
UNIVERSIDAD EL BOSQUE - FACULTAD DE INGENIERÍA
Asignatura: Bases de Datos II (2026-1)
Estudiante: Andrés González
Componente: Generación de Datos de prueba (Poblado Masivo de Tablas)
Descripción: Script que automatiza la inserción de 5000 registros 
             en la tabla de empleados. Implementa funciones aleatorias y 
             distribuciones cíclicas para simular un entorno corporativo real.
================================================================================
*/

SET SERVEROUTPUT ON;

BEGIN
    -- Bucle iterativo para la inserción masiva (Rango: 207 al 5100)
    FOR i IN 207..5100 LOOP
    
        INSERT INTO tduartec.employees (
            employee_id,
            first_name,
            last_name,
            email,
            phone_number,
            hire_date,
            job_id,
            salary,
            commission_pct,
            manager_id,
            department_id
        ) VALUES (
            i,                                            -- ID incremental
            'Nombre' || i,                                -- Nombre indexado
            'Apellido' || i,                              -- Apellido indexado
            'USER' || i,                                  -- Email/Usuario único
            
            -- Teléfono formateado con ceros a la izquierda usando LPAD
            '1.555.000.' || LPAD(i, 4, '0'),              
            
            -- Fecha de contratación aleatoria dentro de los últimos 10 años (3650 días)
            TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 3650)),  
            
            -- Distribución uniforme y cíclica de Cargos (Job IDs) basada en el residuo de i
            CASE MOD(i, 6)
                WHEN 0 THEN 'IT_PROG'
                WHEN 1 THEN 'SA_REP'
                WHEN 2 THEN 'FI_ACCOUNT'
                WHEN 3 THEN 'ST_CLERK'
                WHEN 4 THEN 'SH_CLERK'
                ELSE 'PU_CLERK'
            END,                                          
            
            -- Rango salarial simulado de forma aleatoria entre $2,500 y $15,000
            TRUNC(DBMS_RANDOM.VALUE(2500, 15000)),         
            
            -- Asignación de comisión (Solo al 25% de los registros, el resto permanece NULL)
            CASE 
                WHEN MOD(i, 4) = 0 THEN ROUND(DBMS_RANDOM.VALUE(0.05, 0.30), 2)
                ELSE NULL
            END,                                          
            
            -- Asignación aleatoria de un mánager dentro del rango de empleados existentes
            TRUNC(DBMS_RANDOM.VALUE(100, 206)),           
            
            -- Distribución cíclica de Departamentos basada en el residuo de i
            CASE MOD(i, 5)
                WHEN 0 THEN 10
                WHEN 1 THEN 20
                WHEN 2 THEN 50
                WHEN 3 THEN 80
                ELSE 60
            END                                           
        );
        
    END LOOP;

    -- Confirmación y consolidación irreversible de las transacciones en el disco
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Proceso finalizado con éxito. Se insertaron de forma estructurada los registros de pruebas.');
END;
/