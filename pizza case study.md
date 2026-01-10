<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/288c7c35-4b70-4366-8cd9-7d46e18b2fff" />#### Pizza Case Study

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
    
####   Questions
####  A. Pizza Metrics
																
-- 1. How many pizzas were ordered?
```sql
      select count(pizza_id) as total_pizza_ordered
      from customer_orders_cleaned1;
 ```
<img width="188" height="86" alt="1" src="https://github.com/user-attachments/assets/9c76a55c-83c8-400d-a007-72af90975638" />
  
-- 2. How many unique customer orders were made?
   ```sql
      select count(distinct customer_id) as total_customer  
      from customer_orders_cleaned1;
   ```

<img width="165" height="94" alt="2" src="https://github.com/user-attachments/assets/a21bb712-f897-4877-9a43-b855c2716453" />
	  
-- 3. How many successful orders were delivered by each runner?
```sql
      select runner_id,count(*) as Completed_orders_by_runner 
      from runner_orders_cleaned
	    where cancellation is null
      group by runner_id;
```

<img width="330" height="115" alt="3" src="https://github.com/user-attachments/assets/9c84163f-a24c-47a6-b94e-fa1b7ea6c175" />

-- 4. How many of each type of pizza was delivered?
  ```sql 
      select p.pizza_name,count(c.pizza_id) as total_pizza 
      from customer_orders_cleaned1 as c
      join
      pizza_names as p
      on c.pizza_id=p.pizza_id
      group by p.pizza_name;
  ```

<img width="221" height="109" alt="4" src="https://github.com/user-attachments/assets/3cf77b9f-c194-4c4b-b80f-496d8e6ff67f" />

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

<img width="315" height="169" alt="5" src="https://github.com/user-attachments/assets/fc480f07-78c5-4467-a9c5-816f927c75f3" />


-- 6. What was the maximum number of pizzas delivered in a single order?
  ```sql
      select customer_id,count(pizza_id) as no_of_pizzas_orders
      from customer_orders_cleaned1
      group by customer_id
      order by count(pizza_id) desc;
   ```

<img width="286" height="157" alt="6" src="https://github.com/user-attachments/assets/4f74a8a9-fb6c-4a4f-8a38-0c1262300897" />

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

<img width="436" height="169" alt="7" src="https://github.com/user-attachments/assets/6559aa96-2b5b-4706-8a12-7604fdb1aa9e" />

-- 8. How many pizzas were delivered that had both exclusions and extras?
  ```sql    
      select count(*) as pizzas_with_exclusions_and_extras
	    from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      where  c.exclusions is not null and c.extras is not null;
```

<img width="288" height="61" alt="8" src="https://github.com/user-attachments/assets/bc5f7024-2d45-490a-b9dd-5011d5617dbc" />

 -- 9. What was the total volume of pizzas ordered for each hour of the day?
   ```sql   
       select hour(order_time) as Order_hour,count(*) as pizza_count
       from customer_orders_cleaned1
       group by hour(order_time);
   ```

<img width="234" height="165" alt="9" src="https://github.com/user-attachments/assets/499afda9-a499-4719-9af0-33b39a4d2c50" />

-- 10. What was the volume of orders for each day of the week?
```sql	
       select dayname(order_time) as order_day,count(*) as pizzas_count
       from customer_orders_cleaned1
       group by order_day
       order by field(order_day,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
   ```

<img width="244" height="134" alt="10" src="https://github.com/user-attachments/assets/6e4b3157-97a3-40e1-8d4b-30e863fdc9cb" />


####  B. Runner and Customer Experience
                                         
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```sql
        select
             date_add('2021-01-01',
              interval floor(datediff(registration_date, '2021-01-01') / 7) * 7 day
              ) as week_start,
        count(*) as runners_signed_up
        from runners
	    group by week_start
        order by week_start;
  ```
<img width="282" height="106" alt="1" src="https://github.com/user-attachments/assets/f0e05b69-283b-4163-a52c-6f13bf72cd6d" />



