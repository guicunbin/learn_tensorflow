--###############################################################################################################################################
--####################################################        for train dataset       ##########################################################

use tianchi_2017_03_v3;

create table if not exists user_pay as 
select user_id,shop_id,str_to_date(substr(time_stamp,1,10),"%Y-%m-%d") as pay_day 
from 
tianchi_2017_03_v2.user_pay; 



create table if not exists user_view as
select user_id,shop_id,str_to_date(substr(time_stamp,1,10),"%Y-%m-%d") as view_day 
from 
tianchi_2017_03_v2.user_view; 

create index index0 on user_pay  (shop_id);
create index index1 on user_pay  (pay_day);
create index index2 on user_view (shop_id);
create index index3 on user_view (view_day);



create table if not exists user_pay_new as
select * from user_pay where pay_day  >="2016-06-01";


create table if not exists user_view_new as
select * from user_view where view_day >="2016-06-01";


create index index4 on user_pay_new  (shop_id);
create index index5 on user_pay_new  (pay_day);
create index index6 on user_pay_new  (user_id);
create index index7 on user_view_new (shop_id);
create index index8 on user_view_new (view_day);
create index index9 on user_view_new (user_id);


--############# for dataset user_pay_new ###############
--## feature_user_pay_2   user_pay_shop_id_cnt              这一年多的时间里，该商家被消费的次数                         (shop)
--## feature_user_pay_5   user_pay_day_shop_id_cnt          该商家在该天被消费的用户人数              (商家的日客流量)  (shop,pay_day)
--## feature_user_pay_6   user_pay_day_shop_id_cnt_no_distinct 该商家在该天被消费的次数         (商家的日客流量) (shop,pay_day) 
--## feature_user_pay_7   user_pay_shop_with_user_cnt       这一年多的时间里，与该商家有交互的用户个数,(商家的全年热度)  (shop)         
--## feature_user_pay_9   distinct shop_id pay_day                                                                       (shop_id,pay_day)
--## feature_user_pay_10  user_pay_shop_with_day_cnt    这一年多的时间里，与该商家有交互的支付天数,(商家的全年支付热度)  (shop)
--## feature_user_pay_11  user_pay_day_with_shop_cnt    与该天有交互的商家个数,(该天的热度)                              (pay_day)
--## feature_user_pay_12  user_pay_day_with_user_cnt    与该天有交互的用户个数,(该天的热度)                              (pay_day)
--## feature_user_pay_13  user_pay_day_with_user_cnt_no_distinct   与该天有交互的次数,(该天的热度)                       (pay_day)
--## 还有想实现却计算量太大，留到最后有时间再去实现吧 比如 ：
--## 该商家的全年的回头客数量，     该商家该天的回头客数量，   该天的回头客数量， 
--## feature_user_pay     上面 所有 特征之外还加了几个比率值:
--##                      user_pay_day_shop_in_shop_rate,    
--##  


create table if not exists feature_user_pay_2 as 
select shop_id,count(*) as user_pay_shop_id_cnt from
(
    select shop_id from user_pay_new
)t
group by shop_id;
--#这一年多的时间里，该商家被消费的次数(shop)
--#这一年多的时间里，与该商家有交互的用户次数,(商家的全年热度)(shop)

create table if not exists user_pay_distinct as 
select user_id,shop_id,pay_day from user_pay_new group by user_id,shop_id,pay_day;


create table if not exists feature_user_pay_5 as 
select shop_id,pay_day,count(*) as user_pay_day_shop_id_cnt from 
user_pay_distinct
group by shop_id,pay_day;
--#该商家在该天被消费的用户人次(shop,pay_day)



--#### 下面这个才会是label
create table if not exists feature_user_pay_6 as 
select shop_id,pay_day,count(*) as user_pay_day_shop_id_cnt_no_distinct from 
(
    select user_id,shop_id,pay_day from user_pay_new
)t
group by shop_id,pay_day;
--#该商家在该天被消费的用户次数(shop,pay_day)






create table if not exists feature_user_pay_7 as 
select shop_id,count(*) as user_pay_shop_with_user_cnt from
(
    select distinct user_id,shop_id from user_pay_new
)t
group by shop_id;
--#这一年多的时间里，与该商家有交互的用户个数,(商家的全年热度)(shop)





create table if not exists feature_user_pay_9 as 
select distinct shop_id,pay_day
from 
user_pay_new;




create table if not exists feature_user_pay_10 as 
select shop_id,count(*) as user_pay_shop_with_day_cnt from
(
    select distinct pay_day,shop_id from user_pay_new
)t
group by shop_id;
--#这一年多的时间里，与该商家有交互的支付天数,(商家的全年支付热度)(shop)




create table if not exists feature_user_pay_11 as 
select pay_day,count(*) as user_pay_day_with_shop_cnt from
(
    select distinct shop_id,pay_day from user_pay_new
)t
group by pay_day;
--#这一年多的时间里，该天有交互的商家个数,(该天的热度)(pay_day)




create table if not exists feature_user_pay_12 as 
select pay_day,count(*) as user_pay_day_with_user_cnt from
(
    select distinct user_id,pay_day from user_pay_new
)t
group by pay_day;
--#这一年多的时间里，与该天有交互的用户个数,(该天的热度)(pay_day)


create table if not exists feature_user_pay_13 as 
select pay_day,count(*) as user_pay_day_with_user_cnt_no_distinct from
(
    select user_id,pay_day from user_pay_new
)t
group by pay_day;
--#与该天有交互的次数,(该天的热度)(pay_day)





--# merge 

create index index10  on feature_user_pay_2  (shop_id);
create index index11  on feature_user_pay_5  (shop_id);
create index index12  on feature_user_pay_5  (pay_day);
create index index13  on feature_user_pay_6  (shop_id);
create index index14  on feature_user_pay_6  (pay_day);
create index index15  on feature_user_pay_7  (shop_id);
create index index16  on feature_user_pay_9  (shop_id);
create index index17  on feature_user_pay_9  (pay_day);
create index index18  on feature_user_pay_10 (shop_id);
create index index19  on feature_user_pay_11 (pay_day);
create index index20  on feature_user_pay_12 (pay_day);
create index index21  on feature_user_pay_13 (pay_day);




