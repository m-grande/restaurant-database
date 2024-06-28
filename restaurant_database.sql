CREATE TABLE restaurant (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255),
  rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5),
  telephone VARCHAR(15),
  hours VARCHAR(255)
);

CREATE TABLE address (
  id SERIAL PRIMARY KEY,
  street_number VARCHAR(10) NOT NULL,
  street_name VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(2) NOT NULL,
  google_map_link VARCHAR(255),
  restaurant_id INTEGER NOT NULL UNIQUE REFERENCES restaurant(id)
);

CREATE TABLE category (
  id CHAR(2) PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255)
);

CREATE TABLE dish (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(255),
  hot_and_spicy BOOLEAN
);

CREATE TABLE categories_dishes (
  category_id CHAR(2) NOT NULL REFERENCES category(id),
  dish_id INTEGER NOT NULL REFERENCES dish(id),
  price DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (category_id, dish_id)
);

CREATE TABLE review (
  id SERIAL PRIMARY KEY,
  rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5),
  description VARCHAR(255),
  date DATE NOT NULL,
  restaurant_id INTEGER NOT NULL REFERENCES restaurant(id)
);

-- Insert values for restaurant

INSERT INTO restaurant (name, description, rating, telephone, hours) VALUES
('Bytes of China', 'Delectable Chinese Cuisine', 3.9, '6175551212', 'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm');

-- Insert values for address

INSERT INTO address (street_number, street_name, city, state, google_map_link, restaurant_id) VALUES
('2020', 'Busy Street', 'Chinatown', 'MA', 'http://bit.ly/BytesOfChina', 1);

-- Insert values for review

INSERT INTO review (rating, description, date, restaurant_id) VALUES
(5.0, 'Would love to host another birthday party at Bytes of China!', '2020-05-22', 1),
(4.5, 'Other than a small mix-up, I would give it a 5.0!', '2020-04-01', 1),
(3.9, 'A reasonable place to eat for lunch, if you are in a rush!', '2020-03-15', 1);

-- Insert values for category

INSERT INTO category (id, name, description) VALUES
('C', 'Chicken', NULL),
('LS', 'Luncheon Specials', 'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice between 11:00 am and 3:00 pm from Monday to Friday.'),
('HS', 'House Specials', NULL);

-- Insert values for dish

INSERT INTO dish (name, description, hot_and_spicy) VALUES
('Chicken with Broccoli', 'Diced chicken stir-fried with succulent broccoli florets', FALSE),
('Sweet and Sour Chicken', 'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers', FALSE),
('Chicken Wings', 'Finger-licking mouth-watering entree to spice up any lunch or dinner', TRUE),
('Beef with Garlic Sauce', 'Sliced beef steak marinated in garlic sauce for that tangy flavor', TRUE),
('Fresh Mushroom with Snow Peapods and Baby Corns', 'Colorful entree perfect for vegetarians and mushroom lovers', FALSE),
('Sesame Chicken', 'Crispy chunks of chicken flavored with savory sesame sauce', FALSE),
('Special Minced Chicken', 'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.', FALSE),
('Hunan Special Half & Half', 'Shredded beef in Peking sauce and shredded chicken in garlic sauce', TRUE);

-- Insert values for categories_dishes

INSERT INTO categories_dishes (category_id, dish_id, price) VALUES
('C', 1, 6.95),
('C', 3, 6.95),
('LS', 1, 8.95),
('LS', 4, 8.95),
('LS', 5, 8.95),
('HS', 6, 15.95),
('HS', 7, 16.95),
('HS', 8, 17.95);

-- Display the restaurant name, its address (street number and name) and telephone number

SELECT restaurant.name AS restaurant,
       address.street_number AS number,
       address.street_name AS street,
       restaurant.telephone AS telephone
FROM restaurant
JOIN address ON restaurant.id = address.restaurant_id;

-- Get the best rating the restaurant ever received.

SELECT rating AS best_rating, description
FROM review
WHERE rating = (SELECT MAX(rating) FROM review);

-- Display dish name, its price and category sorted by the dish name

SELECT category.name AS category,
       dish.name AS dish_name,
       categories_dishes.price AS price
FROM categories_dishes
JOIN dish ON categories_dishes.dish_id = dish.id
JOIN category ON categories_dishes.category_id = category.id
ORDER BY category.name;

-- Display all the spicy dishes, their prices and category

SELECT dish.name AS spicy_dish_name,
       category.name AS category,
       categories_dishes.price AS price
FROM dish
JOIN categories_dishes ON dish.id = categories_dishes.dish_id
JOIN category ON categories_dishes.category_id = category.id
WHERE dish.hot_and_spicy = TRUE
ORDER BY category.name;

-- Find dishes that belong to more than one category

SELECT dish.name AS dish_name, COUNT(categories_dishes.dish_id) AS dish_count
FROM dish
JOIN categories_dishes ON dish.id = categories_dishes.dish_id
GROUP BY dish.name
HAVING COUNT(dish_id) > 1;