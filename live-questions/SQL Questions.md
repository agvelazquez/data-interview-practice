## SQL Interview Questions


1. What is the difference between COUNT(*), COUNT(1), and COUNT(column_name)?

```
COUNT(*) and COUNT(1) are exactly the same. Both will return the number of rows that match the criteria including NULL and both run at the same time. COUNT(column_name) will exclude NULL values present in the column_name.
```

2. What is the difference between RANK and ROW_NUMBER?

```
You will only see the difference if you have ties within a partition for a particular ordering value. RANK and DENSE_RANK are deterministic in this case, all rows with the same value for both the ordering and partitioning columns will end up with an equal result, whereas ROW_NUMBER will arbitrarily (non deterministically) assign an incrementing result to the tied rows.
```

3. What is the difference between RANK and DENSE_RANK?

```
RANK() gives you the ranking within your ordered partition. Ties are assigned the same rank, with the next ranking(s) skipped. So, if you have 3 items at rank 2, the next rank listed would be ranked 5.

DENSE_RANK() again gives you the ranking within your ordered partition, but the ranks are consecutive. No ranks are skipped if there are ranks with multiple items.
```

4. How to delete duplicates?

```
Use ROW_NUMBER() partitioned by the key you want to check.
Put everything within a CTE.
DELETE FROM CTE WHERE RN>1.
5. What is a Window function?

A window function is a function that performs a calculation in a set of rows defined. Some examples are ROW_NUMBER, RANK, DENSE_RANK, SUM OVER(), AVG OVER(), COUNT OVER(), a running total(using ROW_NUMBER), LAG, and LEAD. A window function does not cause rows to be grouped, all number of rows are conserved.
```

6. What is a running total?

```
It is a window function with a SUM OVER and ORDER BY. Example: SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total. If there are duplicate values in the ORDER BY, SQL will duplicate the running total value. You need a non-duplicate column or add the expression ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW. the reason is that the order uses RANGE BETWEEN.
```

7. What are LAG and LEAD functions?