create table if not exists user_pay_f2579 as
select f579.*,
user_pay_shop_id_cnt
from
(
  select f79.*,
  user_pay_day_shop_id_cnt 
  from
  (
	select f9.*, 
    user_pay_shop_with_user_cnt 
    from
	feature_user_pay_9 f9  join feature_user_pay_7 f7 
	on f9.shop_id=f7.shop_id
  )f79  join feature_user_pay_5 f5 
  on f79.shop_id=f5.shop_id and f79.pay_day=f5.pay_day
)f579  join feature_user_pay_2 f2 
on f579.shop_id=f2.shop_id;


create index index22  on user_pay_f2579  (shop_id);
create index index23 on user_pay_f2579  (pay_day);



create table if not exists feature_user_pay_temp as 
select f2579101112.*,
case when user_pay_shop_id_cnt=0 then -1 else user_pay_day_shop_id_cnt/user_pay_shop_id_cnt end as user_pay_day_shop_in_shop_rate
from
(
select f25791011.*,
user_pay_day_with_user_cnt
from
(
select f257910.*,
user_pay_day_with_shop_cnt
from 
(
  select f2579.*,
  user_pay_shop_with_day_cnt
  from
  user_pay_f2579 f2579  join feature_user_pay_10 f10 
  on f2579.shop_id=f10.shop_id
)f257910  join feature_user_pay_11 f11
on f257910.pay_day=f11.pay_day
)f25791011  join feature_user_pay_12 f12
on f25791011.pay_day=f12.pay_day
)f2579101112;


create index index24  on feature_user_pay_temp  (shop_id);
create index index25 on feature_user_pay_temp  (pay_day);


--##### 2000 shop_id; 153 pay_day (2016-06-01 -> 2016-10-31)
create table if not exists feature_user_pay as
select f_temp.*,
user_pay_day_shop_id_cnt_no_distinct,
user_pay_day_with_user_cnt_no_distinct
from 
feature_user_pay_temp   f_temp 
join feature_user_pay_6 f6
on f_temp.shop_id=f6.shop_id and f_temp.pay_day=f6.pay_day
join feature_user_pay_13 f13
on f_temp.pay_day=f13.pay_day;



create index index26  on feature_user_pay (shop_id);
create index index27 on feature_user_pay (pay_day);






--############# for dataset user_view_new ###############
--## feature_user_view_2   user_view_shop_id_cnt              这一年多的时间里，该商家被消费的次数                         (shop)
--## feature_user_view_5   user_view_day_shop_id_cnt          该商家在该天被消费的用户人数              (商家的日客流量)  (shop,view_day)
--## feature_user_view_6   user_view_day_shop_id_cnt_no_distinct 该商家在该天被消费的次数         (商家的日客流量) (shop,view_day) 
--## feature_user_view_7   user_view_shop_with_user_cnt       这一年多的时间里，与该商家有交互的用户个数,(商家的全年热度)  (shop)         
--## feature_user_view_9   distinct shop_id view_day                                                                       (shop_id,view_day)
--## feature_user_view_10  user_view_shop_with_day_cnt    这一年多的时间里，与该商家有交互的支付天数,(商家的全年支付热度)  (shop)
--## feature_user_view_11  user_view_day_with_shop_cnt    与该天有交互的商家个数,(该天的热度)                              (view_day)
--## feature_user_view_12  user_view_day_with_user_cnt    与该天有交互的用户个数,(该天的热度)                              (view_day)
--## feature_user_view_13  user_view_day_with_user_cnt_no_distinct   与该天有交互的次数,(该天的热度)                       (view_day)
--## 还有想实现却计算量太大，留到最后有时间再去实现吧 比如 ：
--## 该商家的全年的回头客数量，     该商家该天的回头客数量，   该天的回头客数量， 
--## feature_user_view     上面 所有 特征之外还加了几个比率值:
--##                      user_view_day_shop_in_shop_rate,    
--##  


create table if not exists feature_user_view_2 as 
select shop_id,count(*) as user_view_shop_id_cnt from
(
    select shop_id from user_view_new
)t
group by shop_id;
--#这一年多的时间里，该商家被消费的次数(shop)
--#这一年多的时间里，与该商家有交互的用户次数,(商家的全年热度)(shop)




create table if not exists feature_user_view_5 as 
select shop_id,view_day,count(*) as user_view_day_shop_id_cnt from 
(
    select distinct user_id,shop_id,view_day from user_view_new
)t
group by shop_id,view_day;
--#该商家在该天被消费的用户人次(shop,view_day)



--#### 下面这个才会是label
create table if not exists feature_user_view_6 as 
select shop_id,view_day,count(*) as user_view_day_shop_id_cnt_no_distinct from 
(
    select user_id,shop_id,view_day from user_view_new
)t
group by shop_id,view_day;
--#该商家在该天被消费的用户次数(shop,view_day)






create table if not exists feature_user_view_7 as 
select shop_id,count(*) as user_view_shop_with_user_cnt from
(
    select distinct user_id,shop_id from user_view_new
)t
group by shop_id;
--#这一年多的时间里，与该商家有交互的用户个数,(商家的全年热度)(shop)





create table if not exists feature_user_view_9 as 
select distinct shop_id,view_day
from 
user_view_new;




create table if not exists feature_user_view_10 as 
select shop_id,count(*) as user_view_shop_with_day_cnt from
(
    select distinct view_day,shop_id from user_view_new
)t
group by shop_id;
--#这一年多的时间里，与该商家有交互的支付天数,(商家的全年支付热度)(shop)




create table if not exists feature_user_view_11 as 
select view_day,count(*) as user_view_day_with_shop_cnt from
(
    select distinct shop_id,view_day from user_view_new
)t
group by view_day;
--#这一年多的时间里，该天有交互的商家个数,(该天的热度)(view_day)




create table if not exists feature_user_view_12 as 
select view_day,count(*) as user_view_day_with_user_cnt from
(
    select distinct user_id,view_day from user_view_new
)t
group by view_day;
--#这一年多的时间里，与该天有交互的用户个数,(该天的热度)(view_day)


create table if not exists feature_user_view_13 as 
select view_day,count(*) as user_view_day_with_user_cnt_no_distinct from
(
    select user_id,view_day from user_view_new
)t
group by view_day;
--#与该天有交互的次数,(该天的热度)(view_day)





--# merge 

create index index28  on feature_user_view_2  (shop_id);
create index index29  on feature_user_view_5  (shop_id);
create index index30  on feature_user_view_5  (view_day);
create index index31  on feature_user_view_6  (shop_id);
create index index32  on feature_user_view_6  (view_day);
create index index33  on feature_user_view_7  (shop_id);
create index index34  on feature_user_view_9  (shop_id);
create index index35  on feature_user_view_9  (view_day);
create index index36  on feature_user_view_10 (shop_id);
create index index37  on feature_user_view_11 (view_day);
create index index38  on feature_user_view_12 (view_day);
create index index39  on feature_user_view_13 (view_day);




