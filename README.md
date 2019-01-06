# Burger

Check it out [here](https://secret-beach-37555.herokuapp.com/)  
![Alt Text](https://media.giphy.com/media/4ZaY2DxKxUDRILkOKr/giphy.gif)


## Description

Burger! is a restaurant app that lets users input the names of burgers they'd like to eat.
Whenever a user submits a burger's name, my app will display the burger on the designated section of the page -- waiting to be devoured.
Each burger in the waiting area also has a Devour! button. When the user clicks it, the burger will move to the appropriate side of the page, waiting to be made, next to a Make! button.
My app will store every burger in a database, whether devoured or not.

## Demo

![Alt Text](https://media.giphy.com/media/OPf7sFAj7xPDl1QDLO/giphy.gif)

## Technology

MySQL, Node, Express, Handlebars and a homemade ORM 

# Code

## Making a connection to JAWSDB  

	var connection;

	if (process.env.JAWSDB_URL) {
    connection = mysql.createConnection(process.env.JAWSDB_URL);

	} else {
    connection = mysql.createConnection({
        host: "localhost",
        port: 3306,
        user: "root",
        password: "password",
        database: "burgers_db"
      });
	}

## Homemade ORM

		var connection = require("../config/connection.js");

		var orm = {
		all: function(tableInput, cb) {
			var queryString = "SELECT * FROM " + tableInput + ";";
			connection.query(queryString, function(err, result) {
			if (err) {
				throw err;
			}
			cb(result);
			});
		},
		create: function(table, cols, vals, cb) {
			var queryString = "INSERT INTO " + table;

			queryString += " (";
			queryString += cols.toString();
			queryString += ") ";
			queryString += "VALUES (";
			queryString += printQuestionMarks(vals.length);
			queryString += ") ";

			console.log(queryString);

			connection.query(queryString, vals, function(err, result) {
			if (err) {
				throw err;
			}

			cb(result);
			});
		},
		update: function(table, objColVals, condition, cb) {
			var queryString = "UPDATE " + table;

			queryString += " SET ";
			queryString += objToSql(objColVals);
			queryString += " WHERE ";
			queryString += condition;

			console.log(queryString);
			connection.query(queryString, function(err, result) {
			if (err) {
				throw err;
			}

			cb(result);
			});
		}
		};

		module.exports = orm;

## Controllers

		var router = express.Router();
		router.get("/", function(req, res) {
		burger.all(function(data) {
			var hbsObject = {
			burgers: data
			};
			console.log(hbsObject);
			res.render("index", hbsObject);
		});
		});

		router.post("/api/burger", function(req, res) {
		burger.create([
			"burger_name", "devoured"
			], [
			req.body.burger_name, req.body.devoured
			], function(result) {
			res.json({ id: result.insertId });
		});
		});

		router.put("/api/burger/:id", function(req, res) {
			var condition = "id = " + req.params.id;

		burger.update({
			devoured: req.body.devoured
			}, condition, function(result) {
			if (result.changedRows == 0) {
			return res.status(404).end();
			} else {
			res.status(200).end();
			}
		});
		});

		// Export routes for server.js to use.
		module.exports = router;

## Javascript

		var burger = {
		all: function(cb) {
			orm.all("burger", function(res) {
			cb(res);
			});
		},
		create: function(cols, vals, cb) {
			orm.create("burger", cols, vals, function(res) {
			cb(res);
			});
		},
		update: function(objColVals, condition, cb) {
			orm.update("burger", objColVals, condition, function(res) {
			cb(res);
			});
		}

## Server.js

		var express = require("express");
		var app = express();

		var PORT = process.env.PORT || 8080;

		app.use(express.static("public"));

		app.use(express.urlencoded({ extended: true }));
		app.use(express.json());

		var exphbs = require("express-handlebars");

		app.engine("handlebars", exphbs({ defaultLayout: "main" }));
		app.set("view engine", "handlebars");

		var routes = require("./controllers/burgers_Controller.js");

		app.use(routes);

		app.listen(PORT, function() {
		console.log("Server listening on: http://localhost:" + PORT);
		});

## Installation

To install the application follow the instructions below in your terminal:  

	git clone git@github.com:lindsnicolewalker/burger.git
	cd burger
	npm install
	
## Using App Locally

To run the application locally and access it in your browser, first set the `PORT` environment variable to the value of your choice. An example is shown below.

	export PORT=8080
	
After the `PORT` environment variable has been set, navigate to your app master directory and then run the Node.js application with the command below.

	node server.js

The application will now be running locally on `PORT`, in this case that is port 8080. You can then access it locally from your browser at the URL `localhost:PORT`by typing into your browser searchbar: `localhost:8080`.


## Author

Lindsey Walker

