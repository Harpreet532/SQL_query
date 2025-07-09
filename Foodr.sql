 --Calculating Revenue 
SELECT  
  order_id,  
  SUM(meal_price * order_quantity) AS revenue  
FROM meals  
JOIN orders ON meals.meal_id = orders.meal_id  
GROUP BY order_id;

--Calculating Cost 
SELECT  
  meals.meal_id,   
  SUM(meal_cost * stocked_quantity) AS cost_of_stock   
FROM meals  
JOIN stock ON meals.meal_id = stock.meal_id  
GROUP BY meals.meal_id  
ORDER BY cost_of_stock DESC  
LIMIT 5;
