# Restaurant Database Project

This project contains SQL scripts to create and manage a restaurant database. The database includes tables for restaurants, addresses, categories, dishes, and reviews.

## Installation

To set up and run the SQL scripts, follow these steps:

### Prerequisites

- PostgreSQL installed on your machine using Homebrew.
- A command line interface (CLI) to run SQL commands.

### Steps

1. **Install PostgreSQL**

   Install PostgreSQL using Homebrew:

   ```sh
   brew install postgresql

2. **Start PostgreSQL**
    Start the PostgreSQL service:

    ```sh
    brew services start postgresql

3. **Create a New Database**
    Create a new database:
    
    ```sh
    createdb restaurant_db

4. **Connect to Your Database:**
    Connect to your newly created database:

    ```sh
    psql restaurant_db

5. **Run the SQL Script**
    Execute the '**restaurant_database.sql**' script to create the tables and insert sample data:

    ```sh
    psql -d restaurant_db -f restaurant_database.sql

6. **Stop PostgreeSQL**
    To stop the PostgreSQL service:

    ```sh
    brew services stop postgresql

## Description
The SQL script '**restaurant_database.sql**' performs the following tasks:

1. **Create Tables**
    - **restaurant**: Stores restaurant information.
    - **address**: Stores address details linked to restaurants.
    - **category**: Stores different categories of dishes.
    - **dish**: Stores dish information.
    - **categories_dishes**: Links dishes to categories with pricing.
    - **review**: Stores reviews for restaurants.

2. **Insert Data**
    - Inserts sample data into the '**restaurant**', '**address**', '**review**', '**category**', '**dish**', and '**categories_dishes**' tables.

3. **Queries**
    - **Display restaurant details**: Shows restaurant name, address, and telephone number.
    - **Best rating**: Retrieves the highest rating the restaurant has received.
    - **Dishes by category**: Lists dish names, prices, and categories sorted by category name.
    - **Spicy dishes**: Lists all spicy dishes with their prices and categories.
    - **Dishes in multiple categories**: Finds dishes that belong to more than one category.

## Usage
### Display Restaurant Details
To view the restaurant name, its address (street number and name), and telephone number:

```sql
SELECT restaurant.name AS restaurant,
       address.street_number AS number,
       address.street_name AS street,
       restaurant.telephone AS telephone
FROM restaurant
JOIN address ON restaurant.id = address.restaurant_id;
```

### Get the Best Rating
To get the best rating the restaurant ever received:

```sql
SELECT rating AS best_rating, description
FROM review
WHERE rating = (SELECT MAX(rating) FROM review);
```

### Display Dishes by Category
To display dish name, its price, and category sorted by the category name:

```sql
SELECT category.name AS category,
       dish.name AS dish_name,
       categories_dishes.price AS price
FROM categories_dishes
JOIN dish ON categories_dishes.dish_id = dish.id
JOIN category ON categories_dishes.category_id = category.id
ORDER BY category.name;
```

### Display Spicy Dishes
To display all the spicy dishes, their prices, and category:

```sql
SELECT dish.name AS spicy_dish_name,
       category.name AS category,
       categories_dishes.price AS price
FROM dish
JOIN categories_dishes ON dish.id = categories_dishes.dish_id
JOIN category ON categories_dishes.category_id = category.id
WHERE dish.hot_and_spicy = TRUE
ORDER BY category.name;
```

### Find Dishes in Multiple Categories
To find dishes that belong to more than one category:

```sql
SELECT dish.name AS dish_name, COUNT(categories_dishes.dish_id) AS dish_count
FROM dish
JOIN categories_dishes ON dish.id = categories_dishes.dish_id
GROUP BY dish.name
HAVING COUNT(dish_id) > 1;
```
