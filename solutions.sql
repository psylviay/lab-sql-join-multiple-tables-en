# This file uses the sakila database.

# 1 - Displays the store id, city and country for each store.
SELECT s.store_id,
       ci.city AS city,
       co.country AS country
FROM store AS s
JOIN address AS a
    ON s.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
JOIN country AS co
    ON ci.country_id = co.country_id
ORDER BY s.store_id;

# 2 - Displays how much business, in dollars, each store brought in.
SELECT st.store_id,
       SUM(p.amount) AS total_revenue
FROM payment AS p
JOIN staff AS st
    ON p.staff_id = st.staff_id
GROUP BY st.store_id
ORDER BY st.store_id;

# 3 - Calculates the average running time of films by category.
SELECT c.name AS category,
       ROUND(AVG(f.length), 2) AS avg_running_time
FROM film AS f
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY c.name;

# 4 - Determines which film categories are the longest.
SELECT c.name AS category,
       ROUND(AVG(f.length), 2) AS avg_length
FROM film AS f
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_length DESC;

# 5 - Displays the most frequently rented movies in descending order.
SELECT f.title AS film_title,
       COUNT(r.rental_id) AS rental_count
FROM film AS f
JOIN inventory AS i
    ON f.film_id = i.film_id
JOIN rental AS r
    ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC;

# 6 - Lists the top five genres in gross revenue in descending order.
SELECT c.name AS category,
       ROUND(SUM(p.amount), 2) AS total_revenue
FROM category AS c
JOIN film_category AS fc
    ON c.category_id = fc.category_id
JOIN film AS f
    ON fc.film_id = f.film_id
JOIN inventory AS i
    ON f.film_id = i.film_id
JOIN rental AS r
    ON i.inventory_id = r.inventory_id
JOIN payment AS p
    ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 5;

# 7 - Answers the question: is "Academy Dinosaur" available for rent from Store 1?
SELECT f.title,
       COUNT(*) AS available_copies
FROM film AS f
JOIN inventory AS i 
    ON f.film_id = i.film_id
-- We use a LEFT JOIN so we can detect if a rental does not exist or is returned.
LEFT JOIN rental AS r
    ON i.inventory_id = r.inventory_id
   AND r.return_date IS NULL   -- Only match currently rented items
WHERE f.title = 'Academy Dinosaur'
  AND i.store_id = 1           -- Store 1
  AND r.rental_id IS NULL      -- Means NOT currently rented
GROUP BY f.title;