create table if not exists user_view_f2579 as
select f579.*,
user_view_shop_id_cnt
from
(
  select f79.*,
  user_view_day_shop_id_cnt 
  from
  (
	select f9.*, 
    user_view_shop_with_user_cnt 
    from
	feature_user_view_9 f9  join feature_user_view_7 f7 
	on f9.shop_id=f7.shop_id
  )f79  join feature_user_view_5 f5 
  on f79.shop_id=f5.shop_id and f79.view_day=f5.view_day
)f579  join feature_user_view_2 f2 
on f579.shop_id=f2.shop_id;


create index index40  on user_view_f2579  (shop_id);
create index index41 on user_view_f2579  (view_day);



create table if not exists feature_user_view_temp as 
select f2579101112.*,
case when user_view_shop_id_cnt=0 then -1 else user_view_day_shop_id_cnt/user_view_shop_id_cnt end as user_view_day_shop_in_shop_rate
from
(
select f25791011.*,
user_view_day_with_user_cnt
from
(
select f257910.*,
user_view_day_with_shop_cnt
from 
(
  select f2579.*,
  user_view_shop_with_day_cnt
  from
  user_view_f2579 f2579  join feature_user_view_10 f10 
  on f2579.shop_id=f10.shop_id
)f257910  join feature_user_view_11 f11
on f257910.view_day=f11.view_day
)f25791011  join feature_user_view_12 f12
on f25791011.view_day=f12.view_day
)f2579101112;


create index index42  on feature_user_view_temp  (shop_id);
create index index43 on feature_user_view_temp  (view_day);



--##### 1997 shop_id; 130 pay_day (2016-06-22 -> 2016-10-31)
create table if not exists feature_user_view as
select f_temp.*,
user_view_day_shop_id_cnt_no_distinct,
user_view_day_with_user_cnt_no_distinct
from 
feature_user_view_temp   f_temp 
join feature_user_view_6 f6
on f_temp.shop_id=f6.shop_id and f_temp.view_day=f6.view_day
join feature_user_view_13 f13
on f_temp.view_day=f13.view_day;



create index index44  on feature_user_view (shop_id);
create index index45 on feature_user_view (view_day);


--##### 1997 shop_id; 130 pay_day (2016-06-22 -> 2016-10-31)
--#### create table feature_user_pay_view
create table if not exists feature_user_pay_view as
select fp.*,
user_view_shop_id_cnt,
user_view_day_shop_id_cnt,
user_view_day_shop_id_cnt_no_distinct,
user_view_shop_with_user_cnt,
user_view_shop_with_day_cnt,
user_view_day_with_shop_cnt,
user_view_day_with_user_cnt,
user_view_day_with_user_cnt_no_distinct
from 
feature_user_pay fp join feature_user_view fv
on fp.shop_id=fv.shop_id and fp.pay_day=fv.view_day;


create index index46  on feature_user_pay_view (shop_id);
create index index47 on feature_user_pay_view (view_day);


--############# for dataset shop_info_new ###############
create table if not exists feature_shop_info_new as 
select shop_id,  city_name, per_pay, shop_level, cate_1_name, cate_2_name
from shop_info_new;



create index index48  on feature_shop_info_new (shop_id);
create index index49 on feature_shop_info_new (view_day);



--###  create  table  feature_user_pay_view_and_shop_info
--#########  1997 shop_id,  130  pay_day,   count 225731,
create table if not exists feature_user_pay_view_and_shop_info as
select t1.*,
city_name,per_pay,shop_level,cate_1_name,cate_2_name
from
feature_user_pay_view t1 join feature_shop_info_new t2 
on t1.shop_id=t2.shop_id;

create index index50  on feature_user_pay_view_and_shop_info (shop_id);
create index index51 on feature_user_pay_view_and_shop_info (pay_day);

--##### create feature_holiday_and_weather
--##### pay_day ...->2016-11-14    503 ;   city_name  122
create table if not exists feature_holiday_and_weather as
select t1.date as pay_day,
city_name,weather_1,weather_2,weather_3,holiday
from weather_all_new t1 join holiday t2
on t1.date=t2.date;


create index index52 on feature_holiday_and_weather (pay_day);
create index index53 on feature_holiday_and_weather (city_name(10));




--############# 2000 shop_id; 153 pay_day,count 283639;  just to 2016-10-31
create table if not exists feature_user_pay_and_shop_info as 
select a.*,city_name,per_pay,shop_level,cate_1_name,cate_2_name 
from feature_user_pay a join shop_info_new b
on a.shop_id=b.shop_id;
create index index53  on feature_user_pay_and_shop_info (shop_id);
create index index54 on feature_user_pay_and_shop_info (pay_day);



--############# 2000 shop_id; 153 pay_day,count 283639;  just to 2016-10-31
create table if not exists feature_user_pay_and_shop_info_06_22_10_31 as
select a.*,    pay_day as this_pay_day
from feature_user_pay_and_shop_info a; 




create table if not exists feature_user_pay_and_shop_info_11_01_11_07 as
select a.*,    date_add(pay_day,interval 7 day) as this_pay_day
from feature_user_pay_and_shop_info a where pay_day>="2016-10-25";


create table if not exists feature_user_pay_and_shop_info_11_08_11_14 as
select a.*,    date_add(pay_day, interval 14 day) as this_pay_day  
from feature_user_pay_and_shop_info a where pay_day>="2016-10-25";


--############ 2000 shop_id ;     311561 
create table if not exists feature_user_pay_and_shop_info_06_22_11_14 as
select * from feature_user_pay_and_shop_info_06_22_10_31 
union all
select * from feature_user_pay_and_shop_info_11_01_11_07
union all
select * from feature_user_pay_and_shop_info_11_08_11_14;

create index index55 on feature_user_pay_and_shop_info_06_22_11_14 (shop_id);
create index index56 on feature_user_pay_and_shop_info_06_22_11_14 (pay_day);
create index index57 on feature_user_pay_and_shop_info_06_22_11_14 (this_pay_day);
create index index58 on feature_user_pay_and_shop_info_06_22_11_14 (city_name(10));
create index index58 on feature_holiday_and_weather    (city_name(10));





