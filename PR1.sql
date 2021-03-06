

--CONSULTA 1
SELECT * FROM CLIENTES ORDER BY APELLIDO

--CONSULTA 2
SELECT RESTAURANTE, CASE DIA_SEMANA 
  WHEN 'L' THEN 'LUNES'
  WHEN 'M' THEN 'MARTES'
  WHEN 'X' THEN 'MIERCOLES'
  WHEN 'J' THEN 'JUEVES'
  WHEN 'V' THEN 'VIERNES'
  WHEN 'S' THEN 'SABADO'
  WHEN 'D' THEN 'DOMINGO'
END AS DIA_SEMANA
, TO_CHAR(hora_apertura,'HH24:MI'), TO_CHAR(hora_CIERRE,'HH24:MI') FROM HORARIOS ORDER BY RESTAURANTE

--CONSULTA 3
SELECT CL.DNI, CL.NOMBRE, CL.APELLIDO
FROM CLIENTES CL, PEDIDOS PED, CONTIENE CONT, PLATOS PLAT
WHERE CL.DNI = PED.CLIENTE 
AND CONT.PEDIDO = PED.CODIGO
AND PLAT.NOMBRE = CONT.PLATO
AND PLAT.CATEGORIA = 'picante'


--CONSULTA 4

SELECT CL.DNI, CL.NOMBRE, CL.APELLIDO 
FROM CLIENTES CL, PEDIDOS PED, CONTIENE CONT, RESTAURANTES RES
WHERE CL.DNI = PED.CLIENTE AND
      PED.CODIGO = CONT.RESTAURANTE AND
      CONT.RESTAURANTE = RES.CODIGO

           
--CONSULTA 5

SELECT CL.DNI, CL.NOMBRE, CL.APELLIDO
FROM CLIENTES CL, PEDIDOS PED
WHERE CL.DNI = PED.CLIENTE
AND ESTADO != 'ENTREGADO'

--CONSULTA 6

SELECT * FROM PEDIDOS WHERE IMPORTE_TOTAL = (SELECT MAX(IMPORTE_TOTAL) FROM PEDIDOS)

--CONSULTA 7

SELECT AVG(IMPORTE_TOTAL), DNI, NOMBRE
FROM CLIENTES, PEDIDOS
WHERE CLIENTES.DNI = PEDIDOS.CLIENTE
GROUP BY DNI, NOMBRE



--CONSULTA 8
SELECT DISTINCT REST.CODIGO, REST.NOMBRE, SUM(CONT.UNIDADES), SUM(PED.IMPORTE_TOTAL)
FROM RESTAURANTES REST, CONTIENE CONT, PEDIDOS PED
WHERE REST.CODIGO=CONT.RESTAURANTE
AND PED.CODIGO=CONT.PEDIDO
GROUP BY REST.CODIGO, REST.NOMBRE


--CONSULTA 9
SELECT CL.NOMBRE, CL.APELLIDO
FROM CLIENTES CL, PLATOS PLAT, PEDIDOS PED, CONTIENE CON
WHERE CON.PLATO = PLAT.NOMBRE AND PED.CLIENTE = CL.DNI 
AND PLAT.PRECIO>15


--CONSULTA 10

SELECT CL
NI, CL.NOMBRE, COUNT(CODIGO)
FROM CLIENTES CL, AREAS_COBERTURA AR, RESTAURANTES RES
WHERE AR.CODIGO_POSTAL = CL.CODIGO_POSTAL
AND AR.RESTAURANTE = RES.CODIGO
GROUP BY CL.DNI, CL.NOMBRE




