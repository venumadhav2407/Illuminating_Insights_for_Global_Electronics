-- create database global_electronic;
use global_electronic;
-- Database
create table if not exists customer 
(
	customerkey int primary key ,
    gender varchar(10) not null,
    name varchar(50) not null,
    city varchar(100) not null,
    state varchar(70) not null,
    country varchar(30) not null,
    continent varchar(30) not null,
    birthday date not null
) ;




-- product Table
create table if not exists product
(
		productkey int primary key ,
        product_name varchar(255) not null,
        brand varchar(20) not null,
        color varchar(15) not null,
        unit_cost_usd decimal(10,2) not null,
        unit_price_usd decimal(10,2) not null,
        subcategory varchar(45) not null,
        categorykey int not null,
        category varchar(60) not null
);


-- store Table
create table if not exists store 
(
    storekey int primary key ,
    country varchar(30) not null,
    state varchar(70) not null,
    square_meters decimal(10,1) not null,
    open_date date not null
);


-- Exchange Rate Table
create table if not exists exchange_rate 
(
	date_ date not null,
    currency_code varchar(5) not null,
    exchange decimal(10, 4) not null
);



-- Sales Table
create table if not exists sales 
(
    order_id int not null ,
    line_item int not null,
    order_date date ,
    delivery_date date ,
    customerkey int not null,
    storekey int not null,
    productkey int not null,
    quantity int not null,
    currency_code varchar(10) not null,
    
    foreign key (customerkey) references customer(customerkey),
    foreign key (storekey) references store(storekey),
    foreign key (productkey) references product(productkey)

);

SET SQL_SAFE_UPDATES = 0;

update sales set delivery_date = null where  delivery_date = '0001-01-01';

