drop table if exists avg_label_of_every_shop;
drop table if exists test_results_day_1 ;
drop table if exists test_results_day_2 ;
drop table if exists test_results_day_3 ;
drop table if exists test_results_day_4 ;
drop table if exists test_results_day_5 ;
drop table if exists test_results_day_6 ;
drop table if exists test_results_day_7 ;
drop table if exists test_results_day_8 ;
drop table if exists test_results_day_9 ;
drop table if exists test_results_day_10;
drop table if exists test_results_day_11;
drop table if exists test_results_day_12;
drop table if exists test_results_day_13;
drop table if exists test_results_day_14;
drop table if exists test_results_merge_temp1;


drop table if exists avg_label_of_every_shop;
create table  avg_label_of_every_shop as 
select shop_id,
weekday(pay_day) as  weekday_0_to_6,
avg(user_pay_day_shop_id_cnt_no_distinct) as avg_label from feature_user_pay 
where pay_day>="2016-07-01" and pay_day<="2016-10-31"
group by shop_id,weekday(pay_day);


create INDEX index0 on avg_label_of_every_shop (shop_id);
create INDEX index1 on avg_label_of_every_shop (avg_label);

create INDEX index0 on test_results_0 (shop_id);
create INDEX index1 on test_results_0 (pay_day);


create table if not exists test_results_day_1 as 
select shop_id,
       pay_day,label_test as label_test_day_1
from 
test_results_0
where pay_day="2016-11-01";

create INDEX index0 on     test_results_day_1 (shop_id);
create INDEX index1 on     test_results_day_1 (pay_day);

create table if not exists test_results_day_2 as 
select shop_id,
       pay_day,label_test as label_test_day_2
from 
test_results_0
where pay_day="2016-11-02";

create INDEX index0 on     test_results_day_2 (shop_id);
create INDEX index1 on     test_results_day_2 (pay_day);

create table if not exists test_results_day_3 as 
select shop_id,
       pay_day,label_test as label_test_day_3
from 
test_results_0
where pay_day="2016-11-03";

create INDEX index0 on     test_results_day_3 (shop_id);
create INDEX index1 on     test_results_day_3 (pay_day);

create table if not exists test_results_day_4 as 
select shop_id,
       pay_day,label_test as label_test_day_4
from 
test_results_0
where pay_day="2016-11-04";

create INDEX index0 on     test_results_day_4 (shop_id);
create INDEX index1 on     test_results_day_4 (pay_day);

create table if not exists test_results_day_5 as 
select shop_id,
       pay_day,label_test as label_test_day_5
from 
test_results_0
where pay_day="2016-11-05";

create INDEX index0 on     test_results_day_5 (shop_id);
create INDEX index1 on     test_results_day_5 (pay_day);

create table if not exists test_results_day_6 as 
select shop_id,
       pay_day,label_test as label_test_day_6
from 
test_results_0
where pay_day="2016-11-06";

create INDEX index0 on     test_results_day_6 (shop_id);
create INDEX index1 on     test_results_day_6 (pay_day);

create table if not exists test_results_day_7 as 
select shop_id,
       pay_day,label_test as label_test_day_7
from 
test_results_0
where pay_day="2016-11-07";

create INDEX index0 on     test_results_day_7 (shop_id);
create INDEX index1 on     test_results_day_7 (pay_day);


create table if not exists test_results_day_8 as 
select shop_id,
       pay_day,label_test as label_test_day_8
from 
test_results_0
where pay_day="2016-11-08";

create INDEX index0 on     test_results_day_8 (shop_id);
create INDEX index1 on     test_results_day_8 (pay_day);


create table if not exists test_results_day_9 as 
select shop_id,
       pay_day,label_test as label_test_day_9
from 
test_results_0
where pay_day="2016-11-09";

create INDEX index0 on test_results_day_9 (shop_id);
create INDEX index1 on     test_results_day_9 (pay_day);


create table if not exists test_results_day_10 as 
select shop_id,
       pay_day,label_test as label_test_day_10
from 
test_results_0
where pay_day="2016-11-10";

create INDEX index0 on test_results_day_10 (shop_id);
create INDEX index1 on     test_results_day_10 (pay_day);


