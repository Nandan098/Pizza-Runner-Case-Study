<h1> Pizza Runner — End-to-End SQL Analytics Case Study</h1>

<h2> Project Overview</h2>
<p>
  This project simulates a real-world food delivery business and demonstrates my ability to clean, model, and analyze data using SQL. 
  I worked with messy raw datasets and transformed them into analysis-ready tables to answer key business questions around revenue, 
  customer behavior, delivery performance, and operational efficiency.
</p>

<h2> Objectives</h2>
<ul>
  <li>Clean and transform raw order & delivery data</li>
  <li>Normalize multi-value fields (extras, exclusions, toppings)</li>
  <li>Answer business questions using analytical SQL</li>
  <li>Evaluate profitability and runner performance</li>
  <li>Extract customer and ingredient insights</li>
</ul>

<h2>Dataset Description</h2>
<p><strong>Tables Used:</strong></p>
<ul>
  <li>customer_orders</li>
  <li>runner_orders</li>
  <li>pizza_names</li>
  <li>pizza_recipes</li>
  <li>pizza_toppings</li>
</ul>

<p><strong>Data Cleaning Performed:</strong></p>
<ul>
  <li>Converted string 'null' to NULL</li>
  <li>Extracted numeric values from duration & distance</li>
  <li>Split multi-value columns using JSON_TABLE</li>
  <li>Removed duplicate records</li>
</ul>

<h2> Data Cleaning & Transformation</h2>
<p>Key techniques used:</p>
<ul>
  <li>NULLIF()</li>
  <li>REGEXP_REPLACE()</li>
  <li>CAST() / CONVERT()</li>
  <li>JSON_TABLE()</li>
  <li>CTEs and subqueries</li>
</ul>

<h2> Business Questions Explored</h2>
<ul>
  <li>Most popular pizzas and ingredients</li>
  <li>Order volume by day & hour</li>
  <li>Runner success and cancellation rates</li>
  <li>Delivery speed and distance analysis</li>
  <li>Revenue and profit after runner costs</li>
  <li>Ingredient demand and usage forecasting</li>
  <li>Customer customization behavior</li>
</ul>

<h2>Key Insights</h2>
<ul>
  <li>Cheese was among the most excluded toppings.</li>
  <li>Runner 1 had the highest delivery success rate.</li>
  <li>Peak ordering time occurred during evenings.</li>
  <li>Profitability decreases significantly with long-distance deliveries.</li>
</ul>

<h2> Advanced SQL Concepts Used</h2>
<ul>
  <li>CTEs</li>
  <li>JSON_TABLE</li>
  <li>Conditional aggregation</li>
  <li>Window functions</li>
  <li>JOINs</li>
  <li>Date & time functions</li>
</ul>

<h2> Sample Query</h2>
<pre>
<code>
SELECT runner_id,
       ROUND(AVG(duration_min),2) AS avg_delivery_time
FROM runner_orders_cleaned
WHERE cancellation IS NULL
GROUP BY runner_id;
</code>
</pre>

<h2>Profitability Model</h2>
<ul>
  <li>Meat Lovers: $12</li>
  <li>Vegetarian: $10</li>
  <li>Extras: $0</li>
  <li>Runner Pay: $0.30 per km</li>
</ul>


<h2> How to Run</h2>
<ol>
  <li>Import raw data into MySQL</li>
  <li>Execute cleaning scripts</li>
  <li>Run analysis queries</li>
  <li>Review insights</li>
</ol>

<h2> Limitations & Future Enhancements</h2>
<ul>
  <li>Add pricing for extras</li>
  <li>Build visual dashboards (Power BI / Tableau)</li>
  <li>Add runner feedback and ratings</li>
</ul>

<h2>Tech Stack</h2>
<ul>
  <li>MySQL 8</li>
  <li>Advanced SQL</li>
  <li>Git & GitHub</li>
</ul>

<h2>Credits</h2>
<p>
  Dataset inspired by the 
  <strong>8 Week SQL Challenge — Pizza Runner</strong>.
</p>
