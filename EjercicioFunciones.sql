/**** TABLAS Y DATOS NECESARIOS EJERCICIO 1  ****/
DROP TABLE empleados CASCADE CONSTRAINTS;
DROP TABLE bonificaciones CASCADE CONSTRAINTS;

-- Crear tabla de empleados
CREATE TABLE empleados (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    salario NUMBER
);

-- Insertar datos de ejemplo en la tabla de empleados
INSERT INTO empleados (id, nombre, salario) VALUES (1, 'Juan', 2000);
INSERT INTO empleados (id, nombre, salario) VALUES (2, 'María', 2500);
INSERT INTO empleados (id, nombre, salario) VALUES (3, 'Pedro', 2200);

-- Crear tabla de bonificaciones
CREATE TABLE bonificaciones (
    id_empleado NUMBER,
    monto NUMBER,
	FOREIGN KEY (id_empleado) REFERENCES empleados(id)
);

-- Insertar datos de ejemplo en la tabla de bonificaciones.
INSERT INTO bonificaciones (id_empleado, monto) VALUES (1, 100);
INSERT INTO bonificaciones (id_empleado, monto) VALUES (1, 50);
INSERT INTO bonificaciones (id_empleado, monto) VALUES (2, 200);


-- Crear funcion que calcule el salario total de los empleados, sumando las bonificaciones. 

--Declaramos la funcion, le indicamos que el parametro de entrada sera el id del empleado y que retorna NUMBER. 

CREATE OR REPLACE FUNCTION f_calcular_edad_media_departamento (id_emp NUMBER ) RETURN NUMBER 

--Declaramos las variables de salarioBase y la suma de las bonificaciones. 
IS
salarioBase NUMBER;
sumaBonificaciones NUMBER; 

--Declaramos toda la funcion dentro de un begin, con dos selects para recuperar las dos variables. 
begin
  select salario
    into salarioBase
    from empleados e
   where e.id=id_emp; --Donde coincida que id emp sea el id del empleado en la tabla de empleados. 

  select SUM(monto)
    into sumaBonificaciones
    from bonificaciones b
   where b.id_empleado=id_emp;

    --Realizamos el retorno de la suma. 
    RETURN salarioBase+sumaBonificaciones; 

end;

--Probamos la funcion asignado un numero de id a la funcion. Declaramos la variable salario total. 
DECLARE
    salarioTotal NUMBER; 

begin
  salarioTotal:= f_calcular_edad_media_departamento(1);
  dbms_output.put_line('El salario total del primer empleado es: ' ||salarioTotal); 

end;

