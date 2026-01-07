drop database if exists Th_db;
create database Th_db;
use Th_db;

create table customers (
    customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(10) not null unique
);
create table categories (
    category_id int primary key auto_increment,
    category_name varchar(255) not null unique
);
create table products (
    product_id int primary key auto_increment,
    product_name varchar(255) not null unique,
    price decimal(10,2) not null check (price > 0),
    category_id int not null,
    foreign key (category_id) references categories(category_id)
);
create table orders (
    order_id int primary key auto_increment,
    customer_id int not null,
    order_date datetime default current_timestamp,
    status enum('pending','completed','cancelled') default 'pending',
    foreign key (customer_id) references customers(customer_id)
);
create table order_items (
    order_item_id int primary key auto_increment,
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);
insert into customers (customer_name, email, phone) values
('nguyễn văn an','an@gmail.com','090000001'),
('trần thị bình','binh@gmail.com','090000002'),
('lê minh châu','chau@gmail.com','090000003'),
('phạm quốc dũng','dung@gmail.com','090000004'),
('hoàng thị em','em@gmail.com','090000005');
insert into categories (category_name) values
('điện thoại'),
('laptop'),
('phụ kiện');
insert into products (product_name, price, category_id) values
('iphone 15', 25000000, 1),
('samsung s23', 20000000, 1),
('macbook air', 30000000, 2),
('asus vivobook', 18000000, 2),
('tai nghe bluetooth', 1500000, 3),
('chuột không dây', 500000, 3);
insert into orders (customer_id, status) values
(1,'completed'),
(1,'completed'),
(2,'pending'),
(3,'completed'),
(4,'cancelled');
insert into order_items (order_id, product_id, quantity) values
(1,1,1),
(1,5,2),
(2,3,1),
(3,6,1),
(4,2,1),
(4,5,1);

select * from categories;
select * from orders
where status = 'completed';
select * from products
order by price desc;
select * from products
order by price desc
limit 5 offset 2;
select p.product_name,p.price,c.category_name
from products p
join categories c
on p.category_id = c.category_id;
select o.order_id,o.order_date,c.customer_name,o.status
from orders o
join customers c
on o.customer_id = c.customer_id;
select order_id,sum(quantity) as total_quantity
from order_items
group by order_id;
select c.customer_name,count(o.order_id) as total_orders
from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name;
select c.customer_name,count(o.order_id) as total_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(o.order_id) >= 2;
select c.category_name,avg(p.price) as avg_price,min(p.price) as min_price,max(p.price) as max_price
from products p
join categories c
on p.category_id = c.category_id
group by c.category_name;
select *
from products
where price > ( select avg(price)from products);
select *
from customers
where customer_id in (select customer_id from orders);
select *
from orders
where order_id = ( select order_id from order_items group by order_id order by sum(quantity) desc
limit 1
);
select distinct c.customer_name
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
where p.category_id = ( select category_id from products group by category_id order by avg(price) desc
limit 1
);
select customer_id, sum(total_quantity) as total_products
from ( select o.customer_id, sum(oi.quantity) as total_quantity from orders o
    join order_items oi
    on o.order_id = oi.order_id
    group by o.customer_id, o.order_id
) as temp
group by customer_id;
select *
from products
where price = ( select max(price) from products);
