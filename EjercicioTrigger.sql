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

--CREAR EL TRIGGUER

--Declaramos el nombre y los parametros. 
CREATE OR REPLACE TRIGGER t_actualizar_precio_total AFTER INSERT ON auditoria_ordenes FOR EACH ROW

-- declaramos las variables. 
DECLARE 
precioTotal NUMBER; 
idOrden NUMBER; 

--Comenzamos la funcion 
begin
DBMS_OUTPUT.PUT_LINE('Trigger');

--Obtenemos el id orden del nuevo registro insertado. 
idOrden:= :NEW.id_orden;

-- Con un select, calculamos el precio total de la orden, MULTIPLICANDO EL PRECIO UNITARIO Y LA CANTIDAD de la tabla orden detalle y lo guardamos en la variable precioTotal. 
select SUM(precio_unitario*cantidad)
  into precioTotal --variable
  from orden_detalle od
 where od.id_orden= idOrden -- Para que IdOrden coincida con la id orden de la tabla de orden_detalle. 
 GROUP BY(id_orden);  -- Los agrupamos por id_orden. 

 --Actualizamos la tabla orden con el precio total utilizando update.  
update orden --Tabla orden 
   set precio_total= precioTotal -- La columna incluya el valor de la variable. 
 where id_orden=idOrden; -- Donde la id de orden coincida con la variable idOrden. 

 --Imprimimos el precio total. 
 DBMS_OUTPUT.PUT_LINE('Precio total: '||precioTotal);

exception
  when OTHERS then
  DBMS_OUTPUT.PUT_LINE('Error'); 

end;

--PRUEBA 1
DECLARE
id_orden NUMBER:=1;

begin
  actualiza_ordenes(id_orden); -- Funcion dada para actualizar las ordenes. 

end;
SELECT * FROM orden; -- Comprobar que se actualiza el precio total. 
SELECT * FROM auditoria_ordenes; --ver la tabla auditoria ordenes. 

--PRUEBA 2
DECLARE
id_orden NUMBER:= 2; 
begin
  actualiza_ordenes(id_orden);
end;

SELECT * FROM orden; -- Comprobar que se actualiza el precio total. 
SELECT * FROM auditoria_ordenes; --ver la tabla auditoria ordenes.  














