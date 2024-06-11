/* MANUEL ALEJANDRO SANCHEZ GARCIA */
/**** SIMULACRO DE EXAMEN. TABLAS Y DATOS NECESARIOS EJERCICIO 2  ****/

DROP TABLE empleados CASCADE CONSTRAINTS;
DROP TABLE auditoria_empleados CASCADE CONSTRAINTS;

-- Crear tabla de empleados
CREATE TABLE empleados (
    id_empleado NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    apellido VARCHAR2(100),
    fecha_modificacion DATE
);

-- Insertar datos de ejemplo en la tabla de empleados
INSERT INTO empleados (id_empleado, nombre, apellido, fecha_modificacion)
VALUES (1, 'Juan', 'Pérez', TO_DATE('2024-05-20', 'YYYY-MM-DD'));

INSERT INTO empleados (id_empleado, nombre, apellido, fecha_modificacion)
VALUES (2, 'María', 'Gómez', TO_DATE('2024-05-18', 'YYYY-MM-DD'));

-- Crear tabla de auditoría de empleados
CREATE TABLE auditoria_empleados (
    id_auditoria NUMBER PRIMARY KEY,
    fecha_hora TIMESTAMP,
    tipo_operacion VARCHAR2(20),
    id_empleado NUMBER,
    nombre_empleado VARCHAR2(100)
    /* 	He comentado esta linea porque si se aplica la clave foránea da error al eliminar un empleado 
       	Se podría solucionar eliminando primero el o los registros asociados al empleado que se va a borrar,
    	pero la idea es que el registro guarde todas las operaciones y no tendría sentido 
    */
	--FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- Crear secuencia para generar IDs de auditoría
CREATE SEQUENCE seq_auditoria_empleados;


-- Como utilizar el incremento (secuencia): seq_auditoria_empleados.NEXTVAL

-- Crear el trigger
CREATE OR REPLACE TRIGGER auditar_cambios_empleados 
AFTER INSERT OR UPDATE OR DELETE ON empleados FOR EACH ROW
DECLARE
    operacion 	varchar2(10);
	id_empleado empleados.id_empleado%type;
	nombre		empleados.nombre%type;
BEGIN
	-- Con :NEW accedemos a los valores nuevos o actualizados (insert o update)
    id_empleado := :NEW.id_empleado;
    nombre := :NEW.nombre;

    IF INSERTING THEN
		operacion := 'INSERT';  

	ELSIF UPDATING THEN
		operacion := 'UPDATE';  

    ELSIF DELETING THEN
    	operacion := 'DELETE';
		-- Con :OLD accedemos a los valores eliminados
        id_empleado := :OLD.id_empleado; 
        nombre := :OLD.nombre;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('OPERACION: ' || operacion);
    DBMS_OUTPUT.PUT_LINE('id_empleado: ' || id_empleado);
    DBMS_OUTPUT.PUT_LINE('nombre: ' || nombre);

    INSERT INTO auditoria_empleados VALUES (
            seq_auditoria_empleados.NEXTVAL, 
            SYSTIMESTAMP, 
            operacion, 
            id_empleado, 
            nombre
        );

	EXCEPTION
    --WHEN DUP_VAL_ON_INDEX THEN
      --DBMS_OUTPUT.PUT_LINE('');
	WHEN OTHERS THEN
    	DBMS_OUTPUT.PUT_LINE('Error');
END;

-- PRUEBAS
SELECT * FROM empleados;
SELECT * FROM auditoria_empleados;
INSERT INTO empleados VALUES (3, 'Jose', 'Sanchez', SYSTIMESTAMP);
SELECT * FROM empleados;
SELECT * FROM auditoria_empleados;
UPDATE empleados SET nombre = 'Manuel' WHERE id_empleado = 3;
SELECT * FROM auditoria_empleados;
DELETE FROM empleados WHERE id_empleado = 3;
SELECT * FROM empleados;
SELECT * FROM auditoria_empleados;
