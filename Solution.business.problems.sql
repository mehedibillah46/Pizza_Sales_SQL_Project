-- 1. Calculate the total revenue generated from pizza sales.

SELECT round(sum(order_details.Quantity * pizzas.price), 2) AS total_revenue
FROM order_details JOIN pizzas
ON order_details.pizza_Id = pizzas.pizza_id;

-- 2. Identify the highest-priced pizza.

SELECT pizza_types.name, pizzas.price
FROM pizzas JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY price DESC LIMIT 1;

-- 3. Retrieve the total number of orders placed.

SELECT COUNT(Order_id) AS total_number_orders
FROM orders;

-- 4. Identify the most common pizza size ordered.

SELECT pizzas.size, COUNT(order_details.Order_Details_Id) AS order_count

FROM pizzas JOIN order_details
ON pizzas.pizza_id = order_details.pizza_Id
Group BY pizzas.size
ORDER BY order_count DESC;

-- 5. List the top 5 most ordered pizza types along with their quantities.

SELECT pizzas.pizza_type_id , pizza_types.name, SUM(order_details.Quantity) AS most_ordered_pizza
FROM pizzas JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_Id
Group BY pizzas.pizza_type_id, pizza_types.name
ORDER BY most_ordered_pizza DESC LIMIT 5;

-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pizza_types.category, SUM(order_details.quantity) as quantity_pizza_category
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_Id
Group BY pizza_types.category
Order BY quantity_pizza_category DESC;

-- 7. Determine the distribution of orders by hour of the day.

SELECT hour(Order_time), count(order_id) AS Quantity_order_hour
FROM orders
Group By hour(Order_time);

-- 8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT category, count(name) 
FROM pizza_types
Group BY category;

-- 9. Determine the top 3 most ordered pizza types based on revenue.

SELECT pizza_types.name, sum(pizzas.price*order_details.quantity) AS revenue
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_Id = pizzas.pizza_id
GROUp By pizza_types.name
ORDER BY revenue DESC LIMIT 3;

-- 10. Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT round(avg(quantity), 2) FROM
(SELECT orders.Order_Date, SUM(order_details.quantity) AS quantity
From orders JOIN order_details
ON orders.Order_id = order_details.ORder_Id
Group BY orders.Order_Date) AS avg_pizza_everyday

-- 11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT pizza_types.category, round((sum(order_details.quantity*pizzas.price)/(SELECT SUM(order_details.Quantity * pizzas.price) 
            FROM order_details JOIN pizzas 
            ON order_details.pizza_Id = pizzas.pizza_id))*100,2) AS revenue
            
FROM order_details JOIN pizzas
ON order_details.pizza_Id = pizzas.pizza_id
JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
Group BY pizza_types.category
Order by revenue DESC;

-- 12. Analyze the cumulative revenue generated over time.

SELECT order_date, revenue, sum(revenue) OVER (order by order_date) AS cum_revenue
FROM
(SELECT orders.Order_Date, round(sum(order_details.quantity*pizzas.price),2) as revenue
FROM order_details JOIN pizzas
ON order_details.pizza_Id = pizzas.pizza_id
JOIN orders
ON orders.Order_id = order_details.ORder_Id
Group BY orders.Order_Date) AS sales

-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT category, name, revenue, rn 
FROM
(SELECT category, name, revenue, 
RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
FROM
(SELECT pizza_types.category, pizza_types.name, sum(order_details.quantity*pizzas.price) AS revenue
FROM order_details JOIN pizzas
ON order_details.pizza_Id = pizzas.pizza_id
JOIN pizza_types
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category, pizza_types.name) AS a) AS b
where rn <= 3 ; 





