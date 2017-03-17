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
       user_pay_day_shop_id_cnt_no_distinct+10 as label_this_day_8
from 
feature_user_pay_6
where pay_day="2016-10-25";

create INDEX index0 on avg_test_results_day_8 (shop_id);


create table if not exists avg_test_results_day_9 as 
select shop_id,
       user_pay_day_shop_id_cnt_no_distinct+10 as label_this_day_9
from 
feature_user_pay_6
where pay_day="2016-10-26";

create INDEX index0 on avg_test_results_day_9 (shop_id);


create table if not exists avg_test_results_day_10 as 
select shop_id,
       user_pay_day_shop_id_cnt_no_distinct+10 as label_this_day_10
from 
feature_user_pay_6
where pay_day="2016-10-27";

create INDEX index0 on avg_test_results_day_10 (shop_id);


create table if not exists avg_test_results_day_11 as 
select shop_id,
       user_pay_day_shop_id_cnt_no_distinct+10 as label_this_day_11
from 
feature_user_pay_6
where pay_day="2016-10-28";

create INDEX index0 on avg_test_results_day_11 (shop_id);


create table if not exists avg_test_results_day_12 as 
select shop_id,
       user_pay_day_shop_id_cnt_no_distinct+10 as label_this_day_12
from 
feature_user_pay_6
where pay_day="2016-10-29";

create INDEX index0 on avg_test_results_day_12 (shop_id);


create table if not exists avg_test_results_day_13 as 
select shop_id,
       user_pay_day_shop_id_cnt_no_distinct+10 as label_this_day_13
from 
feature_user_pay_6
where pay_day="2016-10-30";

create INDEX index0 on avg_test_results_day_13 (shop_id);


create table if not exists avg_test_results_day_14 as 
select shop_id,
       user_pay_day_shop_id_cnt_no_distinct+10 as label_this_day_14
from 
feature_user_pay_6
where pay_day="2016-10-31";

create INDEX index0 on avg_test_results_day_14 (shop_id);


create table if not exists test_results_shop_id as 
select distinct shop_id from shop_info_new;


create table if not exists test_results_merge_temp1 as 
select a.shop_id,
       case when label_this_day_8    is null then 0 else cast(label_this_day_8  as unsigned) end as label_this_day_1 ,
       case when label_this_day_9    is null then 0 else cast(label_this_day_9  as unsigned) end as label_this_day_2 ,
       case when label_this_day_10   is null then 0 else cast(label_this_day_10 as unsigned) end as label_this_day_3 ,
       case when label_this_day_11   is null then 0 else cast(label_this_day_11 as unsigned) end as label_this_day_4 ,
       case when label_this_day_12   is null then 0 else cast(label_this_day_12 as unsigned) end as label_this_day_5 ,
       case when label_this_day_13   is null then 0 else cast(label_this_day_13 as unsigned) end as label_this_day_6 ,
       case when label_this_day_14   is null then 0 else cast(label_this_day_14 as unsigned) end as label_this_day_7 ,
       case when label_this_day_8    is null then 0 else cast(label_this_day_8  as unsigned) end as label_this_day_8 ,
       case when label_this_day_9    is null then 0 else cast(label_this_day_9  as unsigned) end as label_this_day_9 ,
       case when label_this_day_10   is null then 0 else cast(label_this_day_10 as unsigned) end as label_this_day_10,
       case when label_this_day_11   is null then 0 else cast(label_this_day_11 as unsigned) end as label_this_day_11,
       case when label_this_day_12   is null then 0 else cast(label_this_day_12 as unsigned) end as label_this_day_12,
       case when label_this_day_13   is null then 0 else cast(label_this_day_13 as unsigned) end as label_this_day_13,
       case when label_this_day_14   is null then 0 else cast(label_this_day_14 as unsigned) end as label_this_day_14
	from
    test_results_shop_id a
	left outer join
		avg_test_results_day_8  g2
		on a.shop_id=g2.shop_id
	left outer join
		avg_test_results_day_9  g3
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



update test_results_merge_temp1 set label_this_day_1  = 0 where label_this_day_1  > 5000 ;
update test_results_merge_temp1 set label_this_day_2  = 0 where label_this_day_2  > 5000 ;
update test_results_merge_temp1 set label_this_day_3  = 0 where label_this_day_3  > 5000 ;
update test_results_merge_temp1 set label_this_day_4  = 0 where label_this_day_4  > 5000 ;
update test_results_merge_temp1 set label_this_day_5  = 0 where label_this_day_5  > 5000 ;
update test_results_merge_temp1 set label_this_day_6  = 0 where label_this_day_6  > 5000 ;
update test_results_merge_temp1 set label_this_day_7  = 0 where label_this_day_7  > 5000 ;
update test_results_merge_temp1 set label_this_day_8  = 0 where label_this_day_8  > 5000 ;
update test_results_merge_temp1 set label_this_day_9  = 0 where label_this_day_9  > 5000 ;
update test_results_merge_temp1 set label_this_day_10 = 0 where label_this_day_10 > 5000 ;
update test_results_merge_temp1 set label_this_day_11 = 0 where label_this_day_11 > 5000 ;
update test_results_merge_temp1 set label_this_day_12 = 0 where label_this_day_12 > 5000 ;
update test_results_merge_temp1 set label_this_day_13 = 0 where label_this_day_13 > 5000 ;
update test_results_merge_temp1 set label_this_day_14 = 0 where label_this_day_14 > 5000 ;


create INDEX index0 on avg_label_of_every_shop (shop_id);
create INDEX index0 on test_results_merge_temp1 (shop_id);


UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_1 = t2.avg_label  
                                 WHERE t1.label_this_day_1 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_2 = t2.avg_label  
                                 WHERE t1.label_this_day_2 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_3 = t2.avg_label  
                                 WHERE t1.label_this_day_3 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_4 = t2.avg_label  
                                 WHERE t1.label_this_day_4 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_5 = t2.avg_label  
                                 WHERE t1.label_this_day_5 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_6 = t2.avg_label  
                                 WHERE t1.label_this_day_6 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_7 = t2.avg_label  
                                 WHERE t1.label_this_day_7 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_8 = t2.avg_label  
                                 WHERE t1.label_this_day_8 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_9 = t2.avg_label  
                                 WHERE t1.label_this_day_9 < 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_10= t2.avg_label  
                                 WHERE t1.label_this_day_10< 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_11= t2.avg_label  
                                 WHERE t1.label_this_day_11< 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_12= t2.avg_label  
                                 WHERE t1.label_this_day_12< 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_13= t2.avg_label  
                                 WHERE t1.label_this_day_13< 10;
UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
        ON t1.shop_id = t2.shop_id set t1.label_this_day_14= t2.avg_label  
                                 WHERE t1.label_this_day_14< 10;





select * from test_results_merge_temp1 
into outfile "/var/lib/mysql-files/test_results_merge_temp1.csv" 
FIELDS TERMINATED BY ','   
OPTIONALLY ENCLOSED BY '"'   
LINES TERMINATED BY '\n';


