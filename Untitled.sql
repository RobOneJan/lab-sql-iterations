#Write a query to find what is the total business done by each store.



drop if exists 

select s.store_id, sum(p.amount) from store as s
join staff as st
using(store_id)
join payment as p 
using (staff_id)
group by s.store_id;

# convert the previous query into a stored procedure.
drop procedure if exists store_payments;

delimiter //
create procedure store_payments (in id int, out total_sales_value float)
begin   
 
#declare total_sales_value float default 10.0;

select sum(p.amount) as amount into total_sales_value  

from store as s
join staff as st
	on s.store_id=st.store_id
join payment as p
	on st.staff_id=p.staff_id
group by s.store_id
having store_id = id
 ; 
 
#select total_sales_value;
#set  total_sales_value = 10.0;
end
//
delimiter ;

call store_payments(2,@x);

select @x as storerevenue;



drop procedure if exists store_flag;
delimiter //
create procedure store_flag (in store_input integer,out total_sales_value float, out flag varchar(20))
begin


select sum(p.amount) into total_sales_value
from store as s
join staff as st
	on s.store_id=st.store_id
join payment as p
	on st.staff_id=p.staff_id
where s.store_id = store_input
group by s.store_id;
case
	when total_sales_value > 30000 then
		set flag = 'green';
	else
		set flag = 'red';
  end case;  
  select flag into flag;
    
end;
//
delimiter ;

call store_flag(1, @x, @d);

select round(@x,2) as revenue ,@d as flag;
