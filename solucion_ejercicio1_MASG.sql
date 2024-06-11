-- MANUEL ALEJANDRO SANCHEZ GARCIA
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

-- FUNCION
CREATE OR REPLACE FUNCTION calcular_salario_total(id_emp NUMBER) RETURN NUMBER
IS
    salarioBase NUMBER;
	bonificaciones NUMBER;
BEGIN
    -- Seleccionar el salario base del empleado 
    SELECT salario INTO salarioBase FROM empleados WHERE empleados.id = id_emp;
	-- Seleccionar las bonificaciones 
	SELECT SUM(monto) INTO bonificaciones FROM bonificaciones b WHERE b.id_empleado = id_emp
	GROUP BY (id_emp);

	-- Sumar salario base y bonificaciones y devolver
	RETURN salarioBase + bonificaciones;
END;


-- PRUEBA
-- PRUEBA 1
DECLARE 
	salarioTotal NUMBER;
BEGIN
    -- Esta prueba debe imprimir el salario total del empleado con id = 1 (2150)
	salarioTotal := calcular_salario_total(1);
	dbms_output.put_line('El salario total del empleado es: ' || salarioTotal);
END;

-- PRUEBA 2
DECLARE 
	salarioTotal NUMBER;
BEGIN
    -- Esta prueba debe imprimir el salario total del empleado con id = 2 (2700)
	salarioTotal := calcular_salario_total(2);
	dbms_output.put_line('El salario total del empleado es: ' || salarioTotal);
END;