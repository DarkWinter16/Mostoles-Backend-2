use world;

/* Recuperar el pais y la poblacion del pais que tiene mas habitantes, consulta que 
ya habiamos implementado, pero de una forma nada eficiente utilizando order by y limit */
select Name `Pais`, Population `Población`
from country
where Population = (select max(Population) from country);

-- Ejercicio # 1 del Jueves 19 de Nov. Recuperar la ciudad que tiene mas habitantes 
-- y el pais donde se encuentra dicha ciudad, utilizando una subconsulta.
select ci.Name `Ciudad`, co.Name `Pais`, ci.Population
from city ci join country co on ci.CountryCode = co.Code
where ci.Population = (select max(Population) from city);

use tienda;

/* Tipos de Subconsultas:

1- Subconsultas de fila: Devuelven multiples columnas (campos) y una sola fila 
2- Subconsultas de tabla: Pueden devolver una o varias columnas y entre cero y 
   varias filas 
3- Subconsultas escalares: Devuelven una columna y una fila (una celda), es decir 
   un valor  */

/* Subconsultas en la clausula WHERE */

/*
   Por ejemplo: Suponga que queremos conocer el nombre del producto
   que tiene mayor precio.
   
   La solucion, una de las posibles, seria: Realizar una primera consulta, que es
   la subconsulta, para recuperar el precio maximo y, a continuacion, en la 
   consulta principal bucar el nombre del producto cuyo precio coincide con el 
   valor del precio maximo: 

*/ 
select nombre, precio
from producto
where precio = (select max(precio) from producto);

use tienda;

/* Subconsulta en la clausula HAVING 

   Recuperar un listado con todos los nombres de los fabricantes que tienen
   el mismo numero de productos que el fabricante Asus */
 
 select fabricante.nombre, count(*) `Total de Productos`
 from fabricante join producto on fabricante.id = producto.id_fabricante
 group by fabricante.nombre
 having `Total de Productos` = (
 
	select count(producto.id_fabricante) 
    from fabricante join producto on fabricante.id = producto.id_fabricante
    and fabricante.nombre = 'Asus'
 
 );
   
-- Ejercicio # 2 del Jueves 19 de Nov
-- Eliminar del listado anterior al fabricante Asus
select fabricante.nombre, count(*) `Total de Productos`
 from fabricante join producto on 
   fabricante.id = producto.id_fabricante and fabricante.nombre != 'Asus' 
 group by fabricante.nombre
 having `Total de Productos` = (
 
	select count(producto.id_fabricante) 
    from fabricante join producto on fabricante.id = producto.id_fabricante
    and fabricante.nombre = 'Asus'
 
 );

/* 
   Subconsulta en la Clausula FROM 
	
   Recuperar el listado de todos los productos que tienen un precio
   mayor o igual al precio promedio, o medio, de todos los productos 
   de su mismo fabricante
   
/* Por sugerencia  */
/* Uso de la clausula USING */
/* Por sugerencia y cortesia de Elias, la consulta anterior es mejor implementarla utilizando NATURAL JOIN, en 
lugar de INNER JOIN, porque el NATURAL JOIN es perfecto cuando hay campos en las dos tablas que tiene el mismo 
nombre, y nos evita utilizar la clausula ON USING */

select producto.*
from producto join (
	select id_fabricante, avg(precio) precioPromedio
    from producto
    group by id_fabricante) t using (id_fabricante)
    where producto.precio >= precioPromedio
    order by precio desc;

/* Uso de Natural JOIN */

select producto.*
from producto natural join (
	select id_fabricante, avg(precio) precioPromedio
    from producto
    group by id_fabricante) t 
    where producto.precio >= precioPromedio
    order by precio desc;

/**/

-- Consultas auxiliares
table fabricante;
table producto;

