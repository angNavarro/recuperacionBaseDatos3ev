-- MANUEL ALEJANDRO SANCHEZ GARCIA
/**** EXAMEN BD. TABLAS Y DATOS NECESARIOS EJERCICIO 2  ****/

DROP TABLE orden_detalle CASCADE CONSTRAINTS;
DROP TABLE orden CASCADE CONSTRAINTS;
DROP TABLE auditoria_ordenes CASCADE CONSTRAINTS;

-- Tabla de órdenes
CREATE TABLE orden (
    id_orden NUMBER PRIMARY KEY,
    fecha_creacion DATE,
    precio_total NUMBER(10, 2)
);

-- Tabla de detalles de la orden
CREATE TABLE orden_detalle (
    id_detalle NUMBER PRIMARY KEY,
    id_orden NUMBER,
    producto VARCHAR2(100),
    precio_unitario NUMBER(10, 2),
    cantidad NUMBER,
    FOREIGN KEY (id_orden) REFERENCES orden(id_orden)
);

-- Tabla para guardar un registro de ordenes actualizadas
CREATE TABLE auditoria_ordenes (
    id NUMBER PRIMARY KEY,
    fecha_hora TIMESTAMP,
    id_orden NUMBER,
	FOREIGN KEY (id_orden) REFERENCES orden(id_orden)
);

-- Secuencia para generar IDs de auditoría
CREATE SEQUENCE seq_auditoria_ordenes;

-- Datos de ejemplo para la tabla de órdenes
INSERT INTO orden (id_orden, fecha_creacion, precio_total)
VALUES (1, TO_DATE('2024-03-01', 'YYYY-MM-DD'), NULL);

INSERT INTO orden (id_orden, fecha_creacion, precio_total)
VALUES (2, TO_DATE('2024-04-11', 'YYYY-MM-DD'), NULL);

-- Datos de ejemplo para la tabla de detalles de la orden
INSERT INTO orden_detalle (id_detalle, id_orden, producto, precio_unitario, cantidad)
VALUES (1, 1, 'Producto A', 10.50, 2);

INSERT INTO orden_detalle (id_detalle, id_orden, producto, precio_unitario, cantidad)
VALUES (2, 1, 'Producto B', 20.75, 3);

INSERT INTO orden_detalle (id_detalle, id_orden, producto, precio_unitario, cantidad)
VALUES (3, 2, 'Producto C', 32.15, 5);

-- Para probar el código tenéis que insertar en la tabla actualizar_ordenes
CREATE OR REPLACE PROCEDURE actualiza_ordenes( o_id IN NUMBER )
IS
BEGIN
	INSERT INTO auditoria_ordenes ( id, fecha_hora, id_orden )
	VALUES (seq_auditoria_ordenes.NEXTVAL, SYSDATE, o_id);
END;

-- Ejemplo para llamar al procedimiento anterior
DECLARE
    id_orden NUMBER := 2;
BEGIN
	actualiza_ordenes( id_orden );
END;

-- Para mostrar los datos almacenados
select * from orden;
select * from orden_detalle;
select * from auditoria_ordenes;

-- CREAR EL TRIGGER
CREATE OR REPLACE TRIGGER actualizar_precio_total 
AFTER INSERT ON auditoria_ordenes 
FOR EACH ROW
DECLARE
    precioTotal  NUMBER;
    idOrden      orden.id_orden%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger');
    
    -- Obtener el id_orden del nuevo registro insertado
    idOrden := :NEW.id_orden;

    -- Calcular el precio total de la orden
    SELECT SUM(precio_unitario * cantidad) 
    INTO precioTotal 
    FROM orden_detalle od 
    WHERE od.id_orden = idOrden 
    GROUP BY id_orden;

	UPDATE orden SET precio_total = precioTotal WHERE id_orden = idOrden;
    
    DBMS_OUTPUT.PUT_LINE('Precio total: ' || precioTotal);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error');
END;

-- PRUEBAS
-- PRUEBA 1
DECLARE
    id_orden NUMBER := 1;
BEGIN
    -- Al llamar a esta funcion debe actualizar el precio_total de la fila con id_orden = 1 
    -- Poniendo 83,25
	actualiza_ordenes( id_orden );
END;

-- COMPROBAR QUE SE A ACTUALIZADO EL TOTAL (83,25)
SELECT * FROM orden;

-- PRUEBA 2:
DECLARE
    id_orden NUMBER := 2;
BEGIN
	-- Al llamar a esta funcion debe actualizar el precio_total de la fila con id_orden = 2 
    -- Poniendo 160,75
	actualiza_ordenes( id_orden );
END;

-- COMPROBAR QUE SE A ACTUALIZADO EL TOTAL (160,75)
SELECT * FROM orden;

SELECT * FROM auditoria_ordenes;