```
Both are positional functions (a type of window function), they can refer to data from rows above or below the current row.
```
8. How would you remove duplicates from a table?
```
You can use DISTINCT in case there is no ID or IDENTITY column. In case there is an identity column you can use ROW_NUMBER and delete those records greater than one. You can use MAX(ID) to select just one row of the GROUP BY.
```
9. What do you need to take care of when performing an outer join?
```
A left join can cause duplication of records in the left table if exists more than one record in the right table for the joining key.
```
10. What does the full outer join do?
```
A full outer join retrieves all data for left and right tables, in case there is no match of the left table, the right table will bring nulls.
```
11. What does the ISNULL function do? What is the difference with COALESCE?
```
Both provide a default value in cases where the input is NULL. ISNULL returns the specified value IF the expression is NULL, otherwise, return the expression. COALESCE accepts multiple values and is common to different SQL languages.
```
12. What does the NULLIF function do? Give an example of when you can use it.
```
The NULLIF() function returns NULL if two expressions are equal, otherwise, it returns the first expression. You can use it to avoid the “dividing by zero” error.
```
13. Difference between cross join and full outer join?
```
A cross join produces a cartesian product between the two tables, returning all possible combinations of all rows. It has no on clause because you’re just joining everything to everything.

A full outer join is a combination of a left outer and right outer join. It returns all rows in both tables that match the query’s where clause, and in cases where the on condition can’t be satisfied for those rows it puts null values in for the unpopulated fields.
```
14. Does an inner join bring null values? How do you write the query to have null values?
```
Inner join does not include NULL values, you need to add an OR clause in the join the include NULL from both columns
```
15. What is DATE_TRUNC? In case you can use it?
```
Is a function to round or truncate a timestamp to the interval you need, it is useful to find time-based trends like daily purchases or calculate Growth between months or years.
```
16. How do you build a cumulative table?
```
Build your daily dimension table. This should be deduped on the primary key of your dimension
FULL OUTER joins the data from yesterday’s cumulative table and today’s daily dimensions. (The first run will have yesterday’s cumulative table be empty)
Build out arrays, date lists, and SCDs that hold the cumulative history of the dimension. I’ve generally seen better cumulative update performance by using UNION (daily + cur_cumulative) and then GROUP BY with SUM
```
17. What is the difference between the inner join and the left join when the key column has nulls?
```
Columns containing NULL do not match any values when you are creating an inner join. The left join still keeps all rows in the first table with NULL values for the second table. Null is not equal to null so they won’t match in the left join.
```
18. How would you calculate a Pareto rule over a table with sales by each store?
```
First, you need to group the data by store and rank them by sales in a CTE. With that information calculate a running total and divide the total amount, ex: sum(amount) OVER (ORDER BY rn ASC) / sum(amount) OVER () as cumulative_percentage Using the information of the cumulative_percentage then you can cut the data to find stores up to 20% in sales.
```
19. What is the difference between an inner and outer join?
```
An Inner Join will return data that intersects (or is common) between both tables whereas an outer join will return all of one table and the intersection of both tables or will return everything from both tables whether they intersect or not.
```
20. What is a primary key?
```
A primary key is a combination of fields that uniquely specify a row. This is a special kind of unique key, and it has an implicit, NOT NULL constraint. It means Primary key values cannot be NULL.
```
21. What is a foreign key?
```
A foreign key is one table that can be related to the primary key of another table. A relationship needs to be created between two tables by referencing a foreign key with the primary key of another table.
```
22. What is normalization?
```
Normalization is the process of minimizing redundancy and dependency by organizing fields and table of a database. There are two goals of the normalization process: eliminating redundant data (for example, storing the same data in more than one table) and ensuring data dependencies make sense (only storing related data in a table)
```
23. What is denormalization?
```
DeNormalization is a technique used to access the data from higher to lower normal forms of the database. It is also the process of introducing redundancy into a table by incorporating data from the related tables.
```
24. What are all the different normalizations?
```
The normal forms can be divided into 5 forms, and they are explained below -. First Normal Form (1NF):. Do not use multiple fields in a single table to store similar data. Second Normal Form (2NF):. Records should not depend on anything other than a table’s primary key (a compound key, if necessary). Third Normal Form (3NF):. Eliminate fields that do not depend on the key. Adhering to the third normal form, while theoretically desirable, is not always practical. If you have a Customers table and you want to eliminate all possible inter-field dependencies, you must create separate tables for cities, ZIP codes, sales representatives, customer classes, and any other factor that may be duplicated in multiple records. In theory, normalization is worth pursuing. However, many small tables may degrade performance or exceed open file and memory capacities.
```
25. Difference between the star and snowflake schema
```
Star schema dimension tables are not normalized, snowflake schemas dimension tables are normalized.
Snowflake schemas will use less space to store dimension tables but are more complex.
Star schemas will only join the fact table with the dimension tables, leading to simpler, faster SQL queries.
Snowflake schemas have no redundant data, so they’re easier to maintain.
Snowflake schemas are good for data warehouses, star schemas are better for datamarts with simple relationships.
```
26. What is a View?
```
A view is a virtual table that consists of a subset of data contained in a table. Views are not virtually present, and it takes less space to store. A view can have data of one or more tables combined, and it is depending on the relationship.
```
27. What is an Index?
```
An index is a performance tuning method for allowing faster retrieval of records from the table. An index creates an entry for each value and it will be faster to retrieve data. You can imagine a table index akin to a book’s index that allows you to find the requested information very fast within your book, rather than reading all the book pages in order to find a specific item you are looking for. There are non-clustered and clustered indexes. Clustered index modifies the way records are stored in a database based.
```
28. What is the level of granularity of a fact table?
```
A fact table is usually designed at a low level of granularity. This means that we need to find the lowest level of information that can be stored in a fact table e.g., employee performance is a very high level of granularity. Employee_performance_daily and employee_perfomance_weekly can be considered as lower levels of granularity. The granularity is the lowest level of information stored in the fact table. The depth of the data level is known as granularity. In the date dimension, the level could be the year, month, quarter, period, week, and day of granularity. The process consists of the following two steps: Determining the dimensions that are to be included. Determining the location to find the hierarchy of each dimension of the information The above factors of determination will be re-sent as per the requirements.
```
29. What are the different types of SCDs used in Data Warehousing?
```
SCDs (slowly changing dimensions) are the dimensions in which the data changes slowly, rather than changing regularly on a time basis. Three types of SCDs are used in Data Warehousing: SCD1: It is a record that is used to replace the original record even when there is only one record existing in the database. The current data will be replaced and the new data will take its place. SCD2: It is the new record file that is added to the dimension table. This record exists in the database with the current data and the previous data that is stored in the history. SCD3: This uses the original data that is modified to the new data. This consists of two records: one record that exists in the database and another record that will replace the old database record with the new information.
```
30. What is the difference between DELETE, TRUNCATE and DROP commands?
```
DELETE command is used to remove rows from the table, and the WHERE clause can be used for a conditional set of parameters. Commit and Rollback can be performed after the delete statement. TRUNCATE removes all rows from the table. The truncate operation cannot be rolled back. DROP deletes the table object.
```
31. What is Self-Join?
```
Self-join is set to be a query used to compare to itself. This is used to compare values in a column with other values in the same column in the same table.
```
32. What is Cross-Join?
```
Cross join defines as a Cartesian product where the number of rows in the first table is multiplied by the number of rows in the second table. If suppose, the WHERE clause is used in cross join then the query will work like an INNER JOIN.
```
33. What are the differences between OLTP and OLAP?
```
OLTP stands for Online Transaction Processing, is a class of software applications capable of supporting transaction-oriented programs. An important attribute of an OLTP system is its ability to maintain concurrency. OLTP systems often follow a decentralized architecture to avoid single points of failure. These systems are generally designed for a large audience of end-users who conduct short transactions. Queries involved in such databases are generally simple, need fast response times, and return relatively few records. A number of transactions per second act as an effective measure for such systems.

OLAP stands for Online Analytical Processing, a class of software programs that are characterized by the relatively low frequency of online transactions. Queries are often too complex and involve a bunch of aggregations. For OLAP systems, the effectiveness measure relies highly on response time. Such systems are widely used for data mining or maintaining aggregated, historical data, usually in multi-dimensional schemas.
```
34. What is MPP (Massive Parallel Processing)?
```
Is a type of Data Warehouse architecture where the Control node runs the MPP engine which optimizes queries for parallel processing and then passes operations to Compute nodes to do their work in parallel. The Compute nodes store all user data in storage, which is separate from computing, and run the parallel queries.
```
35. What is a DWU?
```
DWU stands for Data Warehouse Units. They are used to measure performance. More DWUs means more performance (and higher costs)
```
36. What is the distribution option for a table in a MPP DW?
```
This concept varies from provider to provider but in general, we have three types of distributions:
1. ROUND ROBIN or HEAP: A round-robin distributed table distributes table rows evenly across all distributions. The assignment of rows to distributions is random.
2. HASH DISTRIBUTED: A hash-distributed table distributes table rows across the Compute nodes by using a deterministic hash function to assign each row to one distribution.
3. REPLICATED: Replicated tables are replicated across every node i.e. every compute node has a copy of all the rows of the replicated table.
```
37. What is the difference between a data warehouse and a data mart?
```
A data warehouse is a set of data isolated from operational systems. This helps an organization deal with its decision-making process. A data mart is a subset of a data warehouse that is geared to a particular business line. Data marts provide the stock of condensed data collected in the organization for research on a particular field or entity. A data warehouse typically has a size greater than 100 GB, while the size of a data mart is generally less than 100 GB. Due to the disparity in scope, the design and utility of data marts are comparatively simpler.
```
38. Explain the ETL cycle’s 3-layer architecture.
```
The staging layer, the data integration layer, and the access layer are the three layers that are involved in an ETL cycle. Staging layer: It is used to store the data extracted from various data structures of the source. Data integration layer: Data from the staging layer is transformed and transferred to the database using the integration layer. The data is arranged into hierarchical groups (often referred to as dimensions), facts, and aggregates. In a DW system, the combination of facts and dimensions tables is called a schema. Access layer: For analytical reporting, end-users use the access layer to retrieve the data.
```
39. List all the resources you will check to optimize a query
```
Check my previous post here. Bear in mind there more resources to know in MPP Data Warehouses.
```
40. What is the difference between a Heap table and a Clustered table?
```
A Heap table is a table in which, the data rows are not stored in any particular order within each data page. In addition, there is no particular order to control the data page sequence, that is not linked in a linked list. This is due to the fact that the heap table contains no clustered index. A clustered table is a table that has a predefined clustered index on one column or multiple columns of the table that defines the storing order of the rows within the data pages and the order of the pages within the table, based on the clustered index key.
```
41. Why it is not recommended to create indexes on small tables? (SQL server type of question but the same concept applies to MPP)
```
It takes the SQL Server Engine less time to scan the underlying table than to traverse the index when searching for specific data. In this case, the index will not be used but it will still negatively affect the performance of data modification operations, as it will be always adjusted when modifying the underlying table’s data.
```
42. How many Clustered indexes can be created on a table and why?
```
SQL Server allows us to create only one Clustered index per table, as the data can be sorted in the table using only one order criteria.
```
43. Why is an index described as a double-edged sword? What is the index trade-off?
```
A well-designed index will enhance the performance of your system and speed up the data retrieval process. On the other hand, a badly-designed index will cause performance degradation in your system and will cost you extra disk space, and delay the data insertion and modification operations. It is better always to test the performance of the system before and after adding the index to the development environment, before adding it to the production environment.
```
44. Which type of indexes are used to maintain the data integrity of the columns on which it is created?
```
Unique Indexes, by ensuring that there are no duplicate values in the index key, and the table rows, on which that index is created.
```
45. What is referential integrity?
```
Every foreign key (the child) must have a parent's primary key. FK with no parents are orphans, this must be avoided during the ETL process.
```
46. What is a relationship and how many are?
```
A database Relationship is defined as the connection between the tables in a database.
There are various data-basing relationships, and they are as follows:
1. One to One Relationship.
2. One to Many Relationship.
3. Many to One Relationship.
4. Self-Referencing Relationship.
```
