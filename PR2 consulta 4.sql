--PENDIENTE DE PRUEBA
/*
Crea un procedimiento DATOS_CLIENTES que recorra todos los Clientes con un FOR y muestre todos sus
datos junto con la suma de importe total de todos sus pedidos. Finalmente se mostrará la suma total de los
importes de todos los pedidos de todos los clientes. 
*/
create or replace 
PROCEDURE  DATOS_CLIENTES
  AS

  v_ImporteClientes NUMBER(8,2);
  v_ImporteTotal NUMBER(8,2);
  v_DNI clientes.DNI%TYPE;

CURSOR cl IS
SELECT DISTINCT clientes.DNI, clientes.NOMBRE, clientes.APELLIDO, clientes.CALLE, clientes.NUMERO, clientes.PISO, clientes.LOCALIDAD, clientes.CODIGO_POSTAL, clientes.TELEFONO, clientes.USUARIO, clientes. CONTRASENIA 
FROM CLIENTES, PEDIDOS 
WHERE clientes.DNI = pedidos.CLIENTE;

BEGIN

  v_ImporteClientes := 0;

	FOR curCliente in cl
	LOOP
    v_DNI := curCliente.DNI;
      SELECT SUM (importeTotal) into v_ImporteTotal
      FROM PEDIDOS
      WHERE Pedidos.Cliente = v_DNI
      GROUP BY Pedidos.Cliente;

 DBMS_OUTPUT.PUT_LINE (curCliente.DNI || ', ' || curCliente.nombre || ', ' || curCliente.apellido || ',' || curCliente.calle ||',' || curCliente.numero || ', ' || curCliente.piso || ',' || curCliente.localidad || ',' || curCliente.telefono || ',  ' || curCliente.usuario || ',    ' ||  v_ImporteTotal);
    v_ImporteClientes:= v_ImporteClientes + v_ImporteTotal;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' Importe total clientes :' || v_importeTotalClientes );
  
END;