create table if not exists test_results_day_11 as 
select shop_id,
       pay_day,label_test as label_test_day_11
from 
test_results_0
where pay_day="2016-11-11";

create INDEX index0 on test_results_day_11 (shop_id);
create INDEX index1 on     test_results_day_11  (pay_day);


create table if not exists test_results_day_12 as 
select shop_id,
       pay_day,label_test as label_test_day_12
from 
test_results_0
where pay_day="2016-11-12";

create INDEX index0 on test_results_day_12 (shop_id);
create INDEX index1 on     test_results_day_12  (pay_day);


create table if not exists test_results_day_13 as 
select shop_id,
       pay_day,label_test as label_test_day_13
from 
test_results_0
where pay_day="2016-11-13";

create INDEX index0 on test_results_day_13 (shop_id);
create INDEX index1 on     test_results_day_13  (pay_day);


create table if not exists test_results_day_14 as 
select shop_id,
       pay_day,label_test as label_test_day_14
from 
test_results_0
where pay_day="2016-11-14";

create INDEX index0 on test_results_day_14 (shop_id);
create INDEX index1 on     test_results_day_14  (pay_day);


create table if not exists test_results_shop_id as 
select distinct shop_id from shop_info_new;



create table if not exists test_results_merge_temp1 as 
select a.shop_id,
       case when label_test_day_1   is null or label_test_day_1  >10000 then -10000   else ceiling(label_test_day_1 ) end as label_test_day_1 ,
       case when label_test_day_2   is null or label_test_day_2  >10000 then -10000   else ceiling(label_test_day_2 ) end as label_test_day_2 ,
       case when label_test_day_3   is null or label_test_day_3  >10000 then -10000   else ceiling(label_test_day_3 ) end as label_test_day_3 ,
       case when label_test_day_4   is null or label_test_day_4  >10000 then -10000   else ceiling(label_test_day_4 ) end as label_test_day_4 ,
       case when label_test_day_5   is null or label_test_day_5  >10000 then -10000   else ceiling(label_test_day_5 ) end as label_test_day_5 ,
       case when label_test_day_6   is null or label_test_day_6  >10000 then -10000   else ceiling(label_test_day_6 ) end as label_test_day_6 ,
       case when label_test_day_7   is null or label_test_day_7  >10000 then -10000   else ceiling(label_test_day_7 ) end as label_test_day_7 ,
       case when label_test_day_8   is null or label_test_day_8  >10000 then -10000   else ceiling(label_test_day_8 ) end as label_test_day_8 ,
       case when label_test_day_9   is null or label_test_day_9  >10000 then -10000   else ceiling(label_test_day_9 ) end as label_test_day_9 ,
       case when label_test_day_10  is null or label_test_day_10 >10000 then -10000   else ceiling(label_test_day_10) end as label_test_day_10,
       case when label_test_day_11  is null or label_test_day_11 >10000 then -10000   else ceiling(label_test_day_11) end as label_test_day_11,
       case when label_test_day_12  is null or label_test_day_12 >10000 then -10000   else ceiling(label_test_day_12) end as label_test_day_12,
       case when label_test_day_13  is null or label_test_day_13 >10000 then -10000   else ceiling(label_test_day_13) end as label_test_day_13,
       case when label_test_day_14  is null or label_test_day_14 >10000 then -10000   else ceiling(label_test_day_14) end as label_test_day_14
	from
    test_results_shop_id a
--#left outer join 是以左边的表为基准进行匹配，后面的没有匹配上的就把它值为null
	left outer join
		test_results_day_1 f2
		on a.shop_id=f2.shop_id
	left outer join
		test_results_day_2 f3
		on a.shop_id=f3.shop_id
	left outer join
		test_results_day_3 f4
		on a.shop_id=f4.shop_id
	left outer join
		test_results_day_4 f5
		on a.shop_id=f5.shop_id
	left outer join
		test_results_day_5 f6
		on a.shop_id=f6.shop_id
	left outer join
		test_results_day_6 f7
		on a.shop_id=f7.shop_id
	left outer join
		test_results_day_7 f8
		on a.shop_id=f8.shop_id
	left outer join
		test_results_day_8 g2
		on a.shop_id=g2.shop_id
	left outer join
		test_results_day_9 g3
		on a.shop_id=g3.shop_id
	left outer join
		test_results_day_10 g4
		on a.shop_id=g4.shop_id
	left outer join
		test_results_day_11 g5
		on a.shop_id=g5.shop_id
	left outer join
		test_results_day_12 g6
		on a.shop_id=g6.shop_id
	left outer join
		test_results_day_13 g7
		on a.shop_id=g7.shop_id
	left outer join
		test_results_day_14 g8
		on a.shop_id=g8.shop_id;



