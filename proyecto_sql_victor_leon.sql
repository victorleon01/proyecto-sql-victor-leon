-- 1. Crea el esquema de la BBDD
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY 1;

-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’
SELECT title, rating 
FROM film
WHERE rating = 'R'
ORDER BY title;

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40
select *
from actor
where actor_id between 30 and 40
order by actor_id;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
select *
from film 
where original_language_id is not null
	and language_id = original_language_id;
		/*No aparece ninguna con esta consulta,
		hacemos lo siguiente para comprobar cuántas hay en total
		 y cuántas de estas son nulas.*/
		SELECT 
  			COUNT(*)	AS total,
  			COUNT(*) FILTER (WHERE original_language_id IS NULL)	AS nulls,
  			COUNT(*) FILTER (WHERE original_language_id IS NOT NULL)	AS no_nulls
		FROM film;
		/*con esta consulta vemos que de 1000 que hay en total 1000 nulas
		por lo que no podríamos saber cuántas de estas
		coinciden el idioma con el idioma original.*/
		select name
		from language ;
		/*otra opción es hacer esto último que posteriormente
		 he visto que hay una tabla de LANGUAGE
		 donde se unen LANGUAGE_ID y ORIGINAL_LANGUAGE_ID.*/

-- 5. Ordena las películas por duración de forma ascendente.
select *
from film
	order by "length" asc;

-- 6. Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido.
select a.first_name, a.last_name 
from actor a 
	where last_name = 'ALLEN'
		order by actor_id;

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla "film" y muestra la clasificación junto con el recuento.
select rating,
count(*) as total
from film f
group by rating
order by rating ;

-- 8. Encuentra el título de todas las películas que son 'PG-13' o tienen una duración mayor a 3 horas en la tabla "film".
select f.title, f.length 
from film f 
where rating = 'PG-13' or length > 180
order by f.title;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT f.replacement_cost,
       AVG(replacement_cost) AS media,
       VARIANCE(replacement_cost) AS varianza,
       STDDEV(replacement_cost) AS desviacion
FROM film f
GROUP BY f.replacement_cost;
	-- Haciendo esto sale 0 porque no se toma ningún valor del que ver la variabilidad pero podríamos hacer un cálculo de la variabilidad en base a la media del coste de reemplazo
	WITH media_global AS (
  	SELECT AVG(replacement_cost) AS media
  	FROM film
	)
	SELECT
 	 f.replacement_cost,
  (f.replacement_cost - m.media) AS desviacion
	FROM film AS f
	CROSS JOIN media_global AS m
	order by f.replacement_cost ASC;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select
	MAX(length) as max_duracion,
	MIN(length) as min_duracion
from film f;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select
	amount,
	payment_date 
from payment
order by payment_date desc
offset 2
limit 1;

-- 12. Encuentra el título de las películas en la tabla "film" que no sean ni 'NC-17' ni 'G'.
select title, rating
from film
where rating not in ('NC-17', 'G')
order by title;

-- 13. Encuentra el promedio de duración de las películas para cada clasificación (rating) y muestra rating + promedio.
select rating,
 	AVG(length) as promedio_duracion
from film f 
group by f.rating;

-- 14. Encuentra el título de todas las películas con duración mayor a 180 minutos.
select title
from film f
where length > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
select
	SUM(amount) as total
from payment;

-- 16. Muestra los 10 clientes con mayor valor de id.
select
	concat(c."FirstName" , ' ', c."LastName" ) as "Clientes",
	c."CustomerId"
from "Customer" c 
order by "CustomerId" desc
limit 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título 'Egg Igby'.
select
	f.title as titulo,
	fa.actor_id,
	a.first_name as nombre,
	a.last_name as apellido
FROM film AS f
JOIN film_actor AS fa
	ON fa.film_id = f.film_id
JOIN actor AS a
	ON a.actor_id = fa.actor_id
WHERE f.title = 'EGG IGBY'
order by a.actor_id;

-- 18. Selecciona todos los títulos de películas únicos.
select f.title
from film f 
group by f.title 
having count(f.title) = 1;

