CREATE DATABASE  IF NOT EXISTS pablopaez ;
USE pablopaez;

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
    name VARCHAR(100) NOT NULL UNIQUE,
    cost DECIMAL DEFAULT 0
);

CREATE TABLE  IF NOT EXISTS Event (
    id INT PRIMARY KEY  auto_increment,
    location_id int NOT NULL,
    activity_id int NOT NULL,
    ticket_price DECIMAL,
    start_date DATETIME,
    name VARCHAR(100) NOT NULL UNIQUE,
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
    cache DECIMAL DEFAULT 0,

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

--- Data de ejmplo (generada por gemeni AI):

INSERT INTO Artist (biography, full_name)
VALUES
('A renowned jazz musician with a soulful voice.', 'Ella Fitzgerald'),
('A legendary rock band known for their powerful performances.', 'Queen'),
('A contemporary dance company exploring innovative movement.', 'Pilobolus');

INSERT INTO Location (street_address, city, capacity, rent_price, characteristics, name)
VALUES
('123 Main Street', 'New York', 5000, 10000.00, 'Large stage, state-of-the-art sound system', 'Madison Square Garden'),
('456 Elm Street', 'Los Angeles', 2000, 5000.00, 'Outdoor venue, scenic view', 'Hollywood Bowl'),
('789 Oak Street', 'Chicago', 1000, 2000.00, 'Intimate theater, historical significance', 'Chicago Theatre');

INSERT INTO Activity (type, name)
VALUES
('Concert', 'Ella Fitzgerald Live'),
('Rock Concert', 'Queen\'s Greatest Hits Tour'),
('Dance Performance', 'Pilobolus: A Night of Dance');

INSERT INTO Event (location_id, activity_id, ticket_price, start_date, name)
VALUES
(1, 1, 100.00, '2023-11-23 20:00:00', 'Ella Fitzgerald Live at Madison Square Garden'),
(2, 2, 150.00, '2023-12-15 19:00:00', 'Queen\'s Greatest Hits Tour at Hollywood Bowl'),
(3, 3, 75.00, '2024-01-10 20:30:00', 'Pilobolus: A Night of Dance at Chicago Theatre');

INSERT INTO Attendee (event_id, mail, full_name, telephone)
VALUES
(1, 'johndoe@example.com', 'John Doe', '123-456-7890'),
(2, 'janesmith@example.com', 'Jane Smith', '987-654-3210'),
(3, 'mikeross@example.com', 'Mike Ross', '555-555-5555');

INSERT INTO Perform (activity_id, artist_id, cache)
VALUES
(1, 1, 50000.00),
(2, 2, 100000.00),
(3, 3, 75000.00);

-- Vista

-- vista para mostrar todos los datos relacionados a un evento
CREATE VIEW event_data AS
SELECT e.name Event_Name, e.start_date Event_Start_Date, e.ticket_price Event_Ticket_Price, a.name Activity_Name, a.type Activity_Type, l.name Location_Name, l.street_address Location_Address, l.capacity Location_Capacity
FROM pablopaez.event e
inner join pablopaez.activity a on a.id = e.id
inner join pablopaez.location l on l.id = e.location_id ;


-- Queries

-- trae las ubicaciones ordenadas por el costo mas barato en relacion a la capacidad y el costo de alquiler
select l.name, l.rent_price / l.capacity as location_cost_per_seat
from location l
order by location_cost_per_seat DESC;

-- trae la informacion de los eventos futuros usando la vista de eventos
select * from event_data
where Event_Start_Date > NOW();

-- trae los artistas con el numero de actuaciones de cada uno
select a.full_name, COUNT(p.artist_id) as performings_numbers
from artist a
inner join perform p on p.artist_id = a.id
group by a.id
order by performings_numbers DESC;

-- trae las ubicaciones ordenadas por el numero de eventos
select l.name,  COUNT(*) AS event_count from pablopaez.event e
inner join pablopaez.location l on l.id = e.location_id
group by l.id
order by event_count DESC;

-- trae las fechas con mas eventos
select e.start_date,COUNT(*) as event_count from pablopaez.event e
group by e.start_date
order by event_count;

-- trae los tipos de actividades ordenados por el numero de eventos asociados
select a.type, COUNT(*) as event_count from pablopaez.activity a
inner join pablopaez.event e on e.activity_id = a.id
group by a.type
order by event_count DESC;

-- trae los tipos de actividades ordenados por la suma del numero de asistentes en todos los eventos
select act.type, count(att.id) as attendes_per_activity_type
from pablopaez.activity act
inner join pablopaez.event e on e.activity_id = act.id
inner join pablopaez.attendee att on att.event_id = e.id
group by act.type
order by attendes_per_activity_type DESC;

-- traer los artistas que cobren mas barato en promedio
select a.full_name, SUM(p.cache)/ COUNT(p.activity_id) as average_cache
from pablopaez.artist a
inner join perform p on p.activity_id = a.id
group by a.id
order by average_cache DESC;

-- trae los eventos y sus rentabilidades (ganancias como la suma de las entradas vendidas menos el costo de la actividad)
select e.name, COUNT(att.id) * e.ticket_price - (act.cost + l.rent_price) as event_earning
from pablopaez.event e
inner join activity act on act.id = e.activity_id
inner join attendee att on att.event_id = e.id
inner join location l on l.id = e.location_id
group by e.id
order by event_earning DESC;

-- trae todo los futuros eventos con ubicacion disponible (que el numero de attendes sea menor a la capacity de la location)
select e.name, l.capacity - SUM(a.id) as capacity_available
from pablopaez.event e
inner join pablopaez.location l on l.id = e.location_id
inner join pablopaez.attendee a on a.event_id = e.id
where e.start_date > NOW()
group by e.id
having  capacity_available > 0
order by capacity_available DESC;

