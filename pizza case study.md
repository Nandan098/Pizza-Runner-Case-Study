### Pizza Case Study

1.	Create a DATABASE: pizza_runner
### TABLES

```sql
create database pizza_runner;
use pizza_runner;
```

####  runners
| COLUMN NAME        | DATA TYPE | REMARKS |
|--------------------|----------|---------|
| runner_id          | INT      | Primary key |
| registration_date  | DATE     | Runner registration date |

```sql
CREATE TABLE runners (
  runner_id INT,
  registration_date DATE
);

INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
  
select * from runners;
```

#### CUSTOMER_ORDERS 
| COLUMN NAME   | DATA TYPE    | REMARKS |
|---------------|-------------|---------|
| order_id      | INT         | Order identifier |
| customer_id   | INT         | Customer identifier |
| pizza_id      | INT         | FK → pizza_names.pizza_id |
| exclusions    | VARCHAR(10) | Excluded toppings |
| extras        | VARCHAR(10) | Extra toppings |
| order_time    | TIMESTAMP   | Order time |

```sql
CREATE TABLE customer_orders (
  order_id INT,
  customer_id INT,
  pizza_id INT,
  exclusions VARCHAR(10),
  extras VARCHAR(10),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
select * from customer_orders;

-- Apply a tranformation to the customer_orders table

CREATE VIEW customer_orders_cleaned AS
SELECT
  order_id,
  customer_id,
  pizza_id,
  NULLIF(NULLIF(exclusions, ''), 'null') AS exclusions,
  NULLIF(NULLIF(extras, ''), 'null') AS extras,
  order_time
FROM customer_orders;

create view customer_orders_cleaned1 as
select distinct * from customer_orders_cleaned;

select * from customer_orders_cleaned;
```


#### RUNNER_ORDERS 
| COLUMN NAME   | DATA TYPE     | REMARKS |
|---------------|--------------|---------|
| order_id      | INT          | FK → customer_orders.order_id |
| runner_id     | INT          | FK → runners.runner_id |
| pickup_time   | VARCHAR(20)  | Pickup time |
| distance      | VARCHAR(7)   | Distance traveled |
| duration      | VARCHAR(10)  | Delivery duration |
| cancellation  | VARCHAR(23)  | Cancellation reason |

```sql
CREATE TABLE runner_orders (
  order_id INT,
  runner_id INT,
  pickup_time VARCHAR(20),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

select * from runner_orders;

-- Apply a tranformation to the runner_orders table

CREATE VIEW runner_orders_cleaned AS
SELECT
  order_id,
  runner_id,
  CASE 
    WHEN pickup_time IS NULL 
         OR pickup_time IN ('', 'null') THEN NULL
    ELSE STR_TO_DATE(pickup_time, '%Y-%m-%d %H:%i:%s')
  END AS pickup_time,
  CASE 
    WHEN distance IS NULL 
         OR distance IN ('', 'null') THEN NULL
    ELSE
      CAST(
        REPLACE(
          REPLACE(LOWER(distance), 'km', ''),  -- 
          ' ', ''                              
        ) AS DECIMAL(5,2)
      )
  END AS distance_km,
  CASE 
    WHEN duration IS NULL 
         OR duration IN ('', 'null') THEN NULL
    ELSE
      CAST(
        REGEXP_REPLACE(duration, '[^0-9]', '') AS UNSIGNED
      )
  END AS duration_min,
  CASE 
    WHEN cancellation IS NULL 
         OR cancellation IN ('', 'null', '') THEN NULL
    ELSE cancellation
  END AS cancellation

FROM runner_orders;

select * from runner_orders_cleaned;
```


#### PIZZA_NAMES 
| COLUMN NAME | DATA TYPE    | REMARKS |
|-------------|-------------|---------|
| pizza_id    | INT         | Primary key |
| pizza_name  | VARCHAR(20) | Pizza name |

```sql
CREATE TABLE pizza_names (
  pizza_id INT,
  pizza_name varchar(20)
);

INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

select * from pizza_names;
```


