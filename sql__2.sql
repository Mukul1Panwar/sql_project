CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    City VARCHAR(50),
    Country VARCHAR(50)
);

INSERT INTO Customers (CustomerID, FirstName, LastName, City, Country) VALUES
(1, 'Alice', 'Johnson', 'New York', 'USA'),
(2, 'Bob', 'Williams', 'Los Angeles', 'USA'),
(3, 'Charlie', 'Brown', 'London', 'UK'),
(4, 'Diana', 'Miller', 'Paris', 'France'),
(5, 'Eve', 'Davis', 'Tokyo', 'Japan'),
(6, 'Frank', 'Wilson', 'New York', 'USA'),
(7, 'Grace', 'Moore', 'London', 'UK'),
(8, 'Henry', 'Taylor', 'Berlin', 'Germany'),
(9, 'Ivy', 'Anderson', 'Los Angeles', 'USA'),
(10, 'Jack', 'Thomas', 'Rome', 'Italy');

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    OrderStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, OrderStatus) VALUES
(101, 1, '2025-05-10', 150.00, 'Shipped'),
(102, 2, '2025-05-12', 220.50, 'Delivered'),
(103, 1, '2025-05-15', 75.00, 'Pending'),
(104, 3, '2025-05-18', 310.75, 'Shipped'),
(105, 4, '2025-05-20', 95.20, 'Delivered'),
(106, 2, '2025-05-21', 185.99, 'Processing'),
(107, 5, '2025-05-22', 45.00, 'Pending'),
(108, 3, '2025-05-22', 120.00, 'Shipped'),
(109, 6, '2025-05-11', 55.60, 'Delivered'),
(110, 7, '2025-05-16', 280.40, 'Processing');

CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Nationality VARCHAR(50)
);

INSERT INTO Authors (AuthorID, FirstName, LastName, Nationality) VALUES
(1, 'J.R.R.', 'Tolkien', 'British'),
(2, 'George', 'Orwell', 'British'),
(3, 'Jane', 'Austen', 'British'),
(4, 'Gabriel', 'Garcia Marquez', 'Colombian'),
(5, 'Haruki', 'Murakami', 'Japanese'),
(6, 'Chinua', 'Achebe', 'Nigerian'),
(7, 'Virginia', 'Woolf', 'British'),
(8, 'Isabel', 'Allende', 'Chilean'),
(9, 'Fyodor', 'Dostoevsky', 'Russian'),
(10, 'Toni', 'Morrison', 'American');

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    Genre VARCHAR(50),
    PublicationYear INT,
    Price DECIMAL(8, 2),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

INSERT INTO Books (BookID, Title, AuthorID, Genre, PublicationYear, Price) VALUES
(1, 'The Lord of the Rings', 1, 'Fantasy', 1954, 25.99),
(2, 'Nineteen Eighty-Four', 2, 'Dystopian', 1949, 12.50),
(3, 'Pride and Prejudice', 3, 'Romance', 1813, 9.75),
(4, 'One Hundred Years of Solitude', 4, 'Magical Realism', 1967, 18.20),
(5, 'Norwegian Wood', 5, 'Fiction', 1987, 14.00),
(6, 'Things Fall Apart', 6, 'African Literature', 1958, 11.99),
(7, 'To the Lighthouse', 7, 'Modernist', 1927, 10.50),
(8, 'The House of the Spirits', 8, 'Magical Realism', 1982, 16.75),
(9, 'Crime and Punishment', 9, 'Psychological Fiction', 1866, 15.30),
(10, 'Beloved', 10, 'Historical Fiction', 1987, 13.99),
(11, 'The Hobbit', 1, 'Fantasy', 1937, 19.50),
(12, 'Animal Farm', 2, 'Allegory', 1945, 8.99);

--List all customers and their order IDs (if they have any):
select c.firstname,o.orderid from customers c join orders o on o.customerid = c.customerid;

--Find the total number of orders placed by each customer:
select c.firstname,count(o.orderid) as total_orders from customers c left join orders o on o.customerid = c.customerid group by c.customerid,1;

--Get the average order amount for customers in the 'USA':
select c.firstname,round(avg(o.totalamount),2) from customers c LEFT join orders o on o.customerid = c.customerid where c.country = 'USA' group by 1;

--Find all orders placed in May 2025 with a 'Pending' status:
SELECT orderid,orderdate,orderstatus from orders where extract(month from orderdate)=5 and orderstatus = 'Pending';

--List the top 3 highest value orders:
select * from orders order by totalamount desc limit 3;

--List all book titles and their authors' full names:
select a.firstname,a.lastname,b.title from authors a join books b on b.authorid = a.authorid;

--Find the number of books written by each author:
select a.firstname,a.lastname,count(b.title) from authors a join books b on b.authorid = a.authorid group by 1,2 order by 3 DESC;

--Get the average price of books in each genre:
SELECT genre,round(avg(price),2) from books GROUP by 1;

--For each customer, show their order ID, order date, and the rank of the order based on the total amount
select c.firstname,o.orderid,o.orderdate,o.totalamount,
row_number() over (partition by c.customerid order by o.totalamount desc) as rank
from customers c join orders o on o.customerid = c.customerid;

--Within each genre, find the book with the highest price:
with ranked as (
select title,genre,price,
row_number() over(partition by genre order by price desc) rank from books)
select title,genre,price,rank from ranked where rank=1 order by price desc;

--Write a query to list the first and last names of customers from the Customers table who have not placed any orders in the Orders table.
select c.firstname,c.lastname,o.orderstatus from customers c left join orders o on o.customerid = c.customerid where o.orderstatus is null;

--Write a query to retrieve the customer's first name, last name, and the date of their most recent order.
select c.firstname,c.lastname,max(o.orderdate) from customers c join orders o on o.customerid = c.customerid group by 1,2 order by 3 desc;

--Write a query to find the first and last names of authors who have written more than one book.
SELECT a.firstname,a.lastname,count(b.authorid) from authors a join books b on b.authorid = a.authorid GROUP by 1,2 HAVING count(b.authorid)>1 ;

--Write a query to find the first and last names of customers who have placed orders where all of their orders have the status 'Delivered'.
select c.firstname,c.lastname,o.orderstatus from customers c join orders o on o.customerid = c.customerid where o.orderstatus = 'Delivered';




select * from customers;
select * from orders;
select * from books;
select * from authors;