--##### the city_name will be change to number here 
--#####  2000 shop_id;  this_pay_day 06-01 -> 11-14 ; 311561;
create table if not exists feature_user_pay_and_shop_info_and_holiday_and_weather as 
select a.*,
weather_1,weather_2,weather_3,holiday
from feature_user_pay_and_shop_info_06_22_11_14 a join feature_holiday_and_weather b
on a.city_name=b.city_name and a.this_pay_day=b.pay_day;
create index index58 on feature_user_pay_and_shop_info_and_holiday_and_weather (shop_id);
create index index58 on feature_user_pay_and_shop_info_and_holiday_and_weather (pay_day);
create index index58 on feature_user_pay_and_shop_info_and_holiday_and_weather (this_pay_day);



--############# create label  ###############
create table if not exists gui_train_label as 
select a.shop_id,a.pay_day,a.this_pay_day,
case when b.user_pay_day_shop_id_cnt_no_distinct is null then -1000 else b.user_pay_day_shop_id_cnt_no_distinct end as label
from 
feature_user_pay_and_shop_info_and_holiday_and_weather a
left outer join
feature_user_pay_6 b
on a.shop_id=b.shop_id and a.this_pay_day=b.pay_day;
delete from gui_train_label where label=-1000 and this_pay_day <="2016-10-31";


create index index58  on gui_train_label (shop_id);
create index index59  on gui_train_label (pay_day);
create index index60  on gui_train_label (this_pay_day);



--####### create gui_train_set , but this gui_train_set has a feature same as label , so need to deal 
create table if not exists gui_train_set as
select  a.*,
b.label
from feature_user_pay_and_shop_info_and_holiday_and_weather a
join gui_train_label b
on a.shop_id=b.shop_id and a.this_pay_day=b.this_pay_day;
create index index61  on gui_train_set (shop_id);
create index index62  on gui_train_set (pay_day);
create index index63  on gui_train_set (this_pay_day);



--####### 294629 ; 2000 shop_id; 160 this_pay_day;
--####### gui_train_set_v1 use lost of features of this day so can make error very small, but it is wrong 
create table if not exists gui_train_set_v1 as
select a.*,
weekofyear(a.this_pay_day) as week_num,
abs(datediff(a.this_pay_day,"2016-11-14")) as day_distance_to_20161114,
abs(weekofyear(a.this_pay_day)-weekofyear("2016-11-14")) as week_distance_to_20161114,
weekday(a.this_pay_day) as weekday_0_to_6,
ceiling(substr(a.this_pay_day,9,2)) as day_of_this_pay_day,
ceiling(substr(a.this_pay_day,6,2)) as month_of_this_pay_day,
b.user_pay_day_shop_id_cnt_no_distinct   as last_week_same_day_label,
b.user_pay_shop_with_user_cnt            as last_week_same_day_user_pay_shop_with_user_cnt,
b.user_pay_day_shop_id_cnt               as last_week_same_day_user_pay_day_shop_id_cnt,
b.user_pay_shop_id_cnt                   as last_week_same_day_user_pay_shop_id_cnt,
b.user_pay_shop_with_day_cnt             as last_week_same_day_user_pay_shop_with_day_cnt,
b.user_pay_day_with_shop_cnt             as last_week_same_day_user_pay_day_with_shop_cnt,
b.user_pay_day_with_user_cnt             as last_week_same_day_user_pay_day_with_user_cnt,
b.user_pay_day_shop_in_shop_rate         as last_week_same_day_user_pay_day_shop_in_shop_rate,
b.user_pay_day_with_user_cnt_no_distinct as last_week_same_day_user_pay_day_with_user_cnt_no_distinct
from gui_train_set a 
join gui_train_set b
on a.shop_id=b.shop_id and date_add(b.this_pay_day, interval 7 day)=a.this_pay_day;
create index index64  on gui_train_set_v1 (shop_id);
create index index65  on gui_train_set_v1 (pay_day);
create index index66  on gui_train_set_v1 (this_pay_day);
alter table gui_train_set_v1 drop column user_pay_day_shop_id_cnt_no_distinct;
--###### this features are the predict_day's leakage



--###### real features of gui_train_set_v1
create table if not exists gui_train_set_v2 as 
select 
shop_id,        pay_day,        this_pay_day,       label,      holiday,
weather_1,      weather_2,      weather_3,      day_of_this_pay_day,    month_of_this_pay_day,
week_num,       weekday_0_to_6, week_distance_to_20161114,  day_distance_to_20161114,
city_name,      per_pay,        shop_level,                 cate_1_name,    cate_2_name,
last_week_same_day_label,
last_week_same_day_user_pay_shop_with_user_cnt,
last_week_same_day_user_pay_day_shop_id_cnt,
last_week_same_day_user_pay_shop_id_cnt,
last_week_same_day_user_pay_shop_with_day_cnt,
last_week_same_day_user_pay_day_with_shop_cnt,
last_week_same_day_user_pay_day_with_user_cnt,
last_week_same_day_user_pay_day_shop_in_shop_rate,
last_week_same_day_user_pay_day_with_user_cnt_no_distinct
from gui_train_set_v1;
create index index67 on gui_train_set_v2 (shop_id);
create index index68 on gui_train_set_v2 (this_pay_day);



create table if not exists avg_label_of_every_shop_id  as  
select shop_id,avg(user_pay_day_shop_id_cnt_no_distinct) as avg_label 
from feature_user_pay 
where pay_day>="2016-07-01" and pay_day<="2016-10-31" group by shop_id;




create table if not exists feature_max_value_of_shop_id as
select shop_id, 
max(user_pay_day_shop_id_cnt_no_distinct)    as max_label,
max(user_pay_shop_with_user_cnt)             as max_user_pay_shop_with_user_cnt,
max(user_pay_day_shop_id_cnt)                as max_user_pay_day_shop_id_cnt,
max(user_pay_shop_id_cnt)                    as max_user_pay_shop_id_cnt,
max(user_pay_shop_with_day_cnt)              as max_user_pay_shop_with_day_cnt,
max(user_pay_day_with_shop_cnt)              as max_user_pay_day_with_shop_cnt,
max(user_pay_day_with_user_cnt)              as max_user_pay_day_with_user_cnt,
max(user_pay_day_shop_in_shop_rate)          as max_user_pay_day_shop_in_shop_rate,
max(user_pay_day_with_user_cnt_no_distinct)  as max_user_pay_day_with_user_cnt_no_distinct
from
feature_user_pay b group by shop_id;
create index index69 on feature_max_value_of_shop_id (shop_id);




