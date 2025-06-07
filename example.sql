CREATE TABLE customers  (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone varchar(10) not null unique
);

CREATE TABLE services  (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE appointments  (
  appointment_id SERIAL PRIMARY KEY,
  customer_id int not null,
  service_id int not null,
  time varchar not null,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id)
);


INSERT INTO services(name) VALUES 
  ('cut'),
  ('color'),
  ('perm');
