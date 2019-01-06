# Burger (Sequelized)

![Alt Text](https://media.giphy.com/media/4ZaY2DxKxUDRILkOKr/giphy.gif)

A Node, Express, Handlebars, and MySQL burger app that lets users input the names of burgers they'd like to eat... and then devour them!

This app is a remake of the original Burger repo found [here](https://github.com/lindsnicolewalker/burger). The key difference is that is uses the Sequelize ORM rather than raw MySQL queries in a homemade ORM. And, using Sequelize, the app is now relational, tracking which users ate which burger.

Please try out the deployed app in Heroku, found [here](https://hidden-hollows-71541.herokuapp.com/).


## Description

Burger! is a restaurant app that follows the Model-View-Controller (MVC), an architectural pattern, and lets users input the names of burgers they'd like to eat.
Whenever a user submits a burger's name, my app will display the burger on the designated section of the page -- waiting to be devoured!
Each burger in the waiting area also has a Devour! button. When the user clicks it, the burger will move to the appropriate side of the page, waiting to be made, next to a Make! button.
My app will store every burger in a database, whether devoured or not.

## Demo

![Alt Text](https://media.giphy.com/media/OPf7sFAj7xPDl1QDLO/giphy.gif)

## Technology

MySQL, Node, Express, Handlebars and a MySQL ORM, MVC architecture

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

## Models/index.js
		'use strict';

		const fs = require('fs');
		const path = require('path');
		const Sequelize = require('sequelize');
		const basename = path.basename(__filename);
		const env = process.env.NODE_ENV || 'development';
		const config = require(__dirname + '/../config/config.json')[env];
		const db = {};

		let sequelize;
		if (config.use_env_variable) {
		sequelize = new Sequelize(process.env[config.use_env_variable], config);
		} else {
		sequelize = new Sequelize(config.database, config.username, config.password, config);
		}

		fs
		.readdirSync(__dirname)
		.filter(file => {
			return (file.indexOf('.') !== 0) && (file !== basename) && (file.slice(-3) === '.js');
		})
		.forEach(file => {
			const model = sequelize['import'](path.join(__dirname, file));
			db[model.name] = model;
		});

		Object.keys(db).forEach(modelName => {
		if (db[modelName].associate) {
			db[modelName].associate(db);
		}
		});

		db.sequelize = sequelize;
		db.Sequelize = Sequelize;

		module.exports = db;


## Controllers

		var express = require("express");

		var router = express.Router();

		// Import the model (burger.js) to use its database functions.
		var burger = require("../models/burger.js");
		var db = require("../models");
		// Create all our routes and set up logic within those routes where required.
		router.get("/", function(req, res) {
		db.Burger.findAll().then(function(data) {
			var hbsObject = {
			burgers: data
			};
			console.log(hbsObject);
			res.render("index", hbsObject);
		});
		});

		router.post("/api/burger", function(req, res) {
		db.Burger.create({
		burger_name: req.body.burger_name
		}).then(function(result) {
			res.json({ id: result.insertId });
		});
		});

		router.put("/api/burger/:id", function(req, res) {
		var condition = "id = " + req.params.id;

		console.log("condition", condition);

		db.Burger.update({
			devoured: req.body.devoured
		}, {where: {id:req.params.id}}).then(function(result) {
			if (result.changedRows == 0) {
			// If no rows were changed, then the ID must not exist, so 404
			return res.status(404).end();
			} else {
			res.status(200).end();
			}
		});
		});

		// Export routes for server.js to use.
		module.exports = router;

## Server.js

		db.sequelize.sync().then(function(){
		// Start our server so that it can begin listening to client requests.
		app.listen(PORT, function() {
		// Log (server-side) when our server has started
		console.log("Server listening on: http://localhost:" + PORT);
		});


## Installation

To install the application follow the instructions below in your terminal:  

	git clone git@github.com:lindsnicolewalker/sequelizedBurger.git
	cd sequelizedBurger
	npm install
	
## Using App Locally

To run the application locally and access it in your browser, first set the `PORT` environment variable to the value of your choice. An example is shown below.

	export PORT=8080
	
After the `PORT` environment variable has been set, navigate to your app master directory and then run the Node.js application with the command below.

	node server.js

The application will now be running locally on `PORT`, in this case that is port 8080. You can then access it locally from your browser at the URL `localhost:PORT`by typing into your browser searchbar: `localhost:8080`.


## Author

Lindsey Walker