create table if not exists gui_train_set_v4 as 
select g.*,
max_label,
max_user_pay_shop_with_user_cnt,
max_user_pay_day_shop_id_cnt,
max_user_pay_shop_id_cnt,
max_user_pay_shop_with_day_cnt,
max_user_pay_day_with_shop_cnt,
max_user_pay_day_with_user_cnt,
max_user_pay_day_shop_in_shop_rate,
max_user_pay_day_with_user_cnt_no_distinct
from gui_train_set_v2      g
join feature_max_value_of_shop_id  m
on g.shop_id=m.shop_id;
create index index70  on gui_train_set_v4 (shop_id);
create index index71  on gui_train_set_v4 (pay_day);
create index index72  on gui_train_set_v4 (this_pay_day);
--## delete from gui_train_set_v4 where max_label/label >8 ;
delete from gui_train_set_v4 where max_label/label >10;
--## has added median_ features of every shop_id  via  pandas 

create table if not exists gui_train_set_v4_2016_06_01_2016_10_24 as 
select * from gui_train_set_v4 where this_pay_day <= "2016-10-24";


create table if not exists gui_train_set_v4_2016_06_01_2016_10_31 as 
select * from gui_train_set_v4 where this_pay_day <= "2016-10-31";


create table if not exists gui_train_set_v4_2016_10_25_2016_10_31 as 
select * from gui_train_set_v4 where this_pay_day >= "2016-10-25" and this_pay_day <= "2016-10-31";

--###### shop_id: 1998 ; this_pay_day:14 ; count:  27922; 
create table if not exists gui_train_set_v4_2016_11_01_2016_11_14 as 
select * from gui_train_set_v4 where this_pay_day >= "2016-11-01";

alter table gui_train_set_v4_2016_11_01_2016_11_14 drop column label;



create table if not exists gui_train_set_v5 as
select shop_id,pay_day,this_pay_day,label,
weather_1,weather_2,weather_3,median_last_week_same_day_label
from gui_train_set_v4;
create index index73  on gui_train_set_v5 (shop_id);
create index index74  on gui_train_set_v5 (pay_day);
create index index75  on gui_train_set_v5 (this_pay_day);
--## delete from gui_train_set_v5 where max_label/label >8 ;
delete from gui_train_set_v5 where max_label/label >10;
--######  gui_train_set_v5 not work well 



--###### feature  importance
--# last_week_same_day_user_pay_day_with_user_cnt : 1366965.40135
--# last_week_same_day_user_pay_day_with_shop_cnt : 1761169.60786
--# day_of_this_pay_day : 2092293.60804
--# holiday : 2203727.60543
--# last_week_same_day_user_pay_day_shop_in_shop_rate : 2241768.53543
--# median_last_week_same_day_user_pay_day_shop_in_shop_rate : 2245011.87001
--# max_user_pay_day_shop_id_cnt : 2516563.75723
--# max_label : 2930459.55625
--# last_week_same_day_user_pay_shop_with_user_cnt : 3818051.22455
--# max_user_pay_day_shop_in_shop_rate : 3841708.05778
--# per_pay : 3976266.02739
--# day_distance_to_20161114 : 4000504.85356
--# median_last_week_same_day_user_pay_day_shop_id_cnt : 7465977.51311
--# last_week_same_day_user_pay_day_shop_id_cnt : 16531312.7282
--# last_week_same_day_user_pay_shop_id_cnt : 18281448.5583
--# last_week_same_day_label : 21166073.4599
--# median_last_week_same_day_label : 36119760.0483
create table if not exists gui_train_set_v6 as 
select shop_id,pay_day,this_pay_day,label,
last_week_same_day_user_pay_day_with_user_cnt ,                
last_week_same_day_user_pay_day_with_shop_cnt ,                
day_of_this_pay_day ,                                          
holiday ,                                                      
last_week_same_day_user_pay_day_shop_in_shop_rate ,            
median_last_week_same_day_user_pay_day_shop_in_shop_rate ,
max_user_pay_day_shop_id_cnt ,                                 
max_label ,                                                    
last_week_same_day_user_pay_shop_with_user_cnt ,               
max_user_pay_day_shop_in_shop_rate ,                           
per_pay ,                                                      
day_distance_to_20161114 ,                                     
median_last_week_same_day_user_pay_day_shop_id_cnt ,           
last_week_same_day_user_pay_day_shop_id_cnt ,                  
last_week_same_day_user_pay_shop_id_cnt ,                      
last_week_same_day_label ,                                     
median_last_week_same_day_label
from gui_train_set_v4;
create index index76  on gui_train_set_v6 (shop_id);
create index index77  on gui_train_set_v6 (pay_day);
create index index78  on gui_train_set_v6 (this_pay_day);
--## delete from gui_train_set_v6 where max_label/label >8 ;
delete from gui_train_set_v6 where max_label/label >10;
--## has added median_ features of every shop_id  via  pandas 



create table if not exists gui_train_set_v6_2016_06_01_2016_10_24 as 
select * from gui_train_set_v6 where this_pay_day <= "2016-10-24";


create table if not exists gui_train_set_v6_2016_06_01_2016_10_31 as 
select * from gui_train_set_v6 where this_pay_day <= "2016-10-31";


create table if not exists gui_train_set_v6_2016_10_25_2016_10_31 as 
select * from gui_train_set_v6 where this_pay_day >= "2016-10-25" and this_pay_day <= "2016-10-31";

--###### shop_id: 1998 ; this_pay_day:14 ; count:  27922; 
create table if not exists gui_train_set_v6_2016_11_01_2016_11_14 as 
select * from gui_train_set_v6 where this_pay_day >= "2016-11-01";

alter table gui_train_set_v6_2016_11_01_2016_11_14 drop column label;


--###### add a cate_label from gui_train_set_v4 ;
--###### label 
--###### >500: 5951;         400-500: 4791 ;     300-400: 9485;    200-300: 23229;     
--###### 100-200:  84605;    50-100: 103678;     0-50:   25729;
create table if not exists gui_train_set_v7 as
select *,
case when label<50                       then 0 
     when label>=50   and  label<100     then 1
     when label>=100  and  label<200     then 2
     when label>=200  and  label<300     then 3
     when label>=300  and  label<400     then 4
     when label>=400  and  label<500     then 5
     else 6 end as cate_label