-- 19. Encuentra los títulos de las películas que son comedias y duran más de 180 minutos.
select
	f.title as "Título",
	f.length as "Duración"
from film as f
join film_category as fc
	on f.film_id = fc.film_id 
join category as c
	on fc.category_id = c.category_id 
where c."name" = 'Comedy' and f.length > 180
order by f.length asc;

-- 20. Categorías con promedio de duración > 110 minutos; mostrar nombre de categoría + promedio.
select
	c."name" as "Categoría",
	AVG(f.length) as "Promedio_duración"
from film as f
	join film_category as fc
		on f.film_id = fc.film_id  
	join category as c
		on fc.category_id = c.category_id
group by c."name"
having AVG(f.length) > 110
order by AVG(f.length) asc;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
select
	AVG(f.rental_duration) as promedio_duracion_alquiler
from film f;

-- 22. Crea una columna con el nombre completo (nombre + apellidos) de todos los actores/actrices.
select
	distinct 
		concat(first_name, ' ', last_name) as nombre_completo
from actor
order by nombre_completo;

-- 23. Número de alquileres por día, ordenado por cantidad de forma descendente.
select
	rental_date::date as fecha,
	count(*) as total_alquileres
from rental
group by fecha 
order by fecha asc;

-- 24. Películas con duración superior al promedio de todas las películas.
select
	title,
	length 
from film
where length > (
	select
		AVG(length)
	from film
	)
order by length;

-- 25. Número de alquileres registrados por mes.
select
	extract(month from rental_date) as mes,
	count(*) as total_alquileres
from rental
group by mes
order by mes asc;

-- 26. Promedio, desviación estándar y varianza del total pagado.
select
	AVG(p.amount) as promedio,
	stddev(p.amount) as "desviación_estándar",
	variance(p.amount) as varianza
from payment p;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
select
	f.title as titulo,
	p.amount as precio_alquiler
from film as f
	join inventory as i
		on f.film_id = i.film_id 
	join rental as r
		on r.inventory_id = i.inventory_id 
	join payment as p
		on p.rental_id = r.rental_id 
where p.amount > (select
	AVG(p2.amount )
	from payment p2 
	);

-- 28. Id de los actores que hayan participado en más de 40 películas.
select
	fa.actor_id, 
	count(*) as numero_peliculas
from film_actor fa
group by actor_id
having
	count(*) > 40
order by numero_peliculas asc;

-- 29. Obtener todas las películas y, si están en inventario, mostrar la cantidad disponible.
select
	f.title as titulo_pelicula,
	count(*) as cantidad_disponible
from film as f
	join inventory as i
		on i.film_id = f.film_id
group by f.title
order by f.title asc;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
select
	concat(a.first_name, ' ', a.last_name) as actores,
	count(*) as numero_participacion_peliculas
from film as f
	join film_actor as fa
		on f.film_id = fa.film_id 
	join actor as a
		on a.actor_id = fa.actor_id 
group by actores
order by actores;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select
	f.title as titulo_pelicula,
	string_agg(concat(a.first_name, ' ', a.last_name), ', ') as actores
from film as f
	left join film_actor as fa
		on f.film_id = fa.film_id 
	left join actor as a
		on a.actor_id = fa.actor_id
group by titulo_pelicula 
order by titulo_pelicula;

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
select
	concat(a.first_name , ' ', a.last_name ) as actor,
	f.title as titulo_pelicula
from actor as a
	left join film_actor as fa
		on fa.actor_id = a.actor_id
	left join film as f
		on f.film_id   = fa.film_id
order by actor, titulo_pelicula;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
select
	f.title as titulo_pelicula,
	i.inventory_id,
	r.rental_date as fecha_alquiler
from film as f
	left join inventory as i
		on f.film_id = i.film_id 
	left join rental as r
		on i.inventory_id = r.inventory_id
order by titulo_pelicula asc;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select
  c.customer_id,
  concat(c.first_name, ' ', c.last_name) as cliente,
  SUM(p.amount) as dinero_gastado
from customer as c
	join payment  as p
		on p.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by dinero_gastado desc, cliente
limit 5;


-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select
    a.first_name,
    a.last_name
from actor a
where a.first_name ilike 'johnny';

