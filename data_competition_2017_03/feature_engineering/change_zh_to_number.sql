--# this index_city_name can avoid Duplicate index name
create INDEX index_city_name on feature_user_pay_and_shop_info_and_holiday_and_weather (city_name(20));

delimiter $$ 
drop procedure  if exists wk;
create procedure wk()
begin 
declare i int;
set i = 0;
while i < (select count(distinct city_name) from feature_user_pay_and_shop_info_and_holiday_and_weather) do 
update feature_user_pay_and_shop_info_and_holiday_and_weather set city_name=i where city_name=(select distinct city_name from (select city_name from feature_user_pay_and_shop_info_and_holiday_and_weather)a limit i,1);
set i = i+1;
end while;
end $$
delimiter ;
call wk();
