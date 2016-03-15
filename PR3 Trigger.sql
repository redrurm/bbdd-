/*
Crea un disparador llamado control_detalle_pedidos que se asocie a todas las operaciones
posibles (insertar, eliminar y modificar) sobre la tabla Contiene. Al insertar una nueva fila en
esta tabla, se deberá incrementar el valor del campo importe_total de Pedidos. Si se produce
la eliminación de una fila o una actualización, el importe se debe rectificar según la
modificación introducida.
*/

create or replace

TRIGGER control_detalle_pedidos

AFTER INSERT OR DELETE OR UPDATE ON contiene

FOR EACH ROW

DECLARE

INVALID_VALUE EXCEPTION;

BEGIN
--Si intentamos meter un precio negativo, salta excepcion

if(:new.precio_con_comision < 0) THEN
	RAISE INVALID_VALUE;
END IF;

--Si insertamos, actualizamos el importe total sumandole el valor nuevo

IF INSERTING THEN

	UPDATE pedidos SET importe_total= importe_total + :new.precio_con_comision where codigo = :new.pedido;
	DBMS_OUTPUT.PUT_LINE ('Trigger de insertado activado');

--Si borramos, restamos del precio total el precio antiguo al pedido

ELSIF DELETING THEN

	UPDATE pedidos SET importe_total= importe_total - :old.precio_con_comision where codigo = :new.pedido;
	DBMS_OUTPUT.PUT_LINE ('Trigger de borrado activado');

	--Si actualizamos, restamos el precio antiguo del importe total y sumamos el precio nuevo

ELSE

	UPDATE pedidos SET importe_total= importe_total - :old.precio_con_comision + :new.precio_con_comision where codigo = :new.pedido;
	DBMS_OUTPUT.PUT_LINE ('Trigger de actualizado insertado');

END IF;

EXCEPTION

	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Cliente no encontrado');
	WHEN TOO_MANY_ROWS THEN
		DBMS_OUTPUT.PUT_LINE ('Hay más de una fila con esos’ ||‘ datos');
	WHEN INVALID_VALUE THEN
		DBMS_OUTPUT.PUT_LINE ('Valor negativo invalido');

END;