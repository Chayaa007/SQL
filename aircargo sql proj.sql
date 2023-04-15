create database  aircargo_29;
show databases;
use aircargo_29;
show tables;

create table route_details(route_id int primary key, 
flight_num int not null check (flight_num > 0),
origin_airport char(3) not null,
destination_airport char(3) not null, 
aircraft_id varchar(20) not null,
distance_miles smallint not null check(distance_miles > 0)
);

desc route_details;
select * from route_details limit 10;

#3.	Write a query to display all the passengers
# who have travelled in routes 01 to 25 from the passengers_on_flights table.

select p.customer_id,
concat_ws(" ",c.first_name,c.last_name ) as name ,
p.aircraft_id,
p.route_id,
p.depart,
p.arrival,
p.seat_num,
p.class_id,
p.travel_date,
p.flight_num
from passengers_on_flights as p
inner join customer as c using(customer_id)
where p.route_id between 01 and 25; 

#4 Write a query to identify the number of passengers 
# and total revenue in business class from the ticket_details table.

select count(customer_id) as customers,
sum(no_of_tickets * Price_per_ticket) as total_revenue
from ticket_details 
where  class_id="Bussiness";

#5.	Write a query to display the full name of the customer
# by extracting the first name and last name from the customer table.

select first_name,last_name,
concat_ws(" ",first_name,last_name)as full_name
from customer;

#6.	Write a query to extract the customers who have registered and booked 
# a ticket from the customer and ticket_details tables.

select c.* 
from customer as c
where exists (select customer_id from ticket as t
where t.customer_id = c.customer_id);

select c.* 
from customer as c
where c.customer_id in  (select distinct customer_id from ticket );


#7 Write a query to identify the customer’s first name and last name 
# based on their customer ID and brand (Emirates) from the ticket_details table

select distinct c.first_name,c.last_name
from customer as c
inner join ticket_details as t using(customer_id)
where t.brand="emirates";

#OR

select c.first_name, c.last_name
from customer as c
where exists (select customer_id from ticket_details as t
where t.customer_id = c.customer_id and
	t.brand = 'Emirates');
    
#8.	Write a query to identify the customers who have travelled more than once by Economy Plus class 
# using Group By and Having clause on the passengers_on_flights table

select c.first_name,c.last_name
from customer as c
inner join passengers_on_flights as p using(customer_id)
where p.class_id="Economy Plus"
group by c.customer_id
having(count( p.customer_id >1));

#9 Write a query to identify whether the revenue 
# has crossed 10000 using the IF clause on the ticket_details table

select 
sum(no_of_tickets * Price_per_ticket) as total_revenue,
if ((sum(no_of_tickets * Price_per_ticket)) > 10000,"revenue has crossed","not crossed ") as target
from ticket_details;

#11 Write a query to find the maximum ticket price for each class 
# using window functions on the ticket_details table.

select distinct class_id, max(price_per_ticket) over (partition by class_id)as max_price
from ticket_details
order by 2 desc;

select class_id, max(price_per_ticket)
from ticket_details
group by class_id
order by 2 desc;

#12 write a query to extract the passengers whose route ID is 4 
# by improving the speed and performance of the passengers_on_flights table.

select * from passengers_on_flights
where route_id = 4;

show indexes from passengers_on_flights;

#13 For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.
## Manually checking the query plan using 'explain' command

explain select * from passengers_on_flights
where route_id = 4;

#14 Write a query to calculate the total price of all tickets 
# booked by a customer across different aircraft IDs using rollup function.

select customer_id, aircraft_id, 
	sum(no_of_tickets * price_per_ticket) as total_price
from ticket_details
group by customer_id, aircraft_id with rollup;

#15 Write a query to create a view with only business class customers along with the brand of airlines. 

create view business_class_customers as
select concat_ws(' ', c.first_name, c.last_name) as 'name', t.class_id, t.brand  from customer c 
join ticket_details t
using (customer_id)
where t.class_id = 'Bussiness';

select * from business_class_customers;

#16 Write a query to create a stored procedure to get the details of all passengers flying between a range of routes defined in run time. 
# Also, return an error message if the table doesn't exist.

DELIMITER &&
CREATE PROCEDURE proced(in board varchar(5),in dest varchar(5))
BEGIN
select concat_ws(' ', c.first_name,c.last_name)as 'name',customer_id,route_id,depart,arrival,p.seta_num,p.class_id,p.travel_date
from passengers_on_flights p
join customer c
using(custome4r_id)
where depart=board and arrival=dast;
end &&
delimiter;

call proced('JFK','LAX') ;  

#OR

drop procedure if exists sp_get_pass_dtls;
delimiter $$
create procedure sp_get_pass_dtls(
in p_start int,
in p_end int,
out  p_err varchar(100))
begin
declare continue handler for 
sqlstate "42502"
select "sqlstate - table not found" as msg;
declare continue handler for 
sqlexception
begin 
get diagnostics condition1
@sqlstate = returned_sqlstate
@errorno=mysql_errno;
@text= message_text;
set @full_error = concar("sql exception handler - error", @errorno,
"(sql state)"
;

#17 Write a query to create a stored procedure that extracts 
# all the details from the routes table where the travelled distance is more than 2000 miles

DELIMITER &&
CREATE PROCEDURE proc_name1()
BEGIN
select * 
from route_details where distance_miles > 2000;
END &&
DELIMITER ;

call proc_name1() ;0

#18 Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. 
# The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles
# intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.

DELIMITER &&
CREATE PROCEDURE flight_distance1()
BEGIN
  SELECT distance_miles, 
    CASE
      WHEN distance_miles >= 0 AND distance_miles <= 2000 THEN 'Short Distance Travel (SDT)'
      WHEN distance_miles > 2000 AND distance_miles <= 6500 THEN 'Intermediate Distance Travel (IDT)'
      WHEN distance_miles > 6500 THEN 'Long-Distance Travel (LDT)'
    END AS category
  FROM route_details;
END &&
DELIMITER ;

call flight_distance1();


#19.	Write a query to extract ticket purchase date, customer ID, class ID and 
# specify if the complimentary services are provided for the specific class using a stored function in stored procedure on the ticket_details table. 
Condition: 
•	If the class is Business and Economy Plus, then complimentary services are given as Yes, else it is No

delimiter $$
 create function complimentary( com varchar(30)) 
 returns varchar(3) deterministic
begin
 declare complimentary varchar(30);
   if  (com = 'economy plus' or com= 'bussiness') then set complimentary = 'YES';
   else 
   set complimentary = 'NO';
   end if;
   return(complimentary);
end $$
delimiter ;

select p_date, customer_id, class_id,complimentary(class_id) as complimentary from ticket_details;
drop function if exists complimentary;

delimiter $$
create procedure complimentary1()
begin 
select p_date, customer_id, class_id,complimentary(class_id) as complimentary 
from ticket_details;
end $$
delimiter ;

call complimentary1() ;


