/*
Procedimiento almacenado llamado REVISA_PRECIO_CON_COMISION (sin argumentos) cuya misión es
comprobar la consistencia de los datos de todos los precios con comisión en la tabla Contiene. El campo “precio
con comisión” de la tabla “Contiene” debe almacenar el precio del plato incluyendo el porcentaje de la comisión
de su restaurante.
 El procedimiento debe verificar y actualizar estos datos de modo que resulten consistentes. Si todos los datos son
correctos, se mostrará un mensaje indicando “Ningún cambio en los datos de Contiene”. En caso contrario se
indicará el número de filas modificadas en Contiene. 
*/

create or replace PROCEDURE REVISA_PRECIO_CON_COMISION AS
  v_Comision restaurantes.comision%TYPE;
  v_Precio platos.precio%TYPE;
  v_Unidades contiene.unidades%TYPE;
  v_ContienePlato contiene.plato%TYPE;
  v_PrecioConComision contiene.precioConComision%TYPE;
  v_ContieneRestaurante contiene.restaurante%TYPE;
  v_Contador INTEGER;
  v_CalcularPrecio contiene.precioConComision%TYPE;

  CURSOR c_Contiene IS 
  SELECT contiene.precioConComision, contiene.plato, contiene.restaurante,  platos.precio, restaurantes.comision, contiene.unidades
  FROM contiene, restaurantes, platos
  WHERE contiene.restaurante = restaurantes.codigo AND platos.restaurante = restaurantes.codigo
  AND platos.nombre = contiene.plato;

BEGIN 
  v_Contador := 0;
  OPEN c_Contiene;
  LOOP
    FETCH c_Contiene INTO v_PrecioConComision, v_ContienePlato, v_ContieneRestaurante, v_Precio, v_Comision, v_Unidades;
    EXIT WHEN c_Contiene%NOTFOUND;

    --SI HAY COMISION
    IF (v_Comision is not NULL) THEN
      v_CalcularPrecio := v_Precio * ((v_Comision / 100) + 1);
    ELSE
      v_CalcularPrecio:= v_Precio;
    END IF;

    --SI NO HAY COMISION
    IF (v_PrecioConComision is NULL) THEN
      v_PrecioConComision :=  0;
    END IF;
    
    --MODIFICAR PRECIO SI NO COINCIDE
    IF (v_PrecioConComision != v_CalcularPrecio) THEN
      UPDATE contiene SET contiene.precioconcomision = v_CalcularPrecio 
      WHERE contiene.restaurante = v_ContieneRestaurante AND contiene.plato = v_ContienePlato;
      v_PrecioConComision :=  v_CalcularPrecio;
      DBMS_OUTPUT.PUT_LINE ('Se ha modificado la fila con restaurante = ' || v_ContieneRestaurante || ', plato = ' || v_ContienePlato || ' , precio con comisión = ' || v_PrecioConComision ); 
      v_Contador := v_Contador + 1;
    END IF;
  END LOOP;
 
  CLOSE c_Contiene;
  --SI NO HAY CAMBIOS
  IF (v_Contador = 0)  THEN
    DBMS_OUTPUT.PUT_LINE ('No se realizaron cambios en CONTIENE.'); 
  END IF;

  EXCEPTION 
    when INVALID_CURSOR then
    dbms_output.put_line('Operacion en el cursor no valida');
    when VALUE_ERROR then
    dbms_output.put_line('Tamaño de alguna variable insuficiente');
   
END;
  
