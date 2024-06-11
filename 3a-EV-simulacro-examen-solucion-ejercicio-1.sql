/* MANUEL ALEJANDRO SANCHEZ GARCIA */
/**** SIMULACRO DE EXAMEN. TABLAS Y DATOS NECESARIOS EJERCICIO 1  ****/
DROP TABLE empleados CASCADE CONSTRAINTS;
DROP TABLE departamentos CASCADE CONSTRAINTS;

CREATE TABLE departamentos (
    id_departamento NUMBER PRIMARY KEY,
    nombre VARCHAR2(100)
	/*FOREIGN KEY (nombre) REFERENCES empleados(nombre)*/
);

CREATE TABLE empleados (
    id_empleado NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    edad NUMBER,
    id_departamento NUMBER
    /*FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)*/
);


-- Insertar datos de ejemplo en la tabla de empleados
INSERT INTO empleados (id_empleado, nombre, edad, id_departamento)
VALUES (1, 'Juan', 30, 1);

INSERT INTO empleados (id_empleado, nombre, edad, id_departamento)
VALUES (2, 'María', 35, 1);

INSERT INTO empleados (id_empleado, nombre, edad, id_departamento)
VALUES (3, 'Pedro', 32, 2);

-- Insertar datos de ejemplo en la tabla de departamentos
INSERT INTO departamentos (id_departamento, nombre) VALUES (1, 'Ventas');
INSERT INTO departamentos (id_departamento, nombre) VALUES (2, 'Desarrollo');

SELECT AVG(edad) FROM empleados
GROUP BY id_departamento;

/* EJERCICIO 1 */
CREATE OR REPLACE FUNCTION calcular_promedio_edad_por_departamento(id NUMBER) RETURN NUMBER
IS
	promedio NUMBER;
BEGIN
    SELECT AVG(edad) INTO promedio FROM empleados 
    WHERE empleados.id_departamento = id;

	RETURN promedio;
END;

/* CODIGO DE PRUEBA */
DECLARE
    promedio NUMBER;
BEGIN
    /* Calcular para el departamento 1 */
	promedio := calcular_promedio_edad_por_departamento(1);
 	DBMS_OUTPUT.PUT_LINE('Promedio departamento 1: ' || promedio);

	/* Calcular para el departamento 2 */
	promedio := calcular_promedio_edad_por_departamento(2);
 	DBMS_OUTPUT.PUT_LINE('Promedio departamento 2: ' || promedio);
END;