-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
 ```sql   
	  select r.runner_id,round(avg(timestampdiff(minute,c.order_time,r.pickup_time)),2) as avg_time_to_pickup_the_order
      from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      group by r.runner_id;
   ```

<img width="340" height="129" alt="2" src="https://github.com/user-attachments/assets/9fc0908b-449d-408d-8f26-632b9497d26e" />

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
  ```sql   
	 select pizza_count, round(avg(prep_time_minutes),2) as avg_prep_time
      from (
             select c.order_id,count(*) as pizza_count,
			 timestampdiff(minute, min(c.order_time), r.pickup_time) as prep_time_minutes
			 from customer_orders_cleaned1 c
             join runner_orders_cleaned r
             on c.order_id = r.order_id
             where r.pickup_time IS NOT NULL
             group by c.order_id, r.pickup_time
       ) as t
	   group by pizza_count
       order by pizza_count;
```
<img width="263" height="117" alt="3" src="https://github.com/user-attachments/assets/9db0bb73-71fe-4a6c-be12-6398f0487413" />

-- 4. What was the average distance travelled for each customer?
  ```sql   
	  select c.customer_id,round(avg(r.distance_km),2) as avg_distance
      from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      and r.cancellation is null
      and r.distance_km is not null
      group by c.customer_id;
```
<img width="244" height="180" alt="4" src="https://github.com/user-attachments/assets/49b9e09c-19cb-4afa-8dcc-607883603fc4" />

 
-- 5. What was the difference between the longest and shortest delivery times for all orders ?
  ```sql   
	  select MIN(delivery_time) AS shortest_delivery_min,MAX(delivery_time) AS longest_delivery_min,max(delivery_time)-min(t.delivery_time) as diff_longest_shotest_time_min 
	  from (select c.order_id,round(timestampdiff(minute,min(c.order_time),min(r.pickup_time)),2) as delivery_time
      from customer_orders_cleaned1 as c
      join
	  runner_orders_cleaned as r
      on c.order_id=r.order_id
      and r.pickup_time is not null
      group by c.order_id) as t;
```

<img width="564" height="102" alt="5" src="https://github.com/user-attachments/assets/17b31259-b08f-4b17-be09-0033cde01098" />

 -- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
  ```sql  
	  select runner_id,order_id,round(avg(distance_km/duration_min*60.0),2) as avg_speed_km_per_hour
      from runner_orders_cleaned
      where distance_km is not null and duration_min is not null
      group by runner_id,order_id
      order by runner_id;
```

<img width="376" height="230" alt="6" src="https://github.com/user-attachments/assets/8eb6aa5e-6a67-4405-a4d3-23cceac6288f" />

 -- 7. What is the successful delivery percentage for each runner?
   ```sql   
	   select runner_id,round(sum(case when cancellation is null then 1 else 0 end)*100.0/count(*),2) as successful_delivery_percentage
       from runner_orders_cleaned
       group by runner_id;
   ```

<img width="344" height="142" alt="7" src="https://github.com/user-attachments/assets/ec8567eb-b234-4e58-9607-d69b552f4f6f" />


#### C. Ingredient Optimisation
                                                     
             
 -- 1. What are the standard ingredients for each pizza ?
   ```sql  
	   select p.pizza_name,group_concat(pt.topping_name order by pt.topping_name separator ',') as standard_ingredients
       from pizza_names as p
       join
       pizza_recipes_cleaned as pr
       join
       pizza_toppings as pt
       on p.pizza_id=pr.pizza_id
       and pr.topping_id=pt.topping_id
       group by p.pizza_name
       order by p.pizza_name;
```
<img width="461" height="106" alt="1" src="https://github.com/user-attachments/assets/be8a2a2e-be83-4be2-90f3-3f66b7fc9abf" />

-- 2. What was the most commonly added extra?
```sql	
	  select pt.topping_name, count(*) as extra_count
      from customer_orders_cleaned1 c
      join json_table(
        concat(
            '["',
          replace(c.extras, ', ', '","'),
            '"]'
        ),
        '$[*]' columns (
            extra_id varchar(5) path '$'
        )
      ) as jt
      join pizza_toppings as pt
	  on pt.topping_id = cast(jt.extra_id as unsigned)
	  where c.extras is not null
      and c.extras is not null
	  group by pt.topping_name
      order by extra_count desc;
```

