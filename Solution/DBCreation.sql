CREATE DATABASE  IF NOT EXISTS EventsDb ;
USE EventsDb;

CREATE TABLE IF NOT EXISTS Artist (
    id  INT PRIMARY KEY  auto_increment,
    biography VARCHAR(500),
    full_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Location (
    id INT PRIMARY KEY  auto_increment,
    street_address VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL, 
    capacity INT NOT NULL,
    rent_price DECIMAL,
    characteristics VARCHAR(100),
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Activity (
    id INT PRIMARY KEY  auto_increment,
    type VARCHAR(100) NOT NULL,
    name VARCHAR(100) UNIQUE,
    cost DECIMAL DEFAULT 0
);

CREATE TABLE  IF NOT EXISTS Event (
    id INT PRIMARY KEY  auto_increment,
    location_id int NOT NULL,
    activity_id int NOT NULL,
    ticket_price DECIMAL,
    start_date DATETIME,
    name VARCHAR(100),
    FOREIGN KEY (location_id) REFERENCES Location(id),
    FOREIGN KEY (activity_id) REFERENCES Activity(id)
);

CREATE TABLE IF NOT EXISTS Attendee (
    id INT PRIMARY KEY  auto_increment,
    event_id INT NOT NULL,
    mail VARCHAR(50) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    telephone VARCHAR(50),
    FOREIGN KEY (event_id) REFERENCES Event(id),
    UNIQUE(event_id, full_name)
);

CREATE TABLE IF NOT EXISTS Perform (
    activity_id INT NOT NULL,
    artist_id INT NOT NULL,
    cache DECIMAL,

    PRIMARY KEY(activity_id,artist_id)
);

-- Triggers

CREATE TRIGGER increment_activity_cost
AFTER INSERT ON Perform
FOR EACH ROW
    UPDATE Activity
    SET cost = cost + NEW.cache
    WHERE id = NEW.activity_id;

CREATE TRIGGER decrement_activity_price
AFTER DELETE ON Perform
FOR EACH ROW
    UPDATE Activity
    SET cost = cost - old.cache
    WHERE id = old.activity_id;