from gui_train_set_v4 g;
create index index79  on gui_train_set_v7 (shop_id);
create index index80  on gui_train_set_v7 (pay_day);
create index index81  on gui_train_set_v7 (this_pay_day);
--## delete from gui_train_set_v7 where max_label/label >8 ;
delete from gui_train_set_v7 where max_label/label >10;
--## has added median_ features of every shop_id  via  pandas 



create table if not exists gui_train_set_v7_2016_06_01_2016_10_24 as 
select * from gui_train_set_v7 where this_pay_day <= "2016-10-24";


create table if not exists gui_train_set_v7_2016_06_01_2016_10_31 as 
select * from gui_train_set_v7 where this_pay_day <= "2016-10-31";


create table if not exists gui_train_set_v7_2016_10_25_2016_10_31 as 
select * from gui_train_set_v7 where this_pay_day >= "2016-10-25" and this_pay_day <= "2016-10-31";

--###### shop_id: 1998 ; this_pay_day:14 ; count:  27922; 
--######  test data's cate_label need to be train with classfier to get 
create table if not exists gui_train_set_v7_2016_11_01_2016_11_14 as 
select * from gui_train_set_v7 where this_pay_day >= "2016-11-01";

alter table gui_train_set_v7_2016_11_01_2016_11_14 drop column label;
alter table gui_train_set_v7_2016_11_01_2016_11_14 drop column cate_label;




create table if not exists gui_train_set_v8_1 as
select g.*
,g1.label                                            as   before_1_label
,g1.user_pay_shop_with_user_cnt                      as   before_1_user_pay_shop_with_user_cnt
,g1.user_pay_day_shop_id_cnt                         as   before_1_user_pay_day_shop_id_cnt
,g1.user_pay_shop_id_cnt                             as   before_1_user_pay_shop_id_cnt
,g1.user_pay_shop_with_day_cnt                       as   before_1_user_pay_shop_with_day_cnt 
,g1.user_pay_day_with_shop_cnt                       as   before_1_user_pay_day_with_shop_cnt 
,g1.user_pay_day_with_user_cnt                       as   before_1_user_pay_day_with_user_cnt
,g1.user_pay_day_shop_in_shop_rate                   as   before_1_user_pay_day_shop_in_shop_rate
,g1.user_pay_day_with_user_cnt_no_distinct           as   before_1_user_pay_day_with_user_cnt_no_distinct
from                gui_train_set_v4 g 
join                gui_train_set_v1 g1
on date_add(g1.this_pay_day, interval 1 day)=g.this_pay_day and g1.shop_id=g.shop_id;
create index index82  on gui_train_set_v8_1 (shop_id);
create index index83  on gui_train_set_v8_1 (pay_day);
create index index84  on gui_train_set_v8_1 (this_pay_day);






create table if not exists gui_train_set_v8_2 as
select g.*
,g2.label                                            as   before_2_label
,g2.user_pay_shop_with_user_cnt                      as   before_2_user_pay_shop_with_user_cnt
,g2.user_pay_day_shop_id_cnt                         as   before_2_user_pay_day_shop_id_cnt
,g2.user_pay_shop_id_cnt                             as   before_2_user_pay_shop_id_cnt
,g2.user_pay_shop_with_day_cnt                       as   before_2_user_pay_shop_with_day_cnt 
,g2.user_pay_day_with_shop_cnt                       as   before_2_user_pay_day_with_shop_cnt 
,g2.user_pay_day_with_user_cnt                       as   before_2_user_pay_day_with_user_cnt
,g2.user_pay_day_shop_in_shop_rate                   as   before_2_user_pay_day_shop_in_shop_rate
,g2.user_pay_day_with_user_cnt_no_distinct           as   before_2_user_pay_day_with_user_cnt_no_distinct
from                gui_train_set_v8_1 g 
join                gui_train_set_v1   g2
on date_add(g2.this_pay_day, interval 2 day)=g.this_pay_day and g2.shop_id=g.shop_id;
create index index85  on gui_train_set_v8_2 (shop_id);
create index index86  on gui_train_set_v8_2 (pay_day);
create index index87  on gui_train_set_v8_2 (this_pay_day);









create table if not exists gui_train_set_v8_3 as
select g.*
,g3.label                                            as   before_3_label
,g3.user_pay_shop_with_user_cnt                      as   before_3_user_pay_shop_with_user_cnt
,g3.user_pay_day_shop_id_cnt                         as   before_3_user_pay_day_shop_id_cnt
,g3.user_pay_shop_id_cnt                             as   before_3_user_pay_shop_id_cnt
,g3.user_pay_shop_with_day_cnt                       as   before_3_user_pay_shop_with_day_cnt 
,g3.user_pay_day_with_shop_cnt                       as   before_3_user_pay_day_with_shop_cnt 
,g3.user_pay_day_with_user_cnt                       as   before_3_user_pay_day_with_user_cnt
,g3.user_pay_day_shop_in_shop_rate                   as   before_3_user_pay_day_shop_in_shop_rate
,g3.user_pay_day_with_user_cnt_no_distinct           as   before_3_user_pay_day_with_user_cnt_no_distinct
from                gui_train_set_v8_2 g 
join                gui_train_set_v1 g3
on date_add(g3.this_pay_day, interval 3 day)=g.this_pay_day and g3.shop_id=g.shop_id;
create index index88  on gui_train_set_v8_3 (shop_id);
create index index89  on gui_train_set_v8_3 (pay_day);
create index index90  on gui_train_set_v8_3 (this_pay_day);










create table if not exists gui_train_set_v8_4 as
select g.*
,g4.label                                            as   before_4_label
,g4.user_pay_shop_with_user_cnt                      as   before_4_user_pay_shop_with_user_cnt
,g4.user_pay_day_shop_id_cnt                         as   before_4_user_pay_day_shop_id_cnt
,g4.user_pay_shop_id_cnt                             as   before_4_user_pay_shop_id_cnt
,g4.user_pay_shop_with_day_cnt                       as   before_4_user_pay_shop_with_day_cnt 
,g4.user_pay_day_with_shop_cnt                       as   before_4_user_pay_day_with_shop_cnt 
,g4.user_pay_day_with_user_cnt                       as   before_4_user_pay_day_with_user_cnt
,g4.user_pay_day_shop_in_shop_rate                   as   before_4_user_pay_day_shop_in_shop_rate
,g4.user_pay_day_with_user_cnt_no_distinct           as   before_4_user_pay_day_with_user_cnt_no_distinct
from                gui_train_set_v8_3 g 
join                gui_train_set_v1 g4
on date_add(g4.this_pay_day, interval 4 day)=g.this_pay_day and g4.shop_id=g.shop_id; 
create index index91  on gui_train_set_v8_4 (shop_id);
create index index92  on gui_train_set_v8_4 (pay_day);
create index index93  on gui_train_set_v8_4 (this_pay_day);