<img width="252" height="134" alt="2" src="https://github.com/user-attachments/assets/12d244b6-8012-4d16-94ef-787ce71e9b19" />

 -- 3. What was the most common exclusion?
 ```sql   
	   select pt.topping_name, count(*) AS exclusion_count
       from customer_orders_cleaned1 as c
       join json_table (
       concat(
        '["',
        replace(c.exclusions, ', ', '","'),
        '"]'
        ),
       '$[*]' columns (
        exclusion_id varchar(10) path '$'
        )
        ) as jt
        on c.exclusions is not null
		join pizza_toppings as pt
		on pt.topping_id = CAST(jt.exclusion_id as unsigned)
		group by pt.topping_name
        order by exclusion_count desc
		limit 1;
```

<img width="261" height="102" alt="3" src="https://github.com/user-attachments/assets/944ce2f2-2e6e-4bca-a5a6-a0ee437a6b79" />


-- 4. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
```sql
      select jt.topping_id, pt.topping_name, count(*) as count
      from customer_orders_cleaned as c
      join json_table(
      concat('[',
           replace(concat_ws(',',exclusions,extras),' ',''),
           ']'),
	  '$[*]' columns(
       topping_id int path '$')
	) as jt
     join
      pizza_toppings as pt
      on pt.topping_id=jt.topping_id
	join 
    runner_orders_cleaned as r
    on r.order_id=c.order_id
    where r.cancellation is null
    group by jt.topping_id,pt.topping_name
    order by count desc;
```

<img width="296" height="154" alt="4" src="https://github.com/user-attachments/assets/81a3a822-83fc-4674-b873-962a62e7c355" />


#### D. Pricing and Ratings
	
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
  ```sql   
	  select
  sum(
    case
      when p.pizza_name = 'Meatlovers' then 12
      when p.pizza_name = 'Vegetarian' then 10
    end
  ) as total_earned
from customer_orders_cleaned1 as c
join pizza_names as p
  on c.pizza_id = p.pizza_id;
  ```
<img width="198" height="71" alt="1" src="https://github.com/user-attachments/assets/ed629050-d972-47e2-93db-114ad1d5fbb1" />



-- 2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra.
      -- per order: 1 if cheese in extras, else 0
 ```sql   
     select
  p.pizza_name,
  count(*) as total_pizzas,
  sum(
    case
      when p.pizza_name = 'Meatlovers' then 12
      when p.pizza_name = 'Vegetarian' then 10
    end
  ) as pizza_revenue,
  sum(
    case
      when c.extras is null or c.extras = '' then 0
      else length(c.extras) - length(replace(c.extras, ',', '')) + 1
    end
  ) as extras_revenue
from customer_orders_cleaned1 c
join pizza_names p
  on c.pizza_id = p.pizza_id
group by p.pizza_name;
```

<img width="461" height="96" alt="2" src="https://github.com/user-attachments/assets/27dd1b78-08b9-4769-a76d-a00432a4741d" />

 -- 3. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
```sql
   select
  r.runner_id,
  sum(case when p.pizza_name = 'Meatlovers' then 12
           when p.pizza_name = 'Vegetarian' then 10 end) as pizza_revenue,
  round(sum(r.distance_km) * 0.3, 2) as runner_payment,
  round(
    sum(case when p.pizza_name = 'Meatlovers' then 12
             when p.pizza_name = 'Vegetarian' then 10 end)
    - sum(r.distance_km) * 0.3,
    2
  ) as money_left_over
from customer_orders_cleaned1 c
join runner_orders_cleaned r
  on c.order_id = r.order_id
join pizza_names p
  on c.pizza_id = p.pizza_id
where r.cancellation is null
group by r.runner_id
order by r.runner_id;

```
<img width="486" height="106" alt="3" src="https://github.com/user-attachments/assets/20399a5d-7931-4c1a-8b70-be7ef7acda35" />




