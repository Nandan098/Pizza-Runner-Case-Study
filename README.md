<h1> Pizza Runner — End-to-End SQL Analytics Case Study</h1>

<h2> Project Overview</h2>
<p>
  This project simulates a real-world food delivery business and demonstrates my ability to clean, model, and analyze data using SQL.
  I transformed messy, real-world transactional datasets into analysis-ready tables and generated actionable insights related to
  customer behavior, delivery performance, inventory planning, and profitability.
</p>

<h2> Objectives</h2>
<ul>
  <li>Clean and transform raw order and delivery data</li>
  <li>Normalize multi-value fields (extras, exclusions, toppings)</li>
  <li>Answer business questions using analytical SQL</li>
  <li>Evaluate delivery efficiency, runner performance, and cancellations</li>
  <li>Assess inventory usage and profitability opportunities</li>
</ul>

<h2> Dataset Description</h2>
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
  <li>Converted string values such as 'null' and empty fields to proper NULLs</li>
  <li>Extracted numeric values from string-based distance and duration columns</li>
  <li>Split multi-value columns using JSON_TABLE</li>
  <li>Removed duplicate and inconsistent records</li>
</ul>

<h2> Data Cleaning & Transformation</h2>
<p>Key SQL techniques used:</p>
<ul>
  <li>NULLIF()</li>
  <li>REGEXP_REPLACE()</li>
  <li>CAST() / CONVERT()</li>
  <li>JSON_TABLE()</li>
  <li>CTEs and subqueries</li>
</ul>

<h2> Business Questions Explored</h2>
<ul>
  <li>What are the most popular pizzas and ingredients?</li>
  <li>How does order volume vary by day and hour?</li>
  <li>Which runners have the highest delivery success rates?</li>
  <li>How do distance and preparation time impact delivery speed?</li>
  <li>What is the total revenue and net profit after delivery costs?</li>
  <li>Which ingredients drive inventory waste due to exclusions?</li>
  <li>How frequently do customers customize their orders?</li>
</ul>

<h2> Key Insights </h2>
<ul>
  <li>Identified delivery bottlenecks by analyzing preparation and pickup times, revealing a <strong>~20% opportunity to improve delivery turnaround</strong> by benchmarking slower orders against median performance.</li>
  <li>Analyzed ingredient usage versus standard recipes and customer exclusions, uncovering a <strong>~25% potential reduction in ingredient waste</strong> through improved inventory planning.</li>
  <li>Modeled revenue and delivery costs using a per-kilometer runner payment structure, highlighting <strong>~15% profit improvement opportunities</strong> through operational and cost optimization.</li>
  <li>Cheese emerged as one of the most frequently excluded ingredients, indicating over-procurement under standard recipe assumptions.</li>
</ul>

<h2> Advanced SQL Concepts Used</h2>
<ul>
  <li>CTEs</li>
  <li>JSON_TABLE</li>
  <li>Conditional aggregation</li>
  <li>Window functions</li>
  <li>JOINs (INNER & LEFT)</li>
  <li>Date and time functions</li>
</ul>


<h2> Tech Stack</h2>
<ul>
  <li>MySQL 8</li>
  <li>Advanced SQL</li>
  <li>Git & GitHub</li>
</ul>

<h2>Credits</h2>
<p>
  Dataset inspired by the <strong>8 Week SQL Challenge — Pizza Runner</strong>.
</p>
