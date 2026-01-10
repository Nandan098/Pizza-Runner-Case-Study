create database pizza_runner;
use pizza_runner;

-- Create Table-1  runners

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

-- Create Table-2 customer_orders

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

-- Table-3 runner_orders

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

--  Table - 4   pizza_names

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

-- Table -5 pizza_recipes

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

-- Table - 6 pizza_toppings

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
  
  
  select * from runners;
  select * from customer_orders_cleaned1;
  select * from runner_orders_cleaned;
  select * from pizza_names;
  select * from pizza_recipes_cleaned;
  select * from pizza_toppings;

    
                                                                      -- Questions
                                                           
                                                        --   A. Pizza Metrics
-- 1. How many pizzas were ordered?
	  select count(pizza_id) as total_pizza_ordered
      from customer_orders_cleaned1;
      
-- 2. How many unique customer orders were made?
      select distinct customer_id  
      from customer_orders_cleaned1;
      
-- 3. How many successful orders were delivered by each runner?
      select runner_id,count(*) as Completed_orders 
      from runner_orders_cleaned
	  where cancellation is null
      group by runner_id;
      
-- 4. How many of each type of pizza was delivered?
      select p.pizza_name,count(c.pizza_id) as total_pizza 
      from customer_orders_cleaned1 as c
      join
      pizza_names as p
      on c.pizza_id=p.pizza_id
      group by p.pizza_name;
      
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
      SELECT c.customer_id,
                         SUM(CASE WHEN p.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS Vegetarian,
                         SUM(CASE WHEN p.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS Meatlovers
      FROM customer_orders_cleaned1 AS c
      JOIN pizza_names AS p
      ON c.pizza_id = p.pizza_id
	  GROUP BY c.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
      select customer_id,count(pizza_id) as no_of_pizzas_orderes
      from customer_orders_cleaned1
      group by customer_id
      order by count(pizza_id) desc;
      
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
      select c.customer_id,
                       sum(case when c.exclusions is not null or c.extras then 1 else 0 end ) as pizzas_with_changes,
                       sum(case when c.exclusions is null and c.extras is null then 1 else 0 end) as pizzas_with_no_changes
	  from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      where r.cancellation is null
      group by customer_id
      order by customer_id;
	
-- 8. How many pizzas were delivered that had both exclusions and extras?
      select count(*) as pizzas_With_exclusions_and_extras
	  from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      where  c.exclusions is not null and c.extras is not null;

 -- 9. What was the total volume of pizzas ordered for each hour of the day?
       select hour(order_time) as Order_hour,count(*) as pizzas_count
       from customer_orders_cleaned1
       group by hour(order_time);
       
-- 10. What was the volume of orders for each day of the week?
	   select dayname(order_time) as order_day,count(*) as pizzas_count
       from customer_orders_cleaned1
       group by order_day
       order by field(order_day,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');


  select * from runners;
  select * from customer_orders_cleaned1;
  select * from runner_orders_cleaned;
  select * from pizza_names;
  select * from pizza_recipes_cleaned;
  select * from pizza_toppings;

                                       --  B. Runner and Customer Experience
                                         
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
      SELECT
             DATE_ADD('2021-01-01',
              INTERVAL FLOOR(DATEDIFF(registration_date, '2021-01-01') / 7) * 7 DAY
              ) AS week_start,

              COUNT(*) AS runners_signed_up
        FROM runners
	    GROUP BY week_start
        ORDER BY week_start;
  
-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
      select r.runner_id,round(avg(timestampdiff(minute,c.order_time,r.pickup_time)),2) as avg_time_to_pickup_the_order
      from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      group by r.runner_id;
      
-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
      select pizza_count,avg(prep_time_minutes) as avg_prep_time
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

-- 4. What was the average distance travelled for each customer?
      select c.customer_id,round(avg(r.distance_km),2) as avg_distance_per_customer
      from customer_orders_cleaned1 as c
      join
      runner_orders_cleaned as r
      on c.order_id=r.order_id
      and r.cancellation is null
      and r.distance_km is not null
      group by c.customer_id;

 
-- 5. What was the difference between the longest and shortest delivery times for all orders ?
      select MIN(delivery_time) AS shortest_delivery_min,MAX(delivery_time) AS longest_delivery_min,max(delivery_time)-min(t.delivery_time) as diff_longest_shotest_time_min from (select c.order_id,round(timestampdiff(minute,min(c.order_time),min(r.pickup_time)),2) as delivery_time
      from customer_orders_cleaned1 as c
      join
	  runner_orders_cleaned as r
      on c.order_id=r.order_id
      and r.pickup_time is not null
      group by c.order_id) as t;
	
 -- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
      select runner_id,order_id,round(avg(distance_km/duration_min*60.0),2) as avg_speed_km_per_hour
      from runner_orders_cleaned
      where distance_km is not null and duration_min is not null
      group by runner_id,order_id
      order by runner_id;

 -- 7. What is the successful delivery percentage for each runner?
       select runner_id,round(sum(case when cancellation is null then 1 else 0 end)*100.0/count(*),2) as successful_delivery_percentage
       from runner_orders_cleaned
       group by runner_id;

                                                     -- C. Ingredient Optimisation
                                                     
             
 -- 1. What are the standard ingredients for each pizza ?
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
       
-- 2. What was the most commonly added extra?
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
      join pizza_toppings pt
	  on pt.topping_id = cast(jt.extra_id as unsigned)
	  where c.extras is not null
      and c.extras is not null
	  group by pt.topping_name
      order by extra_count desc;



 -- 3. What was the most common exclusion?
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
		join pizza_toppings pt
		on pt.topping_id = CAST(jt.exclusion_id as unsigned)
		group by pt.topping_name
        order by exclusion_count desc
		limit 1;

-- 4. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
      select c.order_id, c.pizza_id, c.extras, c.exclusions
      from customer_orders_cleaned1 c
	  join runner_orders_cleaned r ON c.order_id = r.order_id
	  where r.cancellation IS NULL;
    
      select r.order_id, pr.topping_id, 1 AS qty
	  from runner_orders_cleaned as r
	  join pizza_recipes_cleaned pr ON pr.pizza_id = r.pizza_id;
    
                                            -- D. Pricing and Ratings
	
  
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
      select sum(t.costs) as total_earned from (select p.pizza_name,count(*) as total_orders,
	  case 
          when p.pizza_name='Meatlovers' then count(*)*12
          when p.pizza_name='Vegetarian' then count(*)*10
          end as costs
	  from customer_orders_cleaned1 as c
      join
      pizza_names as p
      on c.pizza_id=p.pizza_id
      group by p.pizza_name) as t;
      
-- 2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra.
      -- per order: 1 if cheese in extras, else 0
       
       with cheese_flag as (
	   select distinct c.order_id,
       1 as cheese_extra
       from customer_orders_cleaned1 c
	   join json_table(
	   concat('["', replace(c.extras, ', ', '","'), '"]'),
       '$[*]' columns (extra_id varchar(10) path '$')
		) jt on c.extras is not null
        where cast(jt.extra_id as unsigned) = 4
        )

        select
		sum(pr.price+ coalesce(e.extras_count,0) * 1+ coalesce(cf.cheese_extra, 0) * 0) as total_revenue
        from customer_orders_cleaned1 o
		join pizza_prices pr on o.pizza_id = pr.pizza_id
        left join (
                  select c.order_id, count(*) as extras_count
                  from customer_orders_cleaned1 c
                  join json_table(
                  concat('["', replace(c.extras, ', ', '","'), '"]'),
				  '$[*]' columns (extra_id varchar(10) path '$')
                  ) jt on c.extras is not null
                  group by c.order_id) as e
				  on o.order_id = e.order_id
        left join cheese_flag cf 
        on o.order_id = cf.order_id;

    
-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
      select t.runner_id,t.count_meatlovers,t.count_vegetarian,(t.count_meatlovers*12) as total_meatlovers_cost,(10*t.count_vegetarian) as total_vegetarian_cost,((t.count_meatlovers*12)+(t.count_vegetarian*10)) as total_cost_for_pizza,round((t.total_distance_travelled*0.3),2) as total_cost_earned_by_runner,round(((t.count_meatlovers*12)+(t.count_vegetarian*10)-(t.total_distance_travelled*0.3)),2) as earned_by_runner from (select r.runner_id,sum(case when p.pizza_name='Meatlovers' then 1 else 0 end) as count_meatlovers,sum(case when p.pizza_name='Vegetarian' then 1 else 0 end) as count_vegetarian
      ,sum(r.distance_km) as total_distance_travelled 
      from customer_orders_cleaned1 as c
      join 
      runner_orders_cleaned as r
      join 
      pizza_names as p
      on
      c.order_id=r.order_id
      and c.pizza_id=p.pizza_id
      and r.cancellation is null
      group by r.runner_id) as t;
