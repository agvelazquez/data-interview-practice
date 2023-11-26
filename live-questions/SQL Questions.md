Preguntas frecuentes sobre entrevistas de SQL

Nivel de agregacion
1. ¿Cómo identificarías duplicados de una tabla?
Hay varias alternativas, acá algunas:
1.	En caso de que haya una columna de identidad, podes usar row_number y eliminar aquellos registros mayores que uno. 
2.	Podes usar group by junto con count(1) para saber si existe una o más de una columna con count(1)>1.
2. ¿Cómo eliminarías duplicados de una tabla?
Una opción es usar una window function de la siguiente manera:
1.	Usar row_number() particionado por la clave que deseas verificar y llamar a la columna “rn”
2.	Poner todo dentro de un cte (common table expresión).
3.	Seleccionar del cte donde rn > 1 y eliminar el resultado. 

3. Que es el nivel de agregación o granularidad de una tabla?
Representa el mínimo nivel de detalle que se encuentra la tabla, es decir que información se necesita para definir unívocamente a cada registro. 
Si tengo una tabla con la cantidad de lluvia por día, el nivel de granularidad es día. Si a eso le agrego el código postal (CP) donde ocurrió la lluvia, el nivel de detalle es CP y dia. 
Sin embargo, si agrego una columna “ciudad”, el nivel de detalle sigue siendo CP y día por que el CP ya contiene la información de la ciudad en sí mismo y una ciudad puede tener múltiples CP.  

Window Functions 
2. ¿Cuál es la diferencia entre rank y row_number?
Solo se verá la diferencia si existen repetidos dentro de una partición para un valor de orden particular. 
rank es deterministas, todas las filas con el mismo valor para las columnas de ordenación y partición terminarán con un resultado igual, row_number asignará arbitrariamente (no determinista) un resultado incremental a las filas empatadas.
Entonces la diferencia principal es que uno resuelve los empates deterministamente y el otro aleatoriamente.
3. ¿Cuál es la diferencia entre rank y dense_rank?
rank() te da la clasificación dentro de su partición ordenada. A los empates se les asigna el mismo rango, y se saltan los siguientes rangos. Entonces, si tiene 3 elementos en el rango 2, el siguiente rango en la lista sería el 5.
dense_rank() nuevamente te brinda la clasificación dentro de su partición ordenada, pero las clasificaciones son consecutivas. No se saltan rangos si hay rangos con varios elementos.
5. ¿Qué es una window function (funciones ventanas)?
En resumen hacen tres cosas: 
Las windows functions me permiten generar valores sobre una o más columnas en una partición de los datos y al mismo tiempo mantener las filas de la tabla.

1.	Particionan los datos en grupos.
2.	Hacen un cálculo por cada grupo. 
3.	Combinan los resultados de ese cálculo devuelta al dataset original.

Hay tres clases de windows functions pero todas tienen la misma estructura


1.	Aggregate windows functions (funciones ventana de agregación): sum, max, min, avg, count
2.	Ranking windows functions (funciones ventana de ranking): rank, dense_rank, row_number
3.	Value windows functions (funciones ventana de valor): lag, lead

6. ¿Qué es un total acumulado?
Es una window function con SUM OVER y ORDER BY. 
Ejemplo: SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total. Si hay valores duplicados en ORDER BY, SQL duplicará el valor total acumulado. Necesita una columna no duplicada o agregar la expresión FILAS ENTRE LA FILA PRECEDENTE Y ACTUAL ILIMITADA. el motivo es que la orden utiliza RANGO ENTRE.
7. ¿Qué son las funciones lag() y lead()?
Ambas son funciones posicionales o de valor (un tipo de window function), pueden referirse a datos de filas arriba o debajo de la fila actual.
18. ¿Cómo calcularías una regla de Pareto sobre una tabla con las ventas de cada tienda?
1. Agrupar los datos por tienda y clasificarlos por ventas en un CTE. 
2. Calcular un total acumulado (running total) y divida la cantidad total, por ejemplo: suma (cantidad) SOBRE (ORDENAR POR rn ASC) / suma (cantidad) SOBRE () como porcentaje_acumulativo 
3. Usando la información del porcentaje_acumulativo, puede cortar los datos para encontrar tiendas hasta un 20% en ventas.

