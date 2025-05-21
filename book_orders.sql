CREATE TABLE books(
	Books_id int PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre Varchar(50),
	Published_Year INT,
	Price float(10),
	Stock INT
);
CREATE TABLE customers(
	Customer_id int PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);
CREATE TABLE orders(
	Order_id int PRIMARY KEY,
	Customer_id int  ,
	Books_id INT ,
	Order_Date DATE,
	Quantity INT,
	Total_Amount FLOAT(10),
	foreign key (Customer_id) references customers(Customer_id),
	foreign key (Books_id) REFERENCES books(Books_id)
);

--1) REtrieve all books in the "FICTION" genre:
select * from books where genre = 'Fiction';

--2) Find books published after the year 1950:
select * from books where published_year>1950 order by published_year asc;

--3) List all the customers from the canada:
select * from customers where country = 'Canada';

--4) Show the order placed in november 2023:
select * from orders where extract(year from order_date) = 2023 and extract(MONTH from order_date) = 11;

--5) Retrieve the total stock of books available:
select sum(stock) from books;

--6) Find the Most expensive books:
select * from books order by price desc limit 1;

--7) show all customers who order more than 1 quantity of a book:
select c.name,o.quantity from customers c join orders o on c.customer_id = o.customer_id where o.quantity>1; 

--8) Retrive all prger where the total amount exceeds $20:
select * from orders WHERE total_amount>20;

--9) lsit all genre available in the books table:
select distinct genre from books;

--10) Find the book with the lowest stock:
select * from books order by stock asc limit 1;

--11) calculate the total revenue generated from all orders:
select sum(total_amount) from orders;

--ADVANCED QUERY

--1) Retrieve the total number of books sold for each genre:
select distinct(b.genre),sum(o.quantity) from books b join orders o on o.books_id = b.books_id group by 1; 

--2  FInd the average price of books in the "Fantasy" genre:
select genre,avg(price) from books where genre = 'Fantasy' group by 1;

--3) List customers who have placed at least 2 orders:
select * from customers c join orders o on o.customer_id = c.customer_id where o.quantity >= 2;

--5) show the top 3 most expensive books of 'Fantasy' Genre:
select * from books where genre = 'Fantasy' order by price DESC limit 3;

--6) Retrieve the total quantity of books sold by each author:
select distinct author , count(*) from books GROUP by 1 order by 2 desc ;

--7) list the cities where customers who spent over $30 are located:
select c.city,o.total_amount from customers c join orders o on o.customer_id = c.customer_id where o.total_amount<=30;

--8) Find the customer who spent the most on orders:
select c.name,sum(o.total_amount) from customers c join orders o on o.customer_id = c.customer_id GROUP by 1 order by 2 desc limit 1;

--9) calculate the stock remaining after fufilling all orders:
select b.books_id,b.stock,o.quantity,b.stock-o.quantity as remaining from books b join orders o on o.books_id = b.books_id GROUP by 1,3;



select * from orders;
select * from customers;
select * from books;
