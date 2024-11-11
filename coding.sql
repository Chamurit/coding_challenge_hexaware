-- create data base
create database car_rental_system;

--use
use car_rental_system;


--create table
-- create table for vehicle
create table vehicles (
vehicleID int primary key,
make varchar(50),
model varchar(50),
year int,
dailyRate decimal(10,2),
status varchar(50),
passengersCapacity int,
engineCapaCity int);

--create table for customer

create table customer (
customerID int primary key,
firstname varchar(50),
lastname varchar(50),
email varchar(100),
phonenumber varchar(20) );

--create table for leasetable

create table lease (
leaseID int primary key,
vehicleID int,
customerID int,
startdate date,
enddate date,
leasetype varchar (50),
foreign key (vehicleID) references vehicles(vehicleID),
foreign key (customerID) references customer(customerID) );

--create table for payments

create table payment (
paymentID INT PRIMARY KEY,
LEASEID int,
paymentDate date,
amount decimal (10,2),
foreign key (leaseID) references lease(leaseID) );

-- insert values

--insert values to vehicles
insert into Vehicles (vehicleID, make, model, year, dailyRate, status, passengersCapacity, engineCapacity) VALUES
(1, 'Toyota', 'Camry', 2022, 50.00, 'available', 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 'available', 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 'notAvailable', 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 'available', 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 'available', 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 'notAvailable', 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 'available', 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 'available', 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 'notAvailable', 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 'available', 4, 2500);


UPDATE vehicles
SET status = CASE 
    WHEN status = 'available' THEN 1
    WHEN status = 'notAvailable' THEN 0
END;

alter table vehicles
alter column status int;

--insert values to customer

insert into Customer (customerID, firstName, lastName, email, phoneNumber) VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');


insert into Lease (leaseID, vehicleID, customerID, startDate, endDate, leaseType) VALUES
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');

insert into Payment (paymentID, leaseID, paymentDate, amount) VALUES
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00);

--

--1. Update the daily rate for a Mercedes car to 68.

update vehicles
set dailyRate=68.00
where make='Mercedes';

select * from vehicles;

--2 Delete a specific customer and all associated leases and payments.alter table customeradd paymentID int null;
delete from customer where customerID = 3;
--3Rename the "paymentDate" column in the Payment table to "transactionDate".
exec sp_rename 'Payment.paymentDate', 'transactionDate', 'column';

select * from payment;

--4Find a specific customer by email.

select * from customer
where email='sarah@example.com';

--5 Get active leases for a specific customer

select *from Lease
where customerID = 1 and GETDATE() BETWEEN startDate AND endDate;

--6 Find all payments made by a customer with a specific phone number
SELECT P.paymentID,  P.transactionDate,  P.amount C.customerID,
    CONCAT(C.firstName, ' ', C.lastName) AS name, 
    C.phoneNumber
FROM  Payment AS P
JOIN  Lease AS L ON P.leaseID = L.leaseID
JOIN Customer AS C ON L.customerID = C.customerID
WHERE  C.phoneNumber = '555-555-5555';

--7 Calculate the average daily rate of all available cars
SELECT AVG(dailyRate) AS AverageDailyRate
FROM Vehicles
WHERE status = '1';

--8Find the car with the highest daily rate
select top 1 * FROM Vehicles
ORDER BY dailyRate DESC;

--9Retrieve all cars leased by a specific customer
SELECT v.*FROM Vehicles v
JOIN Lease l ON v.vehicleID = l.vehicleID
WHERE l.customerID = 1;

--10Find the details of the most recent lease
select top 1* FROM Lease
ORDER BY endDate DESC ;

--11List all payments made in the year 2023

select * from Payment
where year(transactionDate) = 2023;

--12Retrieve customers who have not made any paymen
select* from Customer c
WHERE NOT EXISTS ( SELECT 1 FROM Lease l JOIN Payment p ON l.leaseID = p.leaseID
    WHERE l.customerID = c.customerID
);

--13Retrieve Car Details and Their Total Payments

SELECT v.vehicleID, v.make, v.model, v.year, SUM(p.amount) AS TotalPayments
FROM Vehicles v
JOIN Lease l ON v.vehicleID = l.vehicleID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model, v.year;

--14Calculate Total Payments for Each Customer
SELECT c.customerID, c.firstName, c.lastName, SUM(p.amount) AS TotalPayments
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName;

--15List Car Details for Each Lease
SELECT l.leaseID, v.make, v.model, v.year, l.startDate, l.endDate, l.leaseType
FROM Lease l
JOIN Vehicles v ON l.vehicleID = v.vehicleID;

--16Retrieve Details of Active Leases with Customer and Car Information
SELECT   v.vehicleID, v.make, v.model, v.year,  l.leaseID, l.leaseType
 FROM vehicles AS v
JOIN  lease AS l ON v.vehicleID = l.vehicleID
JOIN customer AS c ON l.customerID = c.customerID
WHERE GETDATE() BETWEEN l.startDate AND l.endDate;

select * from lease


--17. Find the Customer Who Has Spent the Most on Leases
SELECT TOP 1 C.*, P.amount
FROM Customer AS C
JOIN Lease AS L ON C.customerID = L.customerID
JOIN Payment AS P ON L.leaseID = P.leaseID
ORDER BY P.amount DESC;


--18List All Cars with Their Current Lease Information
SELECT v.vehicleID, v.make, v.model, v.year, l.leaseID,  l.leaseType, c.firstName, c.lastName
FROM vehicles AS v
JOIN lease AS l ON v.vehicleID = l.vehicleID
JOIN customer AS c ON l.customerID = c.customerID
WHERE GETDATE() BETWEEN l.startDate AND l.endDate;
