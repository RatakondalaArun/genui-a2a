-- Create restaurants table
CREATE TABLE IF NOT EXISTS restaurants (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  cuisine VARCHAR(100) NOT NULL,
  address VARCHAR(500) NOT NULL,
  phone VARCHAR(20) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  rating DECIMAL(3,1) CHECK (rating >= 0 AND rating <= 5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clear existing data
TRUNCATE TABLE restaurants RESTART IDENTITY;

-- Insert mock data
INSERT INTO restaurants (name, cuisine, address, phone, email, rating) VALUES
  ('The Golden Spoon', 'French', '123 Main St, Paris', '+33-1-2345-678', 'gold@spoon.fr', 4.8),
  ('Pasta Paradise', 'Italian', '456 Roma Ave, Rome', '+39-6-1234-567', 'pasta@paradise.it', 4.5),
  ('Sushi Central', 'Japanese', '789 Tokyo Rd, Tokyo', '+81-3-1234-567', 'sushi@central.jp', 4.9),
  ('Taco Town', 'Mexican', '321 Mexico St, Mexico City', '+52-55-1234-56', 'taco@town.mx', 4.0),
  ('Taj Mahal Express', 'Indian', '654 Delhi Ln, New Delhi', '+91-11-1234-56', 'taj@express.in', 4.4),
  ('Dragon Palace', 'Chinese', '111 Beijing St, Beijing', '+86-10-1234-56', 'dragon@palace.cn', 4.6),
  ('Olive Garden', 'Spanish', '222 Barcelona Ave, Barcelona', '+34-93-1234-56', 'olive@garden.es', 4.3),
  ('Bangkok Street', 'Thai', '333 Bangkok Rd, Bangkok', '+66-2-1234-567', 'bangkok@street.th', 4.2),
  ('Prime Steakhouse', 'American', '444 New York St, New York', '+1-212-1234-56', 'prime@steak.us', 4.7),
  ('Burger Barn', 'American', '555 Chicago Ave, Chicago', '+1-312-1234-56', 'burger@barn.us', 3.9),
  ('Kebab King', 'Turkish', '666 Istanbul Ln, Istanbul', '+90-212-1234-5', 'kebab@king.tr', 4.1),
  ('Pho Paradise', 'Vietnamese', '777 Hanoi St, Hanoi', '+84-24-1234-56', 'pho@paradise.vn', 4.4),
  ('Risotto Palace', 'Italian', '888 Milan Ave, Milan', '+39-2-1234-567', 'risotto@palace.it', 4.5),
  ('Falafel House', 'Lebanese', '999 Beirut Rd, Beirut', '+961-1-1234-56', 'falafel@house.lb', 4.2),
  ('Seoul Kitchen', 'Korean', '1010 Seoul St, Seoul', '+82-2-1234-567', 'seoul@kitchen.kr', 4.6),
  ('Pizza Napoli', 'Italian', '1111 Naples Ave, Naples', '+39-81-1234-56', 'pizza@napoli.it', 4.8),
  ('Fish & Chips', 'British', '1212 London Ln, London', '+44-20-1234-5', 'fish@chips.uk', 3.8),
  ('Tapas Bar', 'Spanish', '1313 Madrid St, Madrid', '+34-91-1234-56', 'tapas@bar.es', 4.3),
  ('Gyro Express', 'Greek', '1414 Athens Ave, Athens', '+30-21-1234-56', 'gyro@express.gr', 4.0),
  ('Ramen House', 'Japanese', '1616 Tokyo St, Tokyo', '+81-3-5678-901', 'ramen@house.jp', 4.7),
  ('Carne Asada', 'Mexican', '1717 Guadalajara Ave, Guadalajara', '+52-33-1234-56', 'carne@asada.mx', 4.3),
  ('Gourmet Bistro', 'French', '1818 Lyon St, Lyon', '+33-4-5678-901', 'gourmet@bistro.fr', 4.6),
  ('Trattoria Roma', 'Italian', '1919 Rome Ave, Rome', '+39-6-5678-901', 'trattoria@roma.it', 4.5),
  ('Peking Duck', 'Chinese', '2020 Beijing St, Beijing', '+86-10-5678-90', 'peking@duck.cn', 4.8),
  ('Tandoori Kitchen', 'Indian', '2121 Mumbai Rd, Mumbai', '+91-22-1234-56', 'tandoori@kitchen.in', 4.4),
  ('Tapas Español', 'Spanish', '2222 Seville Ave, Seville', '+34-95-1234-56', 'tapas@espanol.es', 4.2),
  ('Noodle Nirvana', 'Asian', '2323 Singapore St, Singapore', '+65-6789-012', 'noodle@nirvana.sg', 4.5),
  ('BBQ Smokehouse', 'American', '2424 Texas Ave, Dallas', '+1-214-1234-5', 'bbq@smokehouse.us', 4.4),
  ('Mediterranean Sea', 'Mediterranean', '2525 Crete Rd, Crete', '+30-28-1234-56', 'med@sea.gr', 4.3),
  ('Curry House', 'Indian', '2626 Delhi St, New Delhi', '+91-11-5678-90', 'curry@house.in', 4.2),
  ('Pizza Venezia', 'Italian', '2727 Venice Ave, Venice', '+39-41-1234-56', 'pizza@venezia.it', 4.6),
  ('Seoul Spice', 'Korean', '2828 Busan Rd, Busan', '+82-51-1234-56', 'seoul@spice.kr', 4.5),
  ('Seafood Palace', 'Seafood', '2929 Miami St, Miami', '+1-305-1234-56', 'seafood@palace.us', 4.7),
  ('Bangkok Basil', 'Thai', '3030 Phuket Ave, Phuket', '+66-76-1234-56', 'bangkok@basil.th', 4.4),
  ('Grill House', 'American', '3131 Denver St, Denver', '+1-720-1234-56', 'grill@house.us', 4.3),
  ('Saffron Spice', 'Indian', '3232 Jaipur Rd, Jaipur', '+91-141-1234-5', 'saffron@spice.in', 4.6),
  ('Pasta Fresca', 'Italian', '3333 Florence Ave, Florence', '+39-55-1234-56', 'pasta@fresca.it', 4.5),
  ('Dragon Wok', 'Chinese', '3434 Shanghai St, Shanghai', '+86-21-5678-90', 'dragon@wok.cn', 4.4),
  ('Lobster Tail', 'Seafood', '3535 Boston Ave, Boston', '+1-617-1234-56', 'lobster@tail.us', 4.8),
  ('Churrasqueria', 'Brazilian', '3636 Rio St, Rio de Janeiro', '+55-21-1234-56', 'churrasq@bra.br', 4.5),
  ('Lemongrass Café', 'Thai', '3737 Bangkok Ln, Bangkok', '+66-2-5678-901', 'lemongrass@cafe.th', 4.3),
  ('Falafel Temple', 'Mediterranean', '3838 Jerusalem Rd, Jerusalem', '+972-2-1234-56', 'falafel@temple.il', 4.2),
  ('Wagyu Club', 'Japanese', '3939 Tokyo Rd, Tokyo', '+81-3-9012-345', 'wagyu@club.jp', 4.9);

-- Verify restaurants
SELECT * FROM restaurants ORDER BY rating DESC;

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
  id SERIAL PRIMARY KEY,
  restaurant_id INTEGER NOT NULL,
  customer_name VARCHAR(255) NOT NULL,
  customer_email VARCHAR(255) NOT NULL,
  customer_phone VARCHAR(20) NOT NULL,
  booking_date DATE NOT NULL,
  booking_time TIME NOT NULL,
  party_size INTEGER NOT NULL CHECK (party_size > 0 AND party_size <= 20),
  special_requests TEXT,
  status VARCHAR(50) NOT NULL DEFAULT 'confirmed' CHECK (status IN ('confirmed', 'pending', 'cancelled', 'completed')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- Clear existing booking data
TRUNCATE TABLE bookings RESTART IDENTITY;

-- Insert mock booking data
INSERT INTO bookings (restaurant_id, customer_name, customer_email, customer_phone, booking_date, booking_time, party_size, special_requests, status) VALUES
  (1, 'John Smith', 'john.smith@email.com', '+33-1-9876-543', '2026-01-25', '19:30:00', 4, 'Window seat preferred', 'confirmed'),
  (1, 'Sarah Johnson', 'sarah.j@email.com', '+33-1-8765-432', '2026-01-26', '20:00:00', 2, 'Vegetarian options needed', 'confirmed'),
  (2, 'Michael Brown', 'm.brown@email.com', '+39-6-7654-321', '2026-01-27', '18:30:00', 6, 'Celebrate anniversary', 'pending'),
  (3, 'Emma Wilson', 'emma.w@email.com', '+81-3-6543-210', '2026-01-28', '19:00:00', 3, 'Allergic to shellfish', 'confirmed'),
  (4, 'David Martinez', 'david.m@email.com', '+52-55-5432-10', '2026-01-29', '20:30:00', 5, 'Birthday party', 'confirmed'),
  (5, 'Lisa Anderson', 'lisa.a@email.com', '+91-11-4321-098', '2026-01-30', '18:00:00', 2, '', 'confirmed'),
  (6, 'James Taylor', 'james.t@email.com', '+86-10-3210-987', '2026-02-01', '19:30:00', 4, 'Prefer non-smoking area', 'pending'),
  (7, 'Patricia Garcia', 'patricia.g@email.com', '+34-93-2109-876', '2026-02-02', '21:00:00', 3, 'High chair needed', 'confirmed'),
  (8, 'Robert Lee', 'robert.l@email.com', '+66-2-1098-765', '2026-02-03', '19:00:00', 7, 'Group of friends', 'confirmed'),
  (9, 'Jennifer White', 'jennifer.w@email.com', '+1-212-0987-65', '2026-02-04', '20:00:00', 2, 'Special occasion', 'confirmed'),
  (10, 'Christopher Hall', 'chris.h@email.com', '+1-312-9876-54', '2026-02-05', '18:30:00', 5, 'Vegan options please', 'pending'),
  (11, 'Mary Davis', 'mary.d@email.com', '+90-212-8765-43', '2026-02-06', '19:30:00', 4, '', 'confirmed'),
  (12, 'Daniel Rodriguez', 'daniel.r@email.com', '+84-24-7654-32', '2026-02-07', '20:30:00', 3, 'Gluten-free menu', 'confirmed'),
  (13, 'Susan Miller', 'susan.m@email.com', '+39-2-6543-21', '2026-02-08', '19:00:00', 6, 'Corporate dinner', 'confirmed'),
  (14, 'Joseph Wilson', 'joseph.w@email.com', '+961-1-5432-10', '2026-02-09', '20:00:00', 2, 'Romantic dinner', 'confirmed'),
  (15, 'Jessica Moore', 'jessica.m@email.com', '+82-2-4321-098', '2026-02-10', '18:30:00', 8, 'Family gathering', 'pending'),
  (16, 'Charles Jackson', 'charles.j@email.com', '+39-81-3210-987', '2026-02-11', '19:30:00', 4, '', 'confirmed'),
  (17, 'Dorothy White', 'dorothy.w@email.com', '+44-20-2109-876', '2026-02-12', '20:00:00', 5, 'Celebration', 'confirmed'),
  (18, 'Matthew Harris', 'matthew.h@email.com', '+34-91-1098-765', '2026-02-13', '19:00:00', 3, 'Business meeting', 'confirmed'),
  (19, 'Nancy Martin', 'nancy.m@email.com', '+30-21-0987-654', '2026-02-14', '20:30:00', 2, 'Valentine dinner', 'confirmed'),
  (20, 'Mark Thompson', 'mark.t@email.com', '+81-3-9876-543', '2026-02-15', '18:30:00', 4, 'Allergic to peanuts', 'pending'),
  (21, 'Betty Garcia', 'betty.g@email.com', '+52-33-8765-432', '2026-02-16', '19:30:00', 6, 'Family dinner', 'confirmed'),
  (22, 'Donald Edwards', 'donald.e@email.com', '+33-4-7654-321', '2026-02-17', '20:00:00', 3, '', 'confirmed'),
  (23, 'Sandra Clark', 'sandra.c@email.com', '+39-6-6543-210', '2026-02-18', '19:00:00', 5, 'Business lunch', 'confirmed'),
  (24, 'Steven Lewis', 'steven.l@email.com', '+86-10-5432-10', '2026-02-19', '20:30:00', 2, 'Quiet table', 'pending'),
  (25, 'Ashley Walker', 'ashley.w@email.com', '+34-95-4321-098', '2026-02-20', '18:30:00', 4, '', 'confirmed'),
  (26, 'Paul Young', 'paul.y@email.com', '+65-6789-012', '2026-02-21', '19:30:00', 7, 'Celebration dinner', 'confirmed'),
  (27, 'Kathleen Hernandez', 'kathleen.h@email.com', '+1-214-3210-987', '2026-02-22', '20:00:00', 3, 'Vegetarian only', 'confirmed'),
  (28, 'Andrew King', 'andrew.k@email.com', '+30-28-2109-876', '2026-02-23', '19:00:00', 5, '', 'confirmed'),
  (29, 'Diane Wright', 'diane.w@email.com', '+91-11-1098-765', '2026-02-24', '20:30:00', 2, 'Early seating', 'pending'),
  (30, 'Kenneth Lopez', 'kenneth.l@email.com', '+39-41-0987-654', '2026-02-25', '18:30:00', 6, 'Family reunion', 'confirmed'),
  (1, 'Christine Hill', 'christine.h@email.com', '+82-51-9876-543', '2026-02-26', '19:30:00', 4, 'Celebrating promotion', 'confirmed'),
  (3, 'Jonathan Scott', 'jonathan.s@email.com', '+1-305-8765-432', '2026-02-27', '20:00:00', 3, '', 'confirmed'),
  (5, 'Catherine Green', 'catherine.g@email.com', '+66-76-7654-321', '2026-02-28', '19:00:00', 5, 'Kosher meal', 'confirmed'),
  (7, 'Ryan Adams', 'ryan.a@email.com', '+1-720-6543-210', '2026-03-01', '20:30:00', 2, 'Surprise dinner', 'pending'),
  (9, 'Samantha Nelson', 'samantha.n@email.com', '+91-141-5432-10', '2026-03-02', '18:30:00', 8, 'Wedding engagement', 'confirmed');

-- Verify bookings
SELECT b.id, r.name as restaurant, b.customer_name, b.booking_date, b.booking_time, b.party_size, b.status 
FROM bookings b 
JOIN restaurants r ON b.restaurant_id = r.id 
ORDER BY b.booking_date DESC;