-- 36. Renombra la columna "first_name" como Nombre y "last_name" como Apellido.
select
	first_name as "Nombre",
	last_name as "Apellido"
from actor;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select
	MIN(a.actor_id) as más_bajo,
	MAX(a.actor_id) as más_alto
from actor a;
-- 38. Cuenta cuántos actores hay en la tabla "actor".
select
	count(*) as total_actores
from actor a;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select *
from actor a 
order by a.last_name asc;

-- 40. Selecciona las primeras 5 películas de la tabla "film".
select f.title 
from film f 
order by f.film_id asc
limit 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select
	a.first_name,
	count(*) as repeticiones
from actor a 
group by a.first_name
order by repeticiones desc;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select
    r.rental_id,
    r.rental_date,
    c.first_name
from rental r
join customer c
    on r.customer_id = c.customer_id;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select
	c.first_name,
	c.last_name,
	f.title
from customer c
	left join rental r 
		on c.customer_id = r.customer_id 
	left join inventory i 
		on i.inventory_id = r.inventory_id 
	left join film f 
		on f.film_id = i.film_id 
order by c.first_name asc;

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select *
from film f 
cross join category c;

	/* Según lo que se esté buscanod, de forma general creo
	que si aporta riqueza a la tabla film permitiendo conocer
	una característica relevante cuando estamos mirando películas.
	Personalmente cuando busco películas en plataformas como Netflix,
	además del título por ejemplo intento ver también si aparece de qué
	categoría es para ver si además del título me llama la atención también
	por su categoría. */ 

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select distinct
  a.first_name as nombre,
  a.last_name  as apellido
from actor a
	join film_actor fa
		on fa.actor_id = a.actor_id
	join film f 
		on f.film_id   = fa.film_id
	join film_category fc
		on fc.film_id  = f.film_id
	join category      c 
		on c.category_id = fc.category_id
where c.name = 'Action'
order by nombre, apellido;
	
-- 46. Encuentra todos los actores que no han participado en películas.
select
	a.first_name as nombre,
	a.last_name as apellido
from actor as a 
	left join film_actor as fa 
		on a.actor_id = fa.actor_id 
	join film as f
		on f.film_id = fa.film_id 
where f.title is null
order  by nombre, apellido;

	/* Al hacer esta pregunta no me daba ninguna
	respuesta por tanto para ver si hay o no actores
	que no aparezcan en ninguna película he hecho lo siguiente */
	select count(*) as actores_sin_peliculas
	from actor a
		left join film_actor fa
			on fa.actor_id = a.actor_id
	where fa.actor_id is null;

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select
  concat(a.first_name, ' ', a.last_name) as actor,
  count(fa.film_id)                    as num_peliculas
from actor a
left join film_actor fa
  on fa.actor_id = a.actor_id
group by a.actor_id, a.first_name, a.last_name
order by actor asc;

-- 48. Crea una vista llamada "actor_num_peliculas" que muestre los nombres de los actores y el número de películas en las que han participado.
create view public.actor_num_peliculas as
select
  concat(a.first_name, ' ', a.last_name) as actor,
  count(fa.film_id) as num_peliculas
from public.actor a
left join public.film_actor fa
  on fa.actor_id = a.actor_id
group by a.actor_id, a.first_name, a.last_name;

/* Para comprobar si realmente hemos conseguido
 crear la view ejecuto el siguiente código y
 efectivamente ha quedado creado */

select * 
from public.actor_num_peliculas
order by num_peliculas desc, actor;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
select
	c.customer_id,
	concat(c.first_name, ' ', c.last_name) as cliente,
	count(*) as total_alquileres
from customer as c 
	join rental as r
		on c.customer_id = r.customer_id
group by c.customer_id, cliente 
order by c.first_name asc;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select
	c.name as categoria,
	SUM(f.length ) as minutos_totales
from film f 
	join film_category fc
		on f.film_id = fc.film_id
	join category c 
		on fc.category_id = c.category_id