Joins
9. ¿Qué se debe tener en cuenta al realizar un left join?
Un left join puede provocar la duplicación de registros en la tabla izquierda si existe más de un registro en la tabla derecha para la clave de combinación. Para eso es muy importante entender el nivel de agregación de cada tabla y verificar que se encuentren en el mismo nivel.


10. ¿Qué hace un full outer join?
Un full outer join recupera todos los datos de las tablas izquierda y derecha. Se pueden dar las siguiente situaciones: 
1.	En caso de que no haya ninguna coincidencia con la tabla izquierda, la tabla derecha generará valores nulos.
2.	En caso que haya valores de la tabla derecha que no esten en la izquierda, traerá esos valores con null en la izquierda.
3.	En caso que haya coincidencia funcionara como un inner join.
31. ¿Qué es un selfjoin?
Un selfjoin se utiliza para la tabla consigo misma. Un caso de uso puede ser para comparar valores en una columna con otros valores en la misma columna de la misma tabla.
Ejemplo: Si tengo una tabla empleados donde hay una columna de manager_id que hace referencia a id de empleado, voy a tener que hacer un selfjoin en id de empleado y manager_id para obtener quien es el manager de cada empleado.
32. ¿Qué es un cross-Join?
Un cross-join se define como un producto cartesiano en el que el número de filas de la primera tabla se multiplica por el número de filas de la segunda tabla. Si la cláusula where se usa en el cross-join, la consulta funcionará como un inner join.
13. ¿Diferencia entre cross join y full outer join?
Un cross-join produce un producto cartesiano entre las dos tablas, devolviendo todas las combinaciones posibles de todas las filas. No tiene una cláusula porque simplemente estás uniendo todo a todo.
Un full outer join seria como una combinación de left join y un right join. Devuelve todas las filas de ambas tablas que coinciden con la cláusula de unión de la consulta y, en los casos en que no se puede cumplir la condición on para esas filas, coloca valores nulos para los campos vacíos.
19. ¿Cuál es la diferencia entre un inner join y outer join?
Un inner join devolverá los datos que se cruzan (o son comunes) entre ambas tablas, mientras que un outer join devolverá todo lo de una tabla y la intersección de ambas tablas o devolverá todo lo de ambas tablas, ya sea que se crucen o no.
17. ¿Cuál es la diferencia entre la inner join y la left join cuando la columna clave tiene valores nulos?
Las columnas que contienen NULL no coinciden con ningún valor cuando crea una inner join. En un left join aún conserva todas las filas de la primera tabla con valores null para la segunda tabla. null no es igual a null, por lo que no coincidirán en un left join.