create table if not exists gui_train_set_v8_5 as
select g.*
,g5.label                                            as   before_5_label
,g5.user_pay_shop_with_user_cnt                      as   before_5_user_pay_shop_with_user_cnt
,g5.user_pay_day_shop_id_cnt                         as   before_5_user_pay_day_shop_id_cnt
,g5.user_pay_shop_id_cnt                             as   before_5_user_pay_shop_id_cnt
,g5.user_pay_shop_with_day_cnt                       as   before_5_user_pay_shop_with_day_cnt 
,g5.user_pay_day_with_shop_cnt                       as   before_5_user_pay_day_with_shop_cnt 
,g5.user_pay_day_with_user_cnt                       as   before_5_user_pay_day_with_user_cnt
,g5.user_pay_day_shop_in_shop_rate                   as   before_5_user_pay_day_shop_in_shop_rate
,g5.user_pay_day_with_user_cnt_no_distinct           as   before_5_user_pay_day_with_user_cnt_no_distinct
from                gui_train_set_v8_4 g 
join                gui_train_set_v1   g5
on date_add(g5.this_pay_day, interval 5 day)=g.this_pay_day and g5.shop_id=g.shop_id;
create index index94  on gui_train_set_v8_5 (shop_id);
create index index95  on gui_train_set_v8_5 (pay_day);
create index index96  on gui_train_set_v8_5 (this_pay_day);










create table if not exists gui_train_set_v8_6 as
select g.*
,g6.label                                            as   before_6_label
,g6.user_pay_shop_with_user_cnt                      as   before_6_user_pay_shop_with_user_cnt
,g6.user_pay_day_shop_id_cnt                         as   before_6_user_pay_day_shop_id_cnt
,g6.user_pay_shop_id_cnt                             as   before_6_user_pay_shop_id_cnt
,g6.user_pay_shop_with_day_cnt                       as   before_6_user_pay_shop_with_day_cnt 
,g6.user_pay_day_with_shop_cnt                       as   before_6_user_pay_day_with_shop_cnt 
,g6.user_pay_day_with_user_cnt                       as   before_6_user_pay_day_with_user_cnt
,g6.user_pay_day_shop_in_shop_rate                   as   before_6_user_pay_day_shop_in_shop_rate
,g6.user_pay_day_with_user_cnt_no_distinct           as   before_6_user_pay_day_with_user_cnt_no_distinct
from                gui_train_set_v8_5 g 
join                gui_train_set_v1 g6
on date_add(g6.this_pay_day, interval 6 day)=g.this_pay_day and g6.shop_id=g.shop_id;
create index index97  on gui_train_set_v8_6 (shop_id);
create index index98  on gui_train_set_v8_6 (pay_day);
create index index99  on gui_train_set_v8_6 (this_pay_day);




--#### the following feature must have null value ,   
--#### but don't need to replace ,  because lightgbm  can  deal the null and  error replace will work badly 
create table if not exists gui_train_set_v8 as
select g.*
,g7.label                                            as   before_7_label
,g7.user_pay_shop_with_user_cnt                      as   before_7_user_pay_shop_with_user_cnt
,g7.user_pay_day_shop_id_cnt                         as   before_7_user_pay_day_shop_id_cnt
,g7.user_pay_shop_id_cnt                             as   before_7_user_pay_shop_id_cnt
,g7.user_pay_shop_with_day_cnt                       as   before_7_user_pay_shop_with_day_cnt 
,g7.user_pay_day_with_shop_cnt                       as   before_7_user_pay_day_with_shop_cnt 
,g7.user_pay_day_with_user_cnt                       as   before_7_user_pay_day_with_user_cnt
,g7.user_pay_day_shop_in_shop_rate                   as   before_7_user_pay_day_shop_in_shop_rate
,g7.user_pay_day_with_user_cnt_no_distinct           as   before_7_user_pay_day_with_user_cnt_no_distinct
from                gui_train_set_v8_6 g 
join                gui_train_set_v1 g7
on date_add(g7.this_pay_day, interval 7 day)=g.this_pay_day and g7.shop_id=g.shop_id;
create index index100  on gui_train_set_v8 (shop_id);
create index index101  on gui_train_set_v8 (pay_day);
create index index102  on gui_train_set_v8 (this_pay_day);






delete from gui_train_set_v8 where max_label/label >10;

create table if not exists gui_train_set_v8_2016_06_01_2016_10_24 as 
select * from gui_train_set_v8 where this_pay_day <= "2016-10-24";


create table if not exists gui_train_set_v8_2016_06_01_2016_10_31 as 
select * from gui_train_set_v8 where this_pay_day <= "2016-10-31";


create table if not exists gui_train_set_v8_2016_10_25_2016_10_31 as 
select * from gui_train_set_v8 where this_pay_day >= "2016-10-25" and this_pay_day <= "2016-10-31";

create table if not exists gui_train_set_v8_2016_11_01_2016_11_14 as 
select * from gui_train_set_v8 where this_pay_day >= "2016-11-01";

alter table gui_train_set_v8_2016_11_01_2016_11_14 drop column label;