--################################# the avg value not work  #############
--#UPDATE test_results_merge_temp1 t1 INNER join avg_label_of_every_shop t2
--#        ON t1.shop_id = t2.shop_id and weekday_0_to_6=weekday("2016-11-14") set  t1.label_test_day_14= t2.avg_label  
--#                                 WHERE t1.label_test_day_14< 10;
--#########################################################
--#######   the following step  
--#######   source /home/gui/work2017/tianchi_2017_03/work_of_sql/get_median.sql 
--#######
--#########################################################






--#########   use median replace null value and too large value   ####################
--############################################################
--#### 同一张表的 index名 必须 要求 各不相同 
--#create index index0  on feature_user_pay (shop_id);
--#create index index1  on feature_user_pay (user_pay_day_shop_id_cnt_no_distinct);
create index index2  on test_results_merge_temp1 (shop_id);
create index index3  on test_results_merge_temp1 (label_test_day_1 );
create index index4  on test_results_merge_temp1 (label_test_day_2 );
create index index5  on test_results_merge_temp1 (label_test_day_3 );
create index index6  on test_results_merge_temp1 (label_test_day_4 );
create index index7  on test_results_merge_temp1 (label_test_day_5 );
create index index8  on test_results_merge_temp1 (label_test_day_6 );
create index index9  on test_results_merge_temp1 (label_test_day_7 );
create index index10 on test_results_merge_temp1 (label_test_day_8 );
create index index11 on test_results_merge_temp1 (label_test_day_9 );
create index index12 on test_results_merge_temp1 (label_test_day_10);
create index index13 on test_results_merge_temp1 (label_test_day_11);
create index index14 on test_results_merge_temp1 (label_test_day_12);
create index index15 on test_results_merge_temp1 (label_test_day_13);
create index index16 on test_results_merge_temp1 (label_test_day_14);

--### the following is the get median 
delimiter $$ 
drop procedure  if exists wk;
create procedure wk()
begin 
declare i int;
declare j int;
set i = 1;
set j = 0;
--#######
while i < 2001 do 
set j =ceiling((select count(*) from feature_user_pay where shop_id=i)/2);
--#######
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_1 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_1 <10 and t1.shop_id=i;
--#######
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_2 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_2 <10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_3 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_3 <10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_4 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_4 <10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_5 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_5 <10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_6 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_6 <10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_7 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_7 <10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_8 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_8 <10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_9 =(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_9 <10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_10=(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_10<10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_11=(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_11<10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_12=(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_12<10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_13=(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_13<10 and t1.shop_id=i;
update test_results_merge_temp1 t1 inner join feature_user_pay t2
on t1.shop_id=t2.shop_id set 
t1.label_test_day_14=(select user_pay_day_shop_id_cnt_no_distinct from feature_user_pay where shop_id=i 
                                                   order by user_pay_day_shop_id_cnt_no_distinct limit j,1) where
t1.label_test_day_14<10 and t1.shop_id=i;

set i = i+1;
end while;
end $$
delimiter ;
call wk();

--#####################################################################
--##### first use median to replace the null value and too big value
--##### then  use  1     to replace the negative value 
--#####
--#####################################################################



select * from test_results_merge_temp1 
into outfile "/var/lib/mysql-files/test_results_merge_temp1.csv" 
FIELDS TERMINATED BY ','   
OPTIONALLY ENCLOSED BY '"'   
LINES TERMINATED BY '\n';

drop table if exists valid_results_0_score; 
create table valid_results_0_score as 
select 
sum(abs((label_valid-label)/(label+label_valid)))/(select count(*) from valid_results_0) as score
from valid_results_0;