Integridad referencial 
20. ¿Qué es una primary key (clave primaria)?
Una primary key (PK) es una combinación de campos que especifican de forma única una fila. Este es un tipo especial de clave única y tiene una restricción implícita NOT NULL. Significa que los valores de la clave principal no pueden ser NULL.
21. ¿Qué es una foreign key (clave foránea)?
Una foreign key (FK) de una tabla es una columna que representa una primary key (PK) en otra tabla y se utiliza para relacionar ambas tablas. 
Es decir es la PK de otra tabla. 
27. ¿Qué es un índice (index)?
Se puede imaginar a un índice de una tabla como si fuese un índice de un libro que le permite encontrar la información solicitada muy rápidamente dentro de su libro, en lugar de leer todas las páginas del libro para encontrar un elemento específico que está buscando. 
Además, 
a.	Un índice es un método de ajuste del rendimiento que permite una recuperación más rápida de los registros de la tabla. 
b.	Un índice crea una entrada para cada valor y será más rápido recuperar datos.  
c.	Hay clustered index and non-clustered index (índices no agrupados y agrupados. 
d.	El clustered index modifica la forma en que se almacenan los registros en una base de datos.
43. ¿Por qué se describe un índice como una espada de doble filo? ¿Cuál es la compensación del índice?
Un índice bien diseñado mejorará el rendimiento de su sistema y acelerará el proceso de recuperación de datos. Por otro lado, un índice mal diseñado provocará una degradación del rendimiento del sistema y le costará espacio adicional en disco, además de retrasar las operaciones de inserción y modificación de datos. Siempre es mejor probar el rendimiento del sistema antes y después de agregar el índice al entorno de desarrollo, antes de agregarlo al entorno de producción.
Esto ocurre por que agregar datos en tablas que tienen índices es mas costoso que en tablas que no los tienen.
44. ¿Qué tipo de índices se utilizan para mantener la integridad de los datos de las columnas sobre las que se crea?
Índices únicos (unique index), asegurándose de que no haya valores duplicados en la clave del índice y las filas de la tabla en las que se crea ese índice. 
Generalmente se utiliza una primary key pero se puede agregar una restricción (constraint) de uniqueness a otras columnas.
45. ¿Qué es la integridad referencial (referential integrity)?
Cada foreign key (FK) debe tener una clave principal principal (PK). FK sin padres son huérfanos, esto debe evitarse durante el proceso ETL.
42. ¿Cuántos índices agrupados (clustered index) se pueden crear en una tabla y por qué?
Unn sistema de base de datos OLTP o OLAP nos permite crear solo un índice agrupado por tabla, ya que los datos se pueden ordenar en la tabla utilizando solo un criterio de orden.
46. ¿Qué es una relación (relationships) y cuántos tipos hay?
Una relación de base de datos se define como la conexión entre las tablas de una base de datos.
Hay varios tipos de relaciones de base de datos:
1. Relación uno a uno.
2. Relación uno a muchos.
3. Relación de muchos a uno.
4. Relación autorreferencial.

Normalización
22. ¿Qué es la normalización (normalization)?
La normalización es el proceso de minimizar la redundancia y la dependencia organizando los campos y la tabla de una base de datos. Hay dos objetivos del proceso de normalización:
1.	Eliminar datos redundantes (por ejemplo, almacenar los mismos datos en más de una tabla) 
2.	 Garantizar que las dependencias de datos tengan sentido (almacenar solo datos relacionados en una tabla)
23. ¿Qué es la desnormalización (desnormalization)?
Es el proceso de introducir redundancia en una tabla mediante la incorporación de datos de las tablas relacionadas.
Se permite cierta repetición de datos para reducir la cantidad de joins y simplificar las querys. 
24. ¿Cuáles son todas las diferentes normalizaciones?
Las formas normales se pueden dividir en 5 formas, de las tres mas usadas son:
1.	Primera Forma Normal (1FN):. No utilice varios campos en una sola tabla para almacenar datos similares. 
2.	Segunda forma normal (2FN):. Los registros no deben depender de nada más que de la clave principal de una tabla (una clave compuesta, si es necesario). 
3.	Tercera Forma Normal (3NF):. Eliminar campos que no dependan de la clave. Adherirse a la tercera forma normal, aunque teóricamente deseable, no siempre es práctico. Si tiene una tabla Clientes y desea eliminar todas las posibles dependencias entre campos, debe crear tablas separadas para ciudades, códigos postales, representantes de ventas, clases de clientes y cualquier otro factor que pueda duplicarse en varios registros.
En teoría, vale la pena buscar la normalización. Sin embargo, muchas tablas pequeñas pueden degradar el rendimiento o exceder las capacidades de memoria y archivos abiertos.


Modelado de Datos 
16. ¿Cómo construyes una tabla acumulativa?
1.	Construya su tabla de dimensiones diarias. Esto debe deduplicarse en la clave principal de su dimensión
2.	FULL OUTER une los datos de la tabla acumulativa de ayer y las dimensiones diarias de hoy. (La primera ejecución tendrá la tabla acumulativa de ayer vacía)
3.	Cree matrices, listas de fechas y SCD que contengan el historial acumulativo de la dimensión. En general, he visto un mejor rendimiento de actualización acumulativa al usar UNION (daily + cur_cumulative) y luego GROUP BY con SUM
25. Cual es la diferencia entre el (star schema) esquema de estrella  y (snowflake schema) copo de nieve?
1.	Las tablas de dimensiones del star schema no están normalizadas, mientras que para un esquma tipo snowflake están normalizadas.
2.	Los esquemas de copos de nieve utilizarán menos espacio para almacenar tablas de dimensiones, pero son más complejos.
3.	Los esquemas en estrella solo unirán la tabla de hechos con las tablas de dimensiones, lo que generará consultas SQL más simples y rápidas.
4.	Los esquemas de copo de nieve no tienen datos redundantes, por lo que son más fáciles de mantener.
5.	Los esquemas de copo de nieve son buenos para almacenes de datos, los esquemas de estrella son mejores para datamarts con relaciones simples.
6.	28. ¿Cuál es el nivel de granularidad de una tabla de hechos?
7.	Una tabla de hechos generalmente se diseña con un bajo nivel de granularidad. Esto significa que necesitamos encontrar el nivel más bajo de información que se pueda almacenar en una tabla de hechos, por ejemplo, el desempeño de los empleados tiene un nivel muy alto de granularidad. Employee_performance_daily y employee_perfomance_weekly se pueden considerar como niveles más bajos de granularidad. La granularidad es el nivel más bajo de información almacenada en la tabla de hechos. La profundidad del nivel de datos se conoce como granularidad. En la dimensión de fecha, el nivel podría ser el año, mes, trimestre, período, semana y día de granularidad. El proceso consta de los siguientes dos pasos: Determinar las dimensiones que se van a incluir. Determinación de la ubicación para encontrar la jerarquía de cada dimensión de la información Los factores de determinación anteriores se volverán a enviar según los requisitos.
8.	29. ¿Cuáles son los diferentes tipos de SCD que se utilizan en el almacenamiento de datos?
9.	SCD (dimensiones que cambian lentamente) son las dimensiones en las que los datos cambian lentamente, en lugar de cambiar regularmente en el tiempo. En el Data Warehousing se utilizan tres tipos de SCDs: SCD1: Es un registro que se utiliza para reemplazar el registro original aun cuando solo exista un registro en la base de datos. Los datos actuales serán reemplazados y los nuevos datos tomarán su lugar. SCD2: Es el nuevo archivo de registro que se agrega a la tabla de dimensiones. Este registro existe en la base de datos con los datos actuales y los datos anteriores que se almacenan en el historial. SCD3: utiliza los datos originales que se modifican a los nuevos datos. Este consta de dos registros: un registro que existe en la base de datos y otro registro que reemplazará el antiguo registro de la base de datos con la nueva información.

Optimizacion
41. ¿Por qué no se recomienda crear índices en tablas pequeñas? (tipo de pregunta del servidor SQL pero el mismo concepto se aplica a MPP)
Al motor de SQL Server le toma menos tiempo escanear la tabla subyacente que recorrer el índice cuando busca datos específicos. En este caso, el índice no se utilizará, pero aún afectará negativamente el rendimiento de las operaciones de modificación de datos, ya que siempre se ajustará al modificar los datos de la tabla subyacente.
39. Enumere todos los recursos que verificará para optimizar una consulta
Revisa mi publicación anterior aquí . Tenga en cuenta que hay más recursos para conocer en MPP Data Warehouse.

Valores nulls 
12. ¿Qué hace la función NULLIF? Da un ejemplo de cuándo puedes usarlo.
La función NULLIF() devuelve NULL si dos expresiones son iguales, de lo contrario, devuelve la primera expresión. Puede usarlo para evitar el error de "dividir por cero".
14. ¿Una unión interna genera valores nulos? ¿Cómo se escribe la consulta para tener valores nulos?
La inner join no incluye valores NULL, debe agregar una cláusula OR en la combinación para incluir NULL de ambas columnas
11. ¿Qué hace la función ISNULL? ¿Cuál es la diferencia con COALESCE?
Ambos proporcionan un valor predeterminado en los casos en que la entrada es NULL. ISNULL devuelve el valor especificado SI la expresión es NULL, de lo contrario, devuelve la expresión. COALESCE acepta múltiples valores y es común a diferentes lenguajes SQL.
Otros

1.	¿Cuál es la diferencia entre COUNT(*), COUNT(1) y COUNT(column_name)?
COUNT(*) y COUNT(1) son exactamente iguales. Ambos devolverán la cantidad de filas que coinciden con los criterios, incluido NULL, y ambos se ejecutarán al mismo tiempo. COUNT(column_name) excluirá los valores NULL presentes en column_name.
15. ¿Qué es DATE_TRUNC? ¿En caso de que puedas usarlo?
Es una función para redondear o truncar una marca de tiempo al intervalo que necesita, es útil para encontrar tendencias basadas en el tiempo como compras diarias o calcular el crecimiento entre meses o años.
26. ¿Qué es una Vista?
Una vista es una tabla virtual que consta de un subconjunto de datos contenidos en una tabla. Las vistas no están virtualmente presentes y se necesita menos espacio para almacenarlas. Una vista puede tener datos de una o más tablas combinadas, y depende de la relación.
30. ¿Cuál es la diferencia entre los comandos DELETE, TRUNCATE y DROP?
El comando DELETE se usa para eliminar filas de la tabla, y la cláusula WHERE se puede usar para un conjunto condicional de parámetros. La confirmación y la reversión se pueden realizar después de la declaración de eliminación. TRUNCATE elimina todas las filas de la tabla. La operación de truncado no se puede deshacer. DROP elimina el objeto de la tabla.

Arquitectura
33. ¿Cuáles son las diferencias entre OLTP y OLAP?
OLTP significa Procesamiento de transacciones en línea, es una clase de aplicaciones de software capaces de admitir programas orientados a transacciones. Un atributo importante de un sistema OLTP es su capacidad para mantener la concurrencia. Los sistemas OLTP a menudo siguen una arquitectura descentralizada para evitar puntos únicos de falla. Estos sistemas generalmente están diseñados para una gran audiencia de usuarios finales que realizan transacciones cortas. Las consultas involucradas en tales bases de datos son generalmente simples, necesitan tiempos de respuesta rápidos y devuelven relativamente pocos registros. Un número de transacciones por segundo actúa como una medida efectiva para tales sistemas.
OLAP significa procesamiento analítico en línea, una clase de programas de software que se caracterizan por la frecuencia relativamente baja de las transacciones en línea. Las consultas suelen ser demasiado complejas e implican un montón de agregaciones. Para los sistemas OLAP, la medida de efectividad depende en gran medida del tiempo de respuesta. Dichos sistemas se utilizan ampliamente para la extracción de datos o el mantenimiento de datos históricos agregados, generalmente en esquemas multidimensionales.
34. ¿Qué es MPP (Massive Parallel Processing)?
Es un tipo de arquitectura de almacén de datos donde el nodo de control ejecuta el motor MPP que optimiza las consultas para el procesamiento paralelo y luego pasa las operaciones a los nodos de cómputo para que hagan su trabajo en paralelo. Los nodos Compute almacenan todos los datos del usuario en el almacenamiento, que es independiente de la computación, y ejecutan consultas paralelas.
35. ¿Qué es una DWU?
DWU significa Unidades de almacenamiento de datos. Se utilizan para medir el rendimiento. Más DWU significa más rendimiento (y costos más altos)
36. ¿Cuál es la opción de distribución de una tabla en un MPP DW?
Este concepto varía de un proveedor a otro, pero en general, tenemos tres tipos de distribuciones:
1. ROUND ROBIN o HEAP: una tabla distribuida por turnos distribuye las filas de la tabla de manera uniforme en todas las distribuciones. La asignación de filas a las distribuciones es aleatoria.
2. DISTRIBUCIÓN HASH: una tabla con distribución hash distribuye las filas de la tabla entre los nodos de Compute mediante el uso de una función hash determinista para asignar cada fila a una distribución.
3. REPLICADO: las tablas replicadas se replican en todos los nodos, es decir, cada nodo de cálculo tiene una copia de todas las filas de la tabla replicada.
37. ¿Cuál es la diferencia entre un almacén de datos y un data mart?
Un almacén de datos es un conjunto de datos aislados de los sistemas operativos. Esto ayuda a una organización a lidiar con su proceso de toma de decisiones. Un data mart es un subconjunto de un almacén de datos que está orientado a una línea de negocios en particular. Los data marts proporcionan el stock de datos condensados recopilados en la organización para la investigación en un campo o entidad en particular. Un almacén de datos suele tener un tamaño superior a 100 GB, mientras que el tamaño de un data mart suele ser inferior a 100 GB. Debido a la disparidad en el alcance, el diseño y la utilidad de los data marts son comparativamente más simples.
38. Explique la arquitectura de 3 capas del ciclo ETL.
La capa de preparación, la capa de integración de datos y la capa de acceso son las tres capas que están involucradas en un ciclo ETL. Capa de ensayo: se utiliza para almacenar los datos extraídos de varias estructuras de datos de la fuente. Capa de integración de datos: los datos de la capa de preparación se transforman y transfieren a la base de datos mediante la capa de integración. Los datos se organizan en grupos jerárquicos (a menudo denominados dimensiones), hechos y agregados. En un sistema DW, la combinación de tablas de hechos y dimensiones se denomina esquema. Capa de acceso: para informes analíticos, los usuarios finales utilizan la capa de acceso para recuperar los datos.



----------------------------------------------------------



