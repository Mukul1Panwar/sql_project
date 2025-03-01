create database p_1;
use p_1;

create table retail_sales (
   transactions_id int primary key,
   sale_date date,
   sale_time time,
   customer_id	int,
   gender varchar(15),
   age	int,
   category	varchar(15),
   quantity	int,
   price_per_unit int,	
   cogs float,
   total_sale int
);

select * from retail_sales limit 100;
select * from retail_sales where transactions_id is null;
select * from retail_sales where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null;

select * from retail_sales;

# unique cusomer
select count(customer_id) as total_customer from retail_sales;
select count(distinct customer_id) from retail_sales;

select distinct category from retail_sales;

# analysis
# sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05';
select sum(total_sale) from retail_sales where sale_date = '2022-11-05';

# all transaction where cat. is 'clothing' and quantity > 10 in month of nov-2022
select * from retail_sales where category = 'clothing'
and quantiy>=4
and sale_date  between '2022-11-01' and '2022-11-30';

# calculate the total_sales for each category.
select category,sum(total_sale),count(*) from retail_sales group by 1;

# avg. age of customers who purchased items from the 'beauty' cat.
select avg(age) from retail_sales where category = 'Beauty';

# all transaction where total_sale > 1000
select count(*) from retail_sales where total_sale>1000;

# total no. of transaction made by each gender in each category
select gender,category,count(transactions_id) from retail_sales group by 1 ,2 order by category;

# avg. sale for each month, find out the best selling month in each year
select year(sale_date),month(sale_date),avg(total_sale) from retail_sales group by 1,2 order by 1,3 desc;

# top 5 customer based on highest total sales
select customer_id,sum(total_sale) from retail_sales group by 1 order by 2 desc limit 5;

# find the number(count) of unique customers who purchased items from each cat.
select category,count(distinct customer_id) from retail_sales group by category;

# create each shift and no. of orders (ex: morning<=12 afternoon b/w 12 & 17 evening>17)
select case 
when hour(sale_time)<=12 then 'morning'
when hour(sale_time) between 12 and 17 then 'afternoon' 
else 'evening'
end as shift,
count(hour(sale_time)) from retail_sales group by shift;