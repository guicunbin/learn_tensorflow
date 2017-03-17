drop table if exists avg_test_results_day_1 ;
drop table if exists avg_test_results_day_2 ;
drop table if exists avg_test_results_day_3 ;
drop table if exists avg_test_results_day_4 ;
drop table if exists avg_test_results_day_5 ;
drop table if exists avg_test_results_day_6 ;
drop table if exists avg_test_results_day_7 ;
drop table if exists avg_test_results_day_8 ;
drop table if exists avg_test_results_day_9 ;
drop table if exists avg_test_results_day_10;
drop table if exists avg_test_results_day_11;
drop table if exists avg_test_results_day_12;
drop table if exists avg_test_results_day_13;
drop table if exists avg_test_results_day_14;
drop table if exists test_results_merge_temp1;




create table if not exists avg_test_results_day_8 as 
select shop_id,
       avg(label_this_day) as label_this_day_8
from 
feature_and_label_weekday_0_to_6
where weekday_0_to_6=1 group by shop_id ;
--# because select weekday("2016-11-01") = 1

create INDEX index0 on avg_test_results_day_8 (shop_id);


create table if not exists avg_test_results_day_9 as 
select shop_id,
       avg(label_this_day) as label_this_day_9
from 
feature_and_label_weekday_0_to_6
where weekday_0_to_6=2 group by shop_id;

create INDEX index0 on avg_test_results_day_9 (shop_id);


create table if not exists avg_test_results_day_10 as 
select shop_id,
       avg(label_this_day) as label_this_day_10
from 
feature_and_label_weekday_0_to_6
where weekday_0_to_6=3 group by shop_id;

create INDEX index0 on avg_test_results_day_10 (shop_id);


create table if not exists avg_test_results_day_11 as 
select shop_id,
       avg(label_this_day) as label_this_day_11
from 
feature_and_label_weekday_0_to_6
where weekday_0_to_6=4 group by shop_id;

create INDEX index0 on avg_test_results_day_11 (shop_id);


create table if not exists avg_test_results_day_12 as 
select shop_id,
       avg(label_this_day) as label_this_day_12
from 
feature_and_label_weekday_0_to_6
where weekday_0_to_6=5 group by shop_id;

create INDEX index0 on avg_test_results_day_12 (shop_id);


create table if not exists avg_test_results_day_13 as 
select shop_id,
       avg(label_this_day) as label_this_day_13
from 
feature_and_label_weekday_0_to_6
where weekday_0_to_6=6 group by shop_id;

create INDEX index0 on avg_test_results_day_13 (shop_id);


create table if not exists avg_test_results_day_14 as 
select shop_id,
       avg(label_this_day) as label_this_day_14
from 
feature_and_label_weekday_0_to_6
where weekday_0_to_6=0 group by shop_id;

create INDEX index0 on avg_test_results_day_14 (shop_id);


create table if not exists test_results_shop_id as 
select distinct shop_id from shop_info_new;


create table if not exists test_results_merge_temp1 as 
select a.shop_id,
       case when label_this_day_8    is null then 132 else cast(label_this_day_8  as unsigned) end as label_this_day_1 ,
       case when label_this_day_9    is null then 132 else cast(label_this_day_9  as unsigned) end as label_this_day_2 ,
       case when label_this_day_10   is null then 132 else cast(label_this_day_10 as unsigned) end as label_this_day_3 ,
       case when label_this_day_11   is null then 132 else cast(label_this_day_11 as unsigned) end as label_this_day_4 ,
       case when label_this_day_12   is null then 132 else cast(label_this_day_12 as unsigned) end as label_this_day_5 ,
       case when label_this_day_13   is null then 132 else cast(label_this_day_13 as unsigned) end as label_this_day_6 ,
       case when label_this_day_14   is null then 132 else cast(label_this_day_14 as unsigned) end as label_this_day_7 ,
       case when label_this_day_8    is null then 132 else cast(label_this_day_8  as unsigned) end as label_this_day_8 ,
       case when label_this_day_9    is null then 132 else cast(label_this_day_9  as unsigned) end as label_this_day_9 ,
       case when label_this_day_10   is null then 132 else cast(label_this_day_10 as unsigned) end as label_this_day_10,
       case when label_this_day_11   is null then 132 else cast(label_this_day_11 as unsigned) end as label_this_day_11,
       case when label_this_day_12   is null then 132 else cast(label_this_day_12 as unsigned) end as label_this_day_12,
       case when label_this_day_13   is null then 132 else cast(label_this_day_13 as unsigned) end as label_this_day_13,
       case when label_this_day_14   is null then 132 else cast(label_this_day_14 as unsigned) end as label_this_day_14
	from
    test_results_shop_id a