#### PIZZA_RECIPES 
| COLUMN NAME | DATA TYPE | REMARKS |
|-------------|----------|---------|
| pizza_id    | INT      | FK → pizza_names.pizza_id |
| toppings    | TEXT     | Comma-separated topping IDs |

```sql
CREATE TABLE pizza_recipes (
  pizza_id INT,
  toppings text
  );
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');
  
-- Apply transformation to the pizza_recipes

CREATE VIEW pizza_recipes_cleaned AS
SELECT
  pizza_id,
  CAST(TRIM(jt.topping_id) AS UNSIGNED) AS topping_id
FROM pizza_recipes
JOIN JSON_TABLE(
  CONCAT(
    '["',
    REPLACE(toppings, ', ', '","'),
    '"]'
  ),
  '$[*]' COLUMNS (
    topping_id VARCHAR(5) PATH '$'
  )
) AS jt;

select * from pizza_recipes_cleaned;
```

 #### PIZZA_TOPPINGS 
| COLUMN NAME  | DATA TYPE | REMARKS |
|--------------|----------|---------|
| topping_id   | INT      | Primary key |
| topping_name | TEXT     | Topping name |

```sql
CREATE TABLE pizza_toppings (
  topping_id INT,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  ```

  ```sql
  select * from runners;
  select * from customer_orders_cleaned1;
  select * from runner_orders_cleaned;
  select * from pizza_names;
  select * from pizza_recipes_cleaned;
  select * from pizza_toppings;
```
    
                                                                      -- Questions
                                                           
                                                        --   A. Pizza Metrics
-- 1. How many pizzas were ordered?
```sql
      select count(pizza_id) as total_pizza_ordered
      from customer_orders_cleaned1;
 ```
      
-- 2. How many unique customer orders were made?
   ```sql
      select count(distinct customer_id) as total_customer  
      from customer_orders_cleaned1;
   ```
      
-- 3. How many successful orders were delivered by each runner?
```sql
      select runner_id,count(*) as Completed_orders_by_runner 
      from runner_orders_cleaned
	    where cancellation is null
      group by runner_id;
```  
-- 4. How many of each type of pizza was delivered?
  ```sql 
      select p.pizza_name,count(c.pizza_id) as total_pizza 
      from customer_orders_cleaned1 as c
      join
      pizza_names as p
      on c.pizza_id=p.pizza_id
      group by p.pizza_name;
  ```    
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
  ```sql   
     select c.customer_id,
       sum(case when p.pizza_name = 'Vegetarian' then 1 else 0 end) as vegetarian,
       sum(case when p.pizza_name = 'Meatlovers' then 1 else 0 end) as meatlovers
     from customer_orders_cleaned1 as c
     join pizza_names as p
     on c.pizza_id = p.pizza_id
     group by c.customer_id;
```
-- 6. What was the maximum number of pizzas delivered in a single order?
  ```sql
      select customer_id,count(pizza_id) as no_of_pizzas_orders
      from customer_orders_cleaned1
      group by customer_id
      order by count(pizza_id) desc;
   ```

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
  ```sql  
      select c.customer_id,
                       sum(case when c.exclusions is not null or c.extras then 1 else 0 end ) as pizza_with_changes,
                       sum(case when c.exclusions is null and c.extras is null then 1 else 0 end) as pizza_with_no_changes
	    from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      where r.cancellation is null
      group by customer_id
      order by customer_id;
```
	
-- 8. How many pizzas were delivered that had both exclusions and extras?
  ```sql    
      select count(*) as pizzas_with_exclusions_and_extras
	    from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      where  c.exclusions is not null and c.extras is not null;
```
 -- 9. What was the total volume of pizzas ordered for each hour of the day?
   ```sql   
       select hour(order_time) as Order_hour,count(*) as pizza_count
       from customer_orders_cleaned1
       group by hour(order_time);
   ```   
-- 10. What was the volume of orders for each day of the week?
	
       select dayname(order_time) as order_day,count(*) as pizzas_count
       from customer_orders_cleaned1
       group by order_day
       order by field(order_day,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
   ```    
