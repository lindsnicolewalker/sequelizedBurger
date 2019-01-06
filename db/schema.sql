DROP DATABASE IF EXISTS bf6d029qqeofpztm;
CREATE DATABASE IF NOT EXISTS bf6d029qqeofpztm;
USE bf6d029qqeofpztm;

CREATE TABLE burger (
	id INT AUTO_INCREMENT NOT NULL,
	burger_name VARCHAR(255),
	devoured BOOLEAN DEFAULT false,
    createdAt TIMESTAMP NOT NULL,
	PRIMARY KEY (id)
);

SELECT * FROM bf6d029qqeofpztm.burger;