--#left outer join 是以左边的表为基准进行匹配，后面的没有匹配上的就把它值为null
--#		test_results_day_1 b  
--#		on a.shop_id=b.shop_id
--#	left outer join
--#		test_results_day_2 c  
--#		on a.shop_id=c.shop_id
--#	left outer join
--#		test_results_day_3 d 
--#		on a.shop_id=d.shop_id
--#	left outer join
--#		test_results_day_4 e
--#		on a.shop_id=e.shop_id
--#	left outer join
--#		test_results_day_5 f
--#		on a.shop_id=f.shop_id
--#	left outer join
--#		test_results_day_6 g
--#		on a.shop_id=g.shop_id
--#	left outer join
--#		test_results_day_7 g1
--#		on a.shop_id=g1.shop_id
	left outer join
		avg_test_results_day_8 g2
		on a.shop_id=g2.shop_id
	left outer join
		avg_test_results_day_9 g3
		on a.shop_id=g3.shop_id
	left outer join
		avg_test_results_day_10 g4
		on a.shop_id=g4.shop_id
	left outer join
		avg_test_results_day_11 g5
		on a.shop_id=g5.shop_id
	left outer join
		avg_test_results_day_12 g6
		on a.shop_id=g6.shop_id
	left outer join
		avg_test_results_day_13 g7
		on a.shop_id=g7.shop_id
	left outer join
		avg_test_results_day_14 g8
		on a.shop_id=g8.shop_id;

update test_results_merge_temp1 set label_this_day_1  = 132 where label_this_day_1  > 5000 ;
update test_results_merge_temp1 set label_this_day_2  = 132 where label_this_day_2  > 5000 ;
update test_results_merge_temp1 set label_this_day_3  = 132 where label_this_day_3  > 5000 ;
update test_results_merge_temp1 set label_this_day_4  = 132 where label_this_day_4  > 5000 ;
update test_results_merge_temp1 set label_this_day_5  = 132 where label_this_day_5  > 5000 ;
update test_results_merge_temp1 set label_this_day_6  = 132 where label_this_day_6  > 5000 ;
update test_results_merge_temp1 set label_this_day_7  = 132 where label_this_day_7  > 5000 ;
update test_results_merge_temp1 set label_this_day_8  = 132 where label_this_day_8  > 5000 ;
update test_results_merge_temp1 set label_this_day_9  = 132 where label_this_day_9  > 5000 ;
update test_results_merge_temp1 set label_this_day_10 = 132 where label_this_day_10 > 5000 ;
update test_results_merge_temp1 set label_this_day_11 = 132 where label_this_day_11 > 5000 ;
update test_results_merge_temp1 set label_this_day_12 = 132 where label_this_day_12 > 5000 ;
update test_results_merge_temp1 set label_this_day_13 = 132 where label_this_day_13 > 5000 ;
update test_results_merge_temp1 set label_this_day_14 = 132 where label_this_day_14 > 5000 ;


select * from test_results_merge_temp1 
into outfile "/var/lib/mysql-files/test_results_merge_temp1.csv" 
FIELDS TERMINATED BY ','   
OPTIONALLY ENCLOSED BY '"'   
LINES TERMINATED BY '\n';


