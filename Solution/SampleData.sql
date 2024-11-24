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