create table if not exists gui_train_set_v9 as
select shop_id,pay_day,this_pay_day,label,
median_last_week_same_day_user_pay_shop_id_cnt ,
week_distance_to_20161114 ,
month_of_this_pay_day ,
max_user_pay_shop_with_day_cnt ,
before_7_user_pay_day_with_shop_cnt ,
median_last_week_same_day_user_pay_day_with_user_cnt_no_distinct ,
weather_2 ,
week_num ,
before_7_user_pay_day_with_user_cnt ,
median_last_week_same_day_user_pay_shop_with_user_cnt ,
before_7_user_pay_day_with_user_cnt_no_distinct ,
last_week_same_day_user_pay_shop_with_day_cnt ,
median_last_week_same_day_user_pay_day_with_user_cnt ,
before_5_user_pay_day_with_user_cnt_no_distinct ,
before_6_user_pay_day_with_user_cnt_no_distinct ,
median_last_week_same_day_user_pay_day_with_shop_cnt ,
cate_1_name ,
weather_1 ,
last_7_days_median_user_pay_day_with_user_cnt_no_distinct ,
max_user_pay_shop_with_user_cnt ,
day_distance_to_20161114 ,
before_2_user_pay_day_with_user_cnt_no_distinct ,
max_user_pay_shop_id_cnt ,
before_7_user_pay_day_shop_in_shop_rate ,
before_5_user_pay_day_with_shop_cnt ,
before_4_user_pay_day_with_user_cnt_no_distinct ,
before_3_user_pay_day_with_shop_cnt ,
before_4_user_pay_day_with_shop_cnt ,
shop_level ,
before_3_user_pay_day_with_user_cnt_no_distinct ,
city_name ,
before_6_user_pay_day_with_shop_cnt ,
last_7_days_median_user_pay_day_shop_in_shop_rate ,
before_6_user_pay_day_with_user_cnt ,
before_6_user_pay_day_shop_in_shop_rate ,
before_4_user_pay_day_with_user_cnt ,
before_2_user_pay_day_with_shop_cnt ,
before_7_user_pay_day_shop_id_cnt ,
last_7_days_median_user_pay_day_with_shop_cnt ,
before_3_user_pay_day_shop_in_shop_rate ,
before_2_user_pay_day_with_user_cnt ,
last_week_same_day_user_pay_day_with_user_cnt_no_distinct ,
weather_3 ,
before_1_user_pay_day_with_shop_cnt ,
before_5_user_pay_day_with_user_cnt ,
last_week_same_day_user_pay_day_with_user_cnt ,
before_4_user_pay_day_shop_id_cnt ,
before_1_user_pay_day_with_user_cnt ,
before_4_user_pay_day_shop_in_shop_rate ,
before_3_user_pay_day_with_user_cnt ,
before_5_user_pay_day_shop_id_cnt ,
last_week_same_day_user_pay_day_with_shop_cnt ,
cate_2_name ,
last_7_days_median_user_pay_day_with_user_cnt ,
before_4_label ,
before_3_label ,
before_2_user_pay_day_shop_in_shop_rate ,
before_6_label ,
before_5_label ,
day_of_this_pay_day ,
median_last_week_same_day_user_pay_day_shop_in_shop_rate ,
before_2_label ,
before_6_user_pay_day_shop_id_cnt ,
before_1_user_pay_day_with_user_cnt_no_distinct ,
before_3_user_pay_day_shop_id_cnt ,
before_2_user_pay_day_shop_id_cnt ,
max_user_pay_day_shop_id_cnt ,
before_5_user_pay_day_shop_in_shop_rate ,
last_week_same_day_user_pay_shop_id_cnt ,
last_week_same_day_user_pay_shop_with_user_cnt ,
median_last_week_same_day_user_pay_day_shop_id_cnt ,
before_7_label ,
last_week_same_day_user_pay_day_shop_in_shop_rate ,
max_user_pay_day_shop_in_shop_rate ,
before_1_user_pay_day_shop_in_shop_rate ,
holiday ,
per_pay ,
max_label ,
before_1_user_pay_day_shop_id_cnt ,
weekday_0_to_6 ,
last_week_same_day_user_pay_day_shop_id_cnt ,
last_week_same_day_label ,
median_last_week_same_day_label ,
last_7_days_median_label ,
last_7_days_median_user_pay_day_shop_id_cnt ,
before_1_label 
from gui_train_set_v8; 
create index index100  on gui_train_set_v9 (shop_id);
create index index101  on gui_train_set_v9 (pay_day);
create index index102  on gui_train_set_v9 (this_pay_day);




delete from gui_train_set_v9 where max_label/label >10;

create table if not exists gui_train_set_v9_2016_06_01_2016_10_24 as 
select * from gui_train_set_v9 where this_pay_day <= "2016-10-24";


create table if not exists gui_train_set_v9_2016_06_01_2016_10_31 as 
select * from gui_train_set_v9 where this_pay_day <= "2016-10-31";


create table if not exists gui_train_set_v9_2016_10_25_2016_10_31 as 
select * from gui_train_set_v9 where this_pay_day >= "2016-10-25" and this_pay_day <= "2016-10-31";

create table if not exists gui_train_set_v9_2016_11_01_2016_11_14 as 
select * from gui_train_set_v9 where this_pay_day >= "2016-11-01";

alter table gui_train_set_v9_2016_11_01_2016_11_14 drop column label;






--### gui_train_set         283639              feature_user_pay_and_shop_info_and_holiday_and_weather      283639
--### feature_user_pay      283639              feature_user_pay_and_shop_info                              283639
--### feature_user_pay_6    283639
--### just predict tomorrow's 客流量
--### just use some day feaures and shop_id features
--### first just extract features
create table if not exists feature_holiday_and_weather_shop_info as
select
b.shop_id,a.pay_day,
weekofyear(a.pay_day)                                       as week_num,
abs(datediff(a.pay_day,"2016-11-14"))                       as day_distance_to_20161114,
abs(weekofyear(a.pay_day)-weekofyear("2016-11-14"))         as week_distance_to_20161114,
weekday(a.pay_day)                                          as weekday_0_to_6,
ceiling(substr(a.pay_day,9,2))                              as day_of_pay_day,
ceiling(substr(a.pay_day,6,2))                              as month_of_pay_day,
a.weather_1                                                 as weather_1,
a.weather_2                                                 as weather_2,
a.weather_3                                                 as weather_3,
a.holiday                                                   as holiday,
b.city_name                                                 as city_name,
b.per_pay                                                   as per_pay,
b.shop_level                                                as shop_level,
b.cate_1_name                                               as cate_1_name,
b.cate_2_name                                               as cate_2_name
from
feature_holiday_and_weather a join
feature_shop_info_new       b
on a.city_name=b.city_name;
create index index103 on feature_holiday_and_weather_shop_info (shop_id);
create index index104 on feature_holiday_and_weather_shop_info (pay_day);




--#### create train valid test set
create table if not exists gui_train_set_10 as
select a.*,
b.label 
from
feature_holiday_and_weather_shop_info  a
join
gui_train_label b 
on a.shop_id=b.shop_id and a.pay_day=b.this_pay_day where b.this_pay_day<"2016-11-01";


--#### create train set
create table if not exists gui_train_set_10_1 as select * from gui_train_set_10 where pay_day< "2016-10-18";
--#### create valid set
create table if not exists gui_train_set_10_2 as select * from gui_train_set_10 where pay_day>="2016-10-18";
--#### create test set from feature_holiday_and_weather_shop_info
create table if not exists gui_test_set_10 as
select * from
feature_holiday_and_weather_shop_info where pay_day>="2016-11-01"


