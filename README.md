# Monster Shop Final
BE Mod 2 Final Solo Project

# How to run Monster Shop 

Clone down this repo, run a local server and visit your local host through a browser to access the app. Aternatively you can try out Monster Shop on heroku here: http://puggly-wuggly2.herokuapp.com. From the root page you can access all of Monster Shops features. 

# Monster Shop Design

Monster Shop is a rails a Ruby on Rails Web App designed with an MVC Framework. This fictional E-Commerce site utilizes full CRUD functionality through a PostgreSQL database. Monster shop has 5 different types of user roles ranging from a visitor to a site admin. All of these different roles have different access to the features of the site, ranging from adding and purchasing items from a cart, to creating new merchants and fulfilling user orders.

Monster Shop was designed to be a fun and easy to user interface. Flash messages are displayed for all happy and sad path scenarios, and always let the user know when the app has recieved unexpected input. All passwords used in Monster Shop are hashed using BCrypt and raw password are never stored in the database. 

Logic is carefully organized utilizing MVC structure. All database logic is contained within the model, and views never contain computation. Monster shop utlizes view partials to ensure the source code is as DRY as possible. 

# Database Schema
![db-schema](https://i.ibb.co/pjxTsH7/Screen-Shot-2019-09-15-at-4-46-21-PM.png) 


