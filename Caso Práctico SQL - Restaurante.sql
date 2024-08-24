/*El restaurante "Sabores del Mundo", es conocido por su auténtica cocina y su ambiente
acogedor.
	Este restaurante lanzó un nuevo menú a principios de año y ha estado recopilando
información detallada sobre las transacciones de los clientes para identificar áreas de
oportunidad y aprovechar al máximo sus datos para optimizar las ventas.

Objetivo: Identificar cuáles son los productos del menú que han tenido más éxito y cuales son los que
menos han gustado a los clientes.
*/


-- a) Crear la base de datos con el archivo create_restaurant_db.sql
-- b) Explorar la tabla “menu_items” para conocer los productos del menú.
	
Select * from menu_items;

-- 1.- Realizar consultas para contestar las siguientes preguntas:
-- Encontrar el número de artículos en el menú.
SELECT COUNT(item_name) AS numero_articulos
FROM menu_items;

SELECT COUNT(*) AS numero_articulos
FROM menu_items;

-- ¿Cuál es el artículo menos caro y el más caro en el menú?

-- Artículo menos caro
SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items);

-- Artículo más caro
SELECT item_name, price
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items);

-- ¿Cuántos platos americanos hay en el menú?

SELECT COUNT(*) AS cantidad_platos_americanos
FROM menu_items
WHERE category = 'American';

-- ¿Cuál es el precio promedio de los platos?

SELECT AVG(price) AS precio_promedio
FROM menu_items;

/* c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
1.- Realizar consultas para contestar las siguientes preguntas:
*/

Select * from order_details;
-- ¿Cuántos pedidos únicos se realizaron en total?

SELECT COUNT(DISTINCT order_id) AS total_pedidos_unicos
FROM order_details;

-- ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?

SELECT order_id, COUNT(item_id)) AS numero_articulos
FROM order_details
GROUP BY order_id
ORDER BY numero_articulos DESC
LIMIT 5;

-- ¿Cuándo se realizó el primer pedido y el último pedido?

-- Fecha del primer pedido
SELECT MIN(order_date) AS fecha_primer_pedido
FROM order_details;

-- Fecha del último pedido
SELECT MAX(order_date) AS fecha_ultimo_pedido
FROM order_details;

-- ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?

SELECT COUNT(DISTINCT order_id) AS pedidos_rango_fechas
FROM order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';

/*  Usar ambas tablas para conocer la reacción de los clientes respecto al menú.

1.- Realizar un left join entre entre order_details y menu_items con el identificador
item_id(tabla order_details) y menu_item_id(tabla menu_items) 

*/

select * 
from order_details as o
left join menu_items as m 
on o. item_id = menu_item_id;

-- 1. Artículos Más Rentables
SELECT mi.menu_item_id, mi.item_name, COUNT(od.item_id) * mi.price AS ingresos_totales
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.menu_item_id, mi.item_name, mi.price
having mi.menu_item_id <> 0
ORDER BY ingresos_totales DESC
LIMIT 5;

-- 2. Artículos con Más Pedidos

SELECT mi.menu_item_id, mi.item_name, COUNT(od.item_id) AS cantidad_pedidos
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.menu_item_id, mi.item_name
ORDER BY cantidad_pedidos DESC
LIMIT 5;

-- 3. Artículos Menos Populares

SELECT mi.menu_item_id, mi.item_name, COUNT(od.item_id) AS cantidad_pedidos
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.menu_item_id, mi.item_name
	having mi.menu_item_id <> 0
ORDER BY cantidad_pedidos ASC
LIMIT 5;

-- 4. Rendimiento por Categoría

SELECT mi.category, COUNT(od.item_id) AS cantidad_articulos_pedidos, SUM(mi.price) AS ingresos_totales
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.category
	ORDER BY cantidad_articulos_pedidos DESC;

-- 5. Tendencias Temporales de Pedidos

SELECT DATE_TRUNC('month', order_date) AS mes, COUNT(DISTINCT order_id) AS cantidad_pedidos
FROM order_details
GROUP BY mes
ORDER BY mes;