where c."name" = 'Action'
group by c."name" ;

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
create temporary table cliente_rentas_temporal as
	select
		c.customer_id,
		concat(c.first_name, ' ', c.last_name) as cliente,
		count(r.rental_id) as total_alquileres
	from customer c
		left join rental r
			on r.customer_id = c.customer_id
	group by c.customer_id, c.first_name, c.last_name
	order by total_alquileres desc;

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
create temporary table peliculas_alquiladas as
	select
    	f.title as titulo,
    	count(r.rental_id) as num_alquileres
	from film f
		left join inventory i
   			 on f.film_id = i.film_id
		join rental r
    		on r.inventory_id = i.inventory_id
	group by f.title
	having count(r.rental_id) >= 10
	order by titulo asc;
		
-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
select
    f.title as titulo
from rental r
	join inventory i 
    	on r.inventory_id = i.inventory_id
	join film f 
    	on i.film_id = f.film_id
	join customer c 
    	on r.customer_id = c.customer_id
where c.first_name = 'TAMMY'
  and c.last_name = 'SANDERS'
  and r.return_date is null
order by f.title asc;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
select distinct a.first_name, a.last_name
from actor a
	join film_actor fa
		on fa.actor_id = a.actor_id
	join film_category fc
		on fc.film_id = fa.film_id
	join category c
		on c.category_id = fc.category_id
	where c.name = 'Sci-Fi'
	order by a.last_name, a.first_name;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
with primera_renta as (
	select min(r.rental_date) as min_fecha
	from film f
		join inventory i
			on i.film_id = f.film_id
		join rental r
			on r.inventory_id = i.inventory_id
	where f.title = 'Spartacus Cheaper'
	)
select distinct a.first_name, a.last_name
from actor a
	join film_actor fa
		on fa.actor_id = a.actor_id
	join inventory i
		on i.film_id = fa.film_id
	join rental r
		on r.inventory_id = i.inventory_id
	cross join primera_renta pr
where r.rental_date > pr.min_fecha
order by a.last_name, a.first_name;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
select a.first_name, a.last_name
from actor a
where not exists (
	select 1
	from film_actor fa
		join film_category fc
			on fc.film_id = fa.film_id
		join category c
			on c.category_id = fc.category_id
	where fa.actor_id = a.actor_id
		and c.name = 'Music'
	)
order by a.last_name, a.first_name;

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select distinct f.title
from film f
	join inventory i
		on i.film_id = f.film_id
	join rental r
		on r.inventory_id = i.inventory_id
where r.return_date is not null
	and (r.return_date - r.rental_date) > interval '8 days'
order by f.title;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
select f.title
from film f
	join film_category fc
		on fc.film_id = f.film_id
	join category c
		on c.category_id = fc.category_id
where c.name = 'Animation'
order by f.title;

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
select f.title
from film f
where f.length = (
	select length
	from film
	where title = 'DANCING FEVER'
	)
order by f.title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
select
	c.first_name,
	c.last_name,
	count(distinct i.film_id) as peliculas_distintas
from customer c
	join rental r
		on r.customer_id = c.customer_id
	join inventory i
		on i.inventory_id = r.inventory_id
group by c.customer_id, c.first_name, c.last_name
having count(distinct i.film_id) >= 7
order by c.last_name, c.first_name;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
select
	c.name as categoria,
	count(*) as total_alquileres
from rental r
	join inventory i
		on i.inventory_id = r.inventory_id
	join film_category fc
		on fc.film_id = i.film_id
	join category c
		on c.category_id = fc.category_id
group by c.name
order by c.name;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
select
	c.name as categoria,
	count(*) as num_peliculas
from film f
	join film_category fc
		on fc.film_id = f.film_id
	join category c
		on c.category_id = fc.category_id
where f.release_year = 2006
group by c.name
order by c.name;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select
	s.staff_id,
	s.first_name,
	s.last_name,
	st.store_id
from staff s
	cross join store st
order by s.staff_id, st.store_id;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select
	c.customer_id,
	c.first_name, c.last_name,
	count(distinct i.film_id) as peliculas_alquiladas
from customer c
	left join rental r
		on r.customer_id = c.customer_id
	left join inventory i
		on i.inventory_id = r.inventory_id
group by c.customer_id, c.first_name, c.last_name
order by c.customer_id;


