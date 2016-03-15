/*
Procedimiento almacenado llamado REVISA_PEDIDOS (sin argumentos) cuya misión es comprobar la
consistencia de los datos de todos los pedidos. El campo “importe total” de la tabla “Pedidos” debe almacenar la
suma de los “precio con comisión” de los platos del pedido multiplicados por su cuantía.
Se pide usar un cursor FOR UPDATE
El procedimiento debe verificar y actualizar estos datos para todos los pedidos, de modo que resulten consistentes.
Si todos los datos son correctos, se mostrará un mensaje indicando “Ningún cambio en los datos de la tabla
Pedidos”. En caso contrario se indicará el número de filas modificadas en en la tabla Pedidos. 
*/



create or replace 
PROCEDURE  revisa_pedidos
IS

  v_pComision NUMBER;
  v_plato VARCHAR2(20);
  v_restaurante VARCHAR2(20);
  v_precPlato NUMBER;
  v_platoRestaurante VARCHAR2(20);
  v_comision NUMBER;
  v_pedido NUMBER;
  v_codigo NUMBER;
  v_importe_total NUMBER;
  total number := 0;
  contador number :=0;
  control number:=0;
  
  cursor pediditos is
  SELECT pedidos.importeTotal, pedidos.codigo
  FROM pedidos
  FOR UPDATE OF pedidos.importeTotal;
  

BEGIN

  FOR cursorcito in pediditos
  LOOP
   -- cursor cont_precio is
   -- select precio_con_comision, pedido into v_pComision, v_pedido  from contiene where pedido = v_codigo;
   
    FOR cursorcito in cont_precio
    LOOP
      if cursorcito.codigo != cursorcito2.pedido then
        control := 1;
        Exit;
      else
        control := 0;
        total:= total + cursorcito2.precio_con_comision;
      end if;
    end loop;
	IF total != cursorcito.importe_total AND control != 1 THEN
		UPDATE pedidos SET importe_total = total WHERE CURRENT OF pediditos/*cursorcito*/;
		contador:= contador + 1;  
    END IF;
  END LOOP;
  
  if contador!= 0 then 
	dbms_output.put_line('El total de filas modificadas en Pedidos es: ' || contador);
  else
    dbms_output.put_line('Ningún cambio en los datos de pedidos');
  end if;
 
 end; 
 
--EXCEPTION
  
  