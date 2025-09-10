create table Customers(
Customer_ID int primary key,
Name varchar(100),
Email varchar(200) unique,
Phone varchar(15) not null,
City varchar(100),
Country varchar(100)
);

create table books(
Book_ID int primary key,
Title varchar(200),
Author varchar(200),
Genre varchar(100),
Published_Year int,
Price float,
Stock int
);

create table Orders(
Order_ID int primary key,
Customer_ID int,
Book_ID int,
Order_Date date,
Quantity int,
Total_Amount float,
foreign key (Customer_ID) references Customers(Customer_ID),
foreign key (Book_ID) references books(Book_ID)
);

--Find the most recent order placed by each customer.
select distinct(c.name),max(o.order_date) from customers c join orders o on c.customer_id = o.customer_id group by 1;

--Rank customers by their total spending (highest to lowest).
select c.name,sum(o.total_amount),
rank() over(order by sum(o.total_amount) desc) as rank
from customers c join orders o on c.customer_id = o.customer_id group by 1;

--Find the total number of orders placed by each customer.
select c.name,count(order_id),sum(o.Total_Amount) from customers c join orders o on c.customer_id = o.customer_id group by 1 order by 2 desc;

--Get a combined list of all Cities and Countries from Customers.
select city from customers
union
select country from customers;

--Show the titles and prices of all books published after 2010.
select title,price,Published_Year from books where Published_Year>2010 order by 3 asc;

--Retrieve all books with their order details, including books that were never ordered.
select b.book_id,b.title,b.genre,o.order_id from books b left join orders o on b.book_id = o.book_id;

--Grant SELECT permission on Books to user analyst.
grant select on books to analyst;

--Revoke that permission.
revoke select on books from analyst;

--Find customers who spent more than the average total order amount.
select c.name,sum(o.total_amount),avg(o.total_amount) from customers c join orders o on c.customer_id = o.customer_id  group by c.name
having sum(o.total_amount) > (select avg(total_amount) from orders);

--Find customers whose email ends with ‘@yahoo.com’.
select * from customers where email like '%@yahoo.com';

--Delete all orders before 2023.
select * from orders_backup where extract(year from order_date)<2023;

--Create a copy of the Orders table as Orders_Backup.
create table orders_backup as
select * from orders;

--Categorize books based on price: "Cheap" (<20), "Moderate" (20–40), "Expensive" (>40).
select title,price,
case when price<20 then 'Cheap' 
when price between 20 and 40 then 'Moderate'
else 'Expensive' end as price_category
from books;

--Retrieve books that are either priced below 20 OR belong to the genre “Fantasy”.
select * from books where price<20 or genre = 'Fantasy';

--Drop the column Phone from Customers.
alter table customers drop loyalty_status;

--Add a column Loyalty_Status to Customers.
alter table customers add loyalty_status varchar(100)

--Find each customer’s total spending and rank them by highest spender.
select c.name,sum(o.total_amount),
rank() over(order by sum(o.total_amount) desc) as rank from customers c join orders o on c.customer_id = o.customer_id group by 1;


--Create a view showing the top 5 most expensive books.
create view view1 as 
select b.Title,o.Total_Amount from books b join orders o on b.book_id = o.book_id order by 2 desc limit 5;
select * from view1;

--Retrieve all books with their order details, including books that were never ordered.
select b.Book_ID,b.Title,b.Author,b.Genre,o.Order_id,o.Order_Date,o.Quantity,o.Total_Amount from books b join Orders o on o.Book_ID = b.Book_ID;

--List all unique cities and countries from Customers as a single column.
with ttable as (
select city from customers
union
select country from customers)
select count(*) from ttable;

--Retrieve all orders with customer names, including customers who have never placed an order.
select o.Order_ID,c.Name from Customers c left join Orders o on c.Customer_ID = o.Customer_ID;





select * from customers;
select * from books;
select * from orders;

