--###############################    bank_detail.txt      ********************
--###############################    for bank_detail_train

create table if not exists feature_bank_detail_train_1 as
select user_id_bank,count(*) as bank_detail_user_total from
(
	select user_id_bank from bank_detail_train
)t 
group by user_id_bank;
--# 用户在bank_detail_train中的出现总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_train_2 as
select user_id_bank,count(*) as bank_detail_user_deal_type1 from
(
	select user_id_bank from bank_detail_train where deal_type=1
)t 
group by user_id_bank;
--# 用户在bank_detail_train中的deal_type=1总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_train_3 as
select user_id_bank,count(*) as bank_detail_user_deal_type0 from
(
	select user_id_bank from bank_detail_train where deal_type=0
)t 
group by user_id_bank;
--# 用户在bank_detail_train中的deal_type=0总次数，每个用户都有一个这样的数值



create table if not exists feature_bank_detail_train_4 as
select user_id_bank,count(*) as bank_detail_user_salary0 from
(
	select user_id_bank from bank_detail_train where is_salary=0
)t 
group by user_id_bank;
--# 用户在bank_detail_train中的is_salary=0总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_train_5 as
select user_id_bank,count(*) as bank_detail_user_salary1 from
(
	select user_id_bank from bank_detail_train where is_salary=1
)t 
group by user_id_bank;
--# 用户在bank_detail_train中的is_salary=1总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_train_6 as
select user_id_bank,count(*) as bank_detail_user_salary0_type0 from
(
	select user_id_bank from bank_detail_train where is_salary=0 and deal_type=0
)t 
group by user_id_bank;
--# 用户在bank_detail_train中的is_salary=0 and deal_type=0总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_train_7 as
select user_id_bank,
avg(deal_money) as avg_deal_money,
min(deal_money) as min_deal_money,
max(deal_money) as max_deal_money,
sum(deal_money) as sum_deal_money
from
(
	select user_id_bank,deal_money from bank_detail_train 
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_train_8 as
select user_id_bank,
avg(deal_money) as avg_deal_money_type0,
min(deal_money) as min_deal_money_type0,
max(deal_money) as max_deal_money_type0,
sum(deal_money) as sum_deal_money_type0
from
(
	select user_id_bank,deal_money from bank_detail_train where deal_type=0  
)t 
group by user_id_bank;


create table if not exists feature_bank_detail_train_9 as
select user_id_bank,
avg(deal_money) as avg_deal_money_type1,
min(deal_money) as min_deal_money_type1,
max(deal_money) as max_deal_money_type1, 
sum(deal_money) as sum_deal_money_type1
from
(
	select user_id_bank,deal_money from bank_detail_train where deal_type=1  
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_train_10 as
select user_id_bank,
avg(deal_money) as avg_deal_money_salary0,
min(deal_money) as min_deal_money_salary0,
max(deal_money) as max_deal_money_salary0,
sum(deal_money) as sum_deal_money_salary0
from
(
	select user_id_bank,deal_money from bank_detail_train where is_salary=0
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_train_11 as
select user_id_bank,
avg(deal_money) as avg_deal_money_salary1,
min(deal_money) as min_deal_money_salary1,
max(deal_money) as max_deal_money_salary1,
sum(deal_money) as sum_deal_money_salary1
from
(
	select user_id_bank,deal_money from bank_detail_train where is_salary=1 
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_train_12 as
select user_id_bank,
avg(deal_money) as avg_deal_money_salary0_type0,
min(deal_money) as min_deal_money_salary0_type0,
max(deal_money) as max_deal_money_salary0_type0,
sum(deal_money) as sum_deal_money_salary0_type0
from
(
	select user_id_bank,deal_money from bank_detail_train where deal_type=0 and is_salary=0
)t 
group by user_id_bank;





create table if not exists feature_bank_detail_train as
select w.*,
case when bank_detail_user_total=0 then -1 else bank_detail_user_deal_type1/bank_detail_user_total end as bank_detail_user_deal_type1_total_rate,  
case when bank_detail_user_total =0 then -1 else bank_detail_user_salary0/bank_detail_user_total end as bank_detail_user_salary0_total_rate,
case when bank_detail_user_deal_type0=0 then -1 else bank_detail_user_salary0_type0/bank_detail_user_deal_type0 end as bank_detail_user_salary0_type0_in_type0_rate,
case when bank_detail_user_salary0=0 then -1 else bank_detail_user_salary0_type0/bank_detail_user_salary0 end as bank_detail_user_salary0_type0_in_salary0_rate,
case when sum_deal_money=0 then -1 else sum_deal_money_type0/sum_deal_money end as sum_deal_money_type0_in_total_rate,
case when avg_deal_money=0 then -1 else avg_deal_money_type0/avg_deal_money end as avg_deal_money_type0_in_total_rate, 
case when sum_deal_money=0 then -1 else sum_deal_money_salary0/sum_deal_money end as sum_deal_money_salary0_in_total_rate,
case when avg_deal_money=0 then -1 else avg_deal_money_salary0/avg_deal_money end as avg_deal_money_salary0_in_total_rate,
case when sum_deal_money_salary0 = 0 then -1 else sum_deal_money_salary0_type0/sum_deal_money_salary0 end as sum_deal_money_salary0_type0_in_salary0_rate,
case when avg_deal_money_salary0 = 0 then -1 else avg_deal_money_salary0_type0/avg_deal_money_salary0 end as avg_deal_money_salary0_type0_in_salary0_rate,
case when sum_deal_money_type0 = 0 then -1 else sum_deal_money_salary0_type0/sum_deal_money_type0 end as sum_deal_money_salary0_type0_in_type0_rate,
case when avg_deal_money_type0 = 0 then -1 else avg_deal_money_salary0_type0/avg_deal_money_type0 end as avg_deal_money_salary0_type0_in_type0_rate
from
(
select u.*,
case when min_deal_money_salary0_type0 is null then 0 else min_deal_money_salary0_type0 end as min_deal_money_salary0_type0,
case when max_deal_money_salary0_type0 is null then 0 else max_deal_money_salary0_type0 end as max_deal_money_salary0_type0,
case when avg_deal_money_salary0_type0 is null then 0 else avg_deal_money_salary0_type0 end as avg_deal_money_salary0_type0,
case when sum_deal_money_salary0_type0 is null then 0 else sum_deal_money_salary0_type0 end as sum_deal_money_salary0_type0
from
(
	select s.*,
    case when min_deal_money_salary1 is null then 0 else min_deal_money_salary1 end as min_deal_money_salary1,
    case when max_deal_money_salary1 is null then 0 else max_deal_money_salary1 end as max_deal_money_salary1,
    case when avg_deal_money_salary1 is null then 0 else avg_deal_money_salary1 end as avg_deal_money_salary1,
    case when sum_deal_money_salary1 is null then 0 else sum_deal_money_salary1 end as sum_deal_money_salary1
    from
	(
		select q.*,
        case when min_deal_money_salary0 is null then 0 else min_deal_money_salary0 end as min_deal_money_salary0,
        case when max_deal_money_salary0 is null then 0 else max_deal_money_salary0 end as max_deal_money_salary0,
        case when avg_deal_money_salary0 is null then 0 else avg_deal_money_salary0 end as avg_deal_money_salary0,
        case when sum_deal_money_salary0 is null then 0 else sum_deal_money_salary0 end as sum_deal_money_salary0
        from
		(
			select o.*,
            case when min_deal_money_type1 is null then 0 else min_deal_money_type1 end as min_deal_money_type1,
            case when max_deal_money_type1 is null then 0 else max_deal_money_type1 end as max_deal_money_type1,
            case when avg_deal_money_type1 is null then 0 else avg_deal_money_type1 end as avg_deal_money_type1,
            case when sum_deal_money_type1 is null then 0 else sum_deal_money_type1 end as sum_deal_money_type1
            from
			(
				select m.*,
                case when min_deal_money_type0 is null then 0 else min_deal_money_type0 end as min_deal_money_type0,
                case when max_deal_money_type0 is null then 0 else max_deal_money_type0 end as max_deal_money_type0,
                case when avg_deal_money_type0 is null then 0 else avg_deal_money_type0 end as avg_deal_money_type0,
                case when sum_deal_money_type0 is null then 0 else sum_deal_money_type0 end as sum_deal_money_type0
                from
				(
					select k.*,
                    max_deal_money,min_deal_money,avg_deal_money,sum_deal_money
                    from
					(
					  select i.*,
                    case when bank_detail_user_salary0_type0 is null then 0 else bank_detail_user_salary0_type0 end as bank_detail_user_salary0_type0
                    from
					  (
						select g.*,
                        case when bank_detail_user_salary1 is null then 0 else bank_detail_user_salary1 end as bank_detail_user_salary1
                        from
						(
							select e.*,
                            case when bank_detail_user_salary0 is null then 0 else bank_detail_user_salary0 end as bank_detail_user_salary0
                            from
							(
							  select c.*,
                            case when bank_detail_user_deal_type0 is null then 0 else bank_detail_user_deal_type0 end as bank_detail_user_deal_type0
                              from
							  (
								select a.*,
                                case when bank_detail_user_deal_type1 is null then 0 else bank_detail_user_deal_type1 end as bank_detail_user_deal_type1
                                from
								feature_bank_detail_train_1 a left outer join feature_bank_detail_train_2 b 
								on a.user_id_bank=b.user_id_bank
							  )c left outer join feature_bank_detail_train_3 d 
							  on c.user_id_bank=d.user_id_bank
							)e left outer join feature_bank_detail_train_4 f 
							on e.user_id_bank=f.user_id_bank 
						)g left outer join feature_bank_detail_train_5 h 
						on g.user_id_bank=h.user_id_bank
					  )i left outer join feature_bank_detail_train_6 j 
					  on i.user_id_bank=j.user_id_bank
					)k left outer join feature_bank_detail_train_7 l 
					on k.user_id_bank=l.user_id_bank
				)m left outer join feature_bank_detail_train_8 n 
				on m.user_id_bank=n.user_id_bank
			)o left outer join feature_bank_detail_train_9 p
			on o.user_id_bank=p.user_id_bank
		)q left outer join feature_bank_detail_train_10 r
		on q.user_id_bank=r.user_id_bank
	)s left outer join feature_bank_detail_train_11 t
	on s.user_id_bank=t.user_id_bank
)u  left outer join feature_bank_detail_train_12 v
on u.user_id_bank=v.user_id_bank
)w;

--###############################    for bank_detail_test    



create table if not exists feature_bank_detail_test_1 as
select user_id_bank,count(*) as bank_detail_user_total from
(
	select user_id_bank from bank_detail_test
)t 
group by user_id_bank;
--# 用户在bank_detail_test中的出现总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_test_2 as
select user_id_bank,count(*) as bank_detail_user_deal_type1 from
(
	select user_id_bank from bank_detail_test where deal_type=1
)t 
group by user_id_bank;
--# 用户在bank_detail_test中的deal_type=1总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_test_3 as
select user_id_bank,count(*) as bank_detail_user_deal_type0 from
(
	select user_id_bank from bank_detail_test where deal_type=0
)t 
group by user_id_bank;
--# 用户在bank_detail_test中的deal_type=0总次数，每个用户都有一个这样的数值



create table if not exists feature_bank_detail_test_4 as
select user_id_bank,count(*) as bank_detail_user_salary0 from
(
	select user_id_bank from bank_detail_test where is_salary=0
)t 
group by user_id_bank;
--# 用户在bank_detail_test中的is_salary=0总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_test_5 as
select user_id_bank,count(*) as bank_detail_user_salary1 from
(
	select user_id_bank from bank_detail_test where is_salary=1
)t 
group by user_id_bank;
--# 用户在bank_detail_test中的is_salary=1总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_test_6 as
select user_id_bank,count(*) as bank_detail_user_salary0_type0 from
(
	select user_id_bank from bank_detail_test where is_salary=0 and deal_type=0
)t 
group by user_id_bank;
--# 用户在bank_detail_test中的is_salary=0 and deal_type=0总次数，每个用户都有一个这样的数值


create table if not exists feature_bank_detail_test_7 as
select user_id_bank,
avg(deal_money) as avg_deal_money,
min(deal_money) as min_deal_money,
max(deal_money) as max_deal_money,
sum(deal_money) as sum_deal_money
from
(
	select user_id_bank,deal_money from bank_detail_test 
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_test_8 as
select user_id_bank,
avg(deal_money) as avg_deal_money_type0,
min(deal_money) as min_deal_money_type0,
max(deal_money) as max_deal_money_type0,
sum(deal_money) as sum_deal_money_type0
from
(
	select user_id_bank,deal_money from bank_detail_test where deal_type=0  
)t 
group by user_id_bank;


create table if not exists feature_bank_detail_test_9 as
select user_id_bank,
avg(deal_money) as avg_deal_money_type1,
min(deal_money) as min_deal_money_type1,
max(deal_money) as max_deal_money_type1, 
sum(deal_money) as sum_deal_money_type1
from
(
	select user_id_bank,deal_money from bank_detail_test where deal_type=1  
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_test_10 as
select user_id_bank,
avg(deal_money) as avg_deal_money_salary0,
min(deal_money) as min_deal_money_salary0,
max(deal_money) as max_deal_money_salary0,
sum(deal_money) as sum_deal_money_salary0
from
(
	select user_id_bank,deal_money from bank_detail_test where is_salary=0
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_test_11 as
select user_id_bank,
avg(deal_money) as avg_deal_money_salary1,
min(deal_money) as min_deal_money_salary1,
max(deal_money) as max_deal_money_salary1,
sum(deal_money) as sum_deal_money_salary1
from
(
	select user_id_bank,deal_money from bank_detail_test where is_salary=1 
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_test_12 as
select user_id_bank,
avg(deal_money) as avg_deal_money_salary0_type0,
min(deal_money) as min_deal_money_salary0_type0,
max(deal_money) as max_deal_money_salary0_type0,
sum(deal_money) as sum_deal_money_salary0_type0
from
(
	select user_id_bank,deal_money from bank_detail_test where deal_type=0 and is_salary=0
)t 
group by user_id_bank;



create table if not exists feature_bank_detail_test as
select w.*,
case when bank_detail_user_total=0 then -1 else bank_detail_user_deal_type1/bank_detail_user_total end as bank_detail_user_deal_type1_total_rate,  
case when bank_detail_user_total =0 then -1 else bank_detail_user_salary0/bank_detail_user_total end as bank_detail_user_salary0_total_rate,
case when bank_detail_user_deal_type0=0 then -1 else bank_detail_user_salary0_type0/bank_detail_user_deal_type0 end as bank_detail_user_salary0_type0_in_type0_rate,
case when bank_detail_user_salary0=0 then -1 else bank_detail_user_salary0_type0/bank_detail_user_salary0 end as bank_detail_user_salary0_type0_in_salary0_rate,
case when sum_deal_money=0 then -1 else sum_deal_money_type0/sum_deal_money end as sum_deal_money_type0_in_total_rate,
case when avg_deal_money=0 then -1 else avg_deal_money_type0/avg_deal_money end as avg_deal_money_type0_in_total_rate, 
case when sum_deal_money=0 then -1 else sum_deal_money_salary0/sum_deal_money end as sum_deal_money_salary0_in_total_rate,
case when avg_deal_money=0 then -1 else avg_deal_money_salary0/avg_deal_money end as avg_deal_money_salary0_in_total_rate,
case when sum_deal_money_salary0 = 0 then -1 else sum_deal_money_salary0_type0/sum_deal_money_salary0 end as sum_deal_money_salary0_type0_in_salary0_rate,
case when avg_deal_money_salary0 = 0 then -1 else avg_deal_money_salary0_type0/avg_deal_money_salary0 end as avg_deal_money_salary0_type0_in_salary0_rate,
case when sum_deal_money_type0 = 0 then -1 else sum_deal_money_salary0_type0/sum_deal_money_type0 end as sum_deal_money_salary0_type0_in_type0_rate,
case when avg_deal_money_type0 = 0 then -1 else avg_deal_money_salary0_type0/avg_deal_money_type0 end as avg_deal_money_salary0_type0_in_type0_rate
from
(
select u.*,
case when min_deal_money_salary0_type0 is null then 0 else min_deal_money_salary0_type0 end as min_deal_money_salary0_type0,
case when max_deal_money_salary0_type0 is null then 0 else max_deal_money_salary0_type0 end as max_deal_money_salary0_type0,
case when avg_deal_money_salary0_type0 is null then 0 else avg_deal_money_salary0_type0 end as avg_deal_money_salary0_type0,
case when sum_deal_money_salary0_type0 is null then 0 else sum_deal_money_salary0_type0 end as sum_deal_money_salary0_type0
from
(
	select s.*,
    case when min_deal_money_salary1 is null then 0 else min_deal_money_salary1 end as min_deal_money_salary1,
    case when max_deal_money_salary1 is null then 0 else max_deal_money_salary1 end as max_deal_money_salary1,
    case when avg_deal_money_salary1 is null then 0 else avg_deal_money_salary1 end as avg_deal_money_salary1,
    case when sum_deal_money_salary1 is null then 0 else sum_deal_money_salary1 end as sum_deal_money_salary1
    from
	(
		select q.*,
        case when min_deal_money_salary0 is null then 0 else min_deal_money_salary0 end as min_deal_money_salary0,
        case when max_deal_money_salary0 is null then 0 else max_deal_money_salary0 end as max_deal_money_salary0,
        case when avg_deal_money_salary0 is null then 0 else avg_deal_money_salary0 end as avg_deal_money_salary0,
        case when sum_deal_money_salary0 is null then 0 else sum_deal_money_salary0 end as sum_deal_money_salary0
        from
		(
			select o.*,
            case when min_deal_money_type1 is null then 0 else min_deal_money_type1 end as min_deal_money_type1,
            case when max_deal_money_type1 is null then 0 else max_deal_money_type1 end as max_deal_money_type1,
            case when avg_deal_money_type1 is null then 0 else avg_deal_money_type1 end as avg_deal_money_type1,
            case when sum_deal_money_type1 is null then 0 else sum_deal_money_type1 end as sum_deal_money_type1
            from
			(
				select m.*,
                case when min_deal_money_type0 is null then 0 else min_deal_money_type0 end as min_deal_money_type0,
                case when max_deal_money_type0 is null then 0 else max_deal_money_type0 end as max_deal_money_type0,
                case when avg_deal_money_type0 is null then 0 else avg_deal_money_type0 end as avg_deal_money_type0,
                case when sum_deal_money_type0 is null then 0 else sum_deal_money_type0 end as sum_deal_money_type0
                from
				(
					select k.*,
                    max_deal_money,min_deal_money,avg_deal_money,sum_deal_money
                    from
					(
					  select i.*,
                    case when bank_detail_user_salary0_type0 is null then 0 else bank_detail_user_salary0_type0 end as bank_detail_user_salary0_type0
                    from
					  (
						select g.*,
                        case when bank_detail_user_salary1 is null then 0 else bank_detail_user_salary1 end as bank_detail_user_salary1
                        from
						(
							select e.*,
                            case when bank_detail_user_salary0 is null then 0 else bank_detail_user_salary0 end as bank_detail_user_salary0
                            from
							(
							  select c.*,
                            case when bank_detail_user_deal_type0 is null then 0 else bank_detail_user_deal_type0 end as bank_detail_user_deal_type0
                              from
							  (
								select a.*,
                                case when bank_detail_user_deal_type1 is null then 0 else bank_detail_user_deal_type1 end as bank_detail_user_deal_type1
                                from
								feature_bank_detail_test_1 a left outer join feature_bank_detail_test_2 b 
								on a.user_id_bank=b.user_id_bank
							  )c left outer join feature_bank_detail_test_3 d 
							  on c.user_id_bank=d.user_id_bank
							)e left outer join feature_bank_detail_test_4 f 
							on e.user_id_bank=f.user_id_bank 
						)g left outer join feature_bank_detail_test_5 h 
						on g.user_id_bank=h.user_id_bank
					  )i left outer join feature_bank_detail_test_6 j 
					  on i.user_id_bank=j.user_id_bank
					)k left outer join feature_bank_detail_test_7 l 
					on k.user_id_bank=l.user_id_bank
				)m left outer join feature_bank_detail_test_8 n 
				on m.user_id_bank=n.user_id_bank
			)o left outer join feature_bank_detail_test_9 p
			on o.user_id_bank=p.user_id_bank
		)q left outer join feature_bank_detail_test_10 r
		on q.user_id_bank=r.user_id_bank
	)s left outer join feature_bank_detail_test_11 t
	on s.user_id_bank=t.user_id_bank
)u  left outer join feature_bank_detail_test_12 v
on u.user_id_bank=v.user_id_bank
)w; 





--##############################   for browse_history_train  #########################



create table if not exists feature_browse_history_train_0 as
select user_id_browse,count(*) as browse_history_user_total from
(
	select user_id_browse from browse_history_train
)t 
group by user_id_browse;


create table if not exists feature_browse_history_train_1 as
select user_id_browse,count(*) as browse_history_user_browse_type1 from
(
	select user_id_browse from browse_history_train where browse_type=1
)t 
group by user_id_browse;



create table if not exists feature_browse_history_train_2 as
select user_id_browse,count(*) as browse_history_user_browse_type2 from
(
	select user_id_browse from browse_history_train where browse_type=2
)t 
group by user_id_browse;



create table if not exists feature_browse_history_train_3 as
select user_id_browse,count(*) as browse_history_user_browse_type3 from
(
	select user_id_browse from browse_history_train where browse_type=3
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_4 as
select user_id_browse,count(*) as browse_history_user_browse_type4 from
(
	select user_id_browse from browse_history_train where browse_type=4
)t 
group by user_id_browse;



create table if not exists feature_browse_history_train_5 as
select user_id_browse,count(*) as browse_history_user_browse_type5 from
(
	select user_id_browse from browse_history_train where browse_type=5
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_6 as
select user_id_browse,count(*) as browse_history_user_browse_type6 from
(
	select user_id_browse from browse_history_train where browse_type=6
)t 
group by user_id_browse;





create table if not exists feature_browse_history_train_7 as
select user_id_browse,count(*) as browse_history_user_browse_type7 from
(
	select user_id_browse from browse_history_train where browse_type=7
)t 
group by user_id_browse;






create table if not exists feature_browse_history_train_8 as
select user_id_browse,count(*) as browse_history_user_browse_type8 from
(
	select user_id_browse from browse_history_train where browse_type=8
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_9 as
select user_id_browse,count(*) as browse_history_user_browse_type9 from
(
	select user_id_browse from browse_history_train where browse_type=9
)t 
group by user_id_browse;





create table if not exists feature_browse_history_train_10 as
select user_id_browse,count(*) as browse_history_user_browse_type10 from
(
	select user_id_browse from browse_history_train where browse_type=10
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_11 as
select user_id_browse,count(*) as browse_history_user_browse_type11 from
(
	select user_id_browse from browse_history_train where browse_type=11
)t 
group by user_id_browse;



create table if not exists feature_browse_history_train_12 as
select user_id_browse,
avg(browse_data) as avg_browse_data,
min(browse_data) as min_browse_data,
max(browse_data) as max_browse_data,
sum(browse_data) as sum_browse_data
from
(
	select user_id_browse,browse_data from browse_history_train 
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_13 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type1,
min(browse_data) as min_browse_data_type1,
max(browse_data) as max_browse_data_type1,
sum(browse_data) as sum_browse_data_type1
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=1
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_14 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type2,
min(browse_data) as min_browse_data_type2,
max(browse_data) as max_browse_data_type2,
sum(browse_data) as sum_browse_data_type2
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=2
)t 
group by user_id_browse;





create table if not exists feature_browse_history_train_15 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type3,
min(browse_data) as min_browse_data_type3,
max(browse_data) as max_browse_data_type3,
sum(browse_data) as sum_browse_data_type3
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=3
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_16 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type4,
min(browse_data) as min_browse_data_type4,
max(browse_data) as max_browse_data_type4,
sum(browse_data) as sum_browse_data_type4
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=4
)t 
group by user_id_browse;



create table if not exists feature_browse_history_train_17 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type5,
min(browse_data) as min_browse_data_type5,
max(browse_data) as max_browse_data_type5,
sum(browse_data) as sum_browse_data_type5
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=5
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_18 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type6,
min(browse_data) as min_browse_data_type6,
max(browse_data) as max_browse_data_type6,
sum(browse_data) as sum_browse_data_type6
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=6
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_19 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type7,
min(browse_data) as min_browse_data_type7,
max(browse_data) as max_browse_data_type7,
sum(browse_data) as sum_browse_data_type7
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=7
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_20 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type8,
min(browse_data) as min_browse_data_type8,
max(browse_data) as max_browse_data_type8,
sum(browse_data) as sum_browse_data_type8
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=8
)t 
group by user_id_browse;



create table if not exists feature_browse_history_train_21 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type9,
min(browse_data) as min_browse_data_type9,
max(browse_data) as max_browse_data_type9,
sum(browse_data) as sum_browse_data_type9
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=9
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_22 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type10,
min(browse_data) as min_browse_data_type10,
max(browse_data) as max_browse_data_type10,
sum(browse_data) as sum_browse_data_type10
from
(
	select user_id_browse,browse_data from browse_history_train where browse_type=10
)t 
group by user_id_browse;




create table if not exists feature_browse_history_train_23 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type11,
min(browse_data) as min_browse_data_type11,
max(browse_data) as max_browse_data_type11,
sum(browse_data) as sum_browse_data_type11
from
(
select user_id_browse,browse_data from browse_history_train where browse_type=11
)t 
group by user_id_browse;






create table if not exists feature_browse_history_train_temp1 as     


select a12.*,
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type11/browse_history_user_total end as browse_history_user_browse_type11_total_rate, 
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type10/browse_history_user_total end as browse_history_user_browse_type10_total_rate, 
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type9/browse_history_user_total end as browse_history_user_browse_type9_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type8/browse_history_user_total end as browse_history_user_browse_type8_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type7/browse_history_user_total end as browse_history_user_browse_type7_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type6/browse_history_user_total end as browse_history_user_browse_type6_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type5/browse_history_user_total end as browse_history_user_browse_type5_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type4/browse_history_user_total end as browse_history_user_browse_type4_total_rate,  
case when browse_history_user_total =0 then -1 else browse_history_user_browse_type3/browse_history_user_total end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type2/browse_history_user_total end as browse_history_user_browse_type2_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type1/browse_history_user_total end as browse_history_user_browse_type1_total_rate  
from
(
select a11.*,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11
from
(
select a10.*,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10
from
(
select a09.*,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9
from
(
select a08.*,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8
from
(
select a07.*,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7
from
(
select a06.*,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6
from
(
select a05.*,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5
from
(
select a04.*,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4
from
(
select a03.*,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3
from
(
select a02.*,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2
from
(
select a01.*,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1
from
feature_browse_history_train_0 a01 left outer join feature_browse_history_train_1 b01 
on a01.user_id_browse=b01.user_id_browse
)a02 left outer join feature_browse_history_train_2 b02 
on a02.user_id_browse=b02.user_id_browse
)a03 left outer join feature_browse_history_train_3 b03
on a03.user_id_browse=b03.user_id_browse 
)a04 left outer join feature_browse_history_train_4 b04
on a04.user_id_browse=b04.user_id_browse
)a05 left outer join feature_browse_history_train_5 b05 
on a05.user_id_browse=b05.user_id_browse
)a06 left outer join feature_browse_history_train_6 b06 
on a06.user_id_browse=b06.user_id_browse
)a07 left outer join feature_browse_history_train_7 b07 
on a07.user_id_browse=b07.user_id_browse
)a08 left outer join feature_browse_history_train_8 b08
on a08.user_id_browse=b08.user_id_browse
)a09 left outer join feature_browse_history_train_9 b09
on a09.user_id_browse=b09.user_id_browse
)a10 left outer join feature_browse_history_train_10 b10
on a10.user_id_browse=b10.user_id_browse
)a11  left outer join feature_browse_history_train_11 b11
on a11.user_id_browse=b11.user_id_browse
)a12;








create table if not exists feature_browse_history_train as
select g12.*,
case when min_browse_data=0 then -1 else min_browse_data_type1/min_browse_data end as min_browse_data_type1_in_total_rate, 
case when max_browse_data=0 then -1 else max_browse_data_type1/max_browse_data end as max_browse_data_type1_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type1/avg_browse_data end as avg_browse_data_type1_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type1/sum_browse_data end as sum_browse_data_type1_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type2/min_browse_data end as min_browse_data_type2_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type2/max_browse_data end as max_browse_data_type2_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type2/avg_browse_data end as avg_browse_data_type2_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type2/sum_browse_data end as sum_browse_data_type2_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type3/min_browse_data end as min_browse_data_type3_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type3/max_browse_data end as max_browse_data_type3_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type3/avg_browse_data end as avg_browse_data_type3_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type3/sum_browse_data end as sum_browse_data_type3_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type4/min_browse_data end as min_browse_data_type4_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type4/max_browse_data end as max_browse_data_type4_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type4/avg_browse_data end as avg_browse_data_type4_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type4/sum_browse_data end as sum_browse_data_type4_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type5/min_browse_data end as min_browse_data_type5_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type5/max_browse_data end as max_browse_data_type5_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type5/avg_browse_data end as avg_browse_data_type5_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type5/sum_browse_data end as sum_browse_data_type5_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type6/min_browse_data end as min_browse_data_type6_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type6/max_browse_data end as max_browse_data_type6_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type6/avg_browse_data end as avg_browse_data_type6_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type6/sum_browse_data end as sum_browse_data_type6_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type7/min_browse_data end as min_browse_data_type7_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type7/max_browse_data end as max_browse_data_type7_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type7/avg_browse_data end as avg_browse_data_type7_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type7/sum_browse_data end as sum_browse_data_type7_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type8/min_browse_data end as min_browse_data_type8_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type8/max_browse_data end as max_browse_data_type8_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type8/avg_browse_data end as avg_browse_data_type8_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type8/sum_browse_data end as sum_browse_data_type8_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type9/min_browse_data end as min_browse_data_type9_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type9/max_browse_data end as max_browse_data_type9_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type9/avg_browse_data end as avg_browse_data_type9_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type9/sum_browse_data end as sum_browse_data_type9_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type10/min_browse_data end as min_browse_data_type10_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type10/max_browse_data end as max_browse_data_type10_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type10/avg_browse_data end as avg_browse_data_type10_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type10/sum_browse_data end as sum_browse_data_type10_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type11/min_browse_data end as min_browse_data_type11_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type11/max_browse_data end as max_browse_data_type11_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type11/avg_browse_data end as avg_browse_data_type11_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type11/sum_browse_data end as sum_browse_data_type11_in_total_rate
from
(
select g11.*,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11
from
(
select g10.*,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10
from
(
select g9.*,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9
from
(
select g8.*,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8
from
(
select g7.*,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7
from
(
select g6.*,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6
from
(
select g5.*,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5
from
(
select g4.*,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4
from
(
select g3.*,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3
from
(
select g2.*,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2
from
(
select g1.*,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1
from
(
select g0.*,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data
from
feature_browse_history_train_temp1 g0 left outer join feature_browse_history_train_12 f0
on g0.user_id_browse=f0.user_id_browse
)g1 left outer join feature_browse_history_train_13 f1
on g1.user_id_browse=f1.user_id_browse
)g2 left outer join feature_browse_history_train_14 f2
on g2.user_id_browse=f2.user_id_browse
)g3 left outer join feature_browse_history_train_15 f3
on g3.user_id_browse=f3.user_id_browse
)g4 left outer join feature_browse_history_train_16 f4
on g4.user_id_browse=f4.user_id_browse
)g5 left outer join feature_browse_history_train_17 f5
on g5.user_id_browse=f5.user_id_browse
)g6 left outer join feature_browse_history_train_18 f6
on g6.user_id_browse=f6.user_id_browse
)g7 left outer join feature_browse_history_train_19 f7
on g7.user_id_browse=f7.user_id_browse
)g8 left outer join feature_browse_history_train_20 f8
on g8.user_id_browse=f8.user_id_browse
)g9 left outer join feature_browse_history_train_21 f9
on g9.user_id_browse=f9.user_id_browse
)g10 left outer join feature_browse_history_train_22 f10
on g10.user_id_browse=f10.user_id_browse
)g11 left outer join feature_browse_history_train_23 f11
on g11.user_id_browse=f11.user_id_browse
)g12;


    
    
    


--##############################   for browse_history_test  #########################



create table if not exists feature_browse_history_test_0 as
select user_id_browse,count(*) as browse_history_user_total from
(
	select user_id_browse from browse_history_test
)t 
group by user_id_browse;


create table if not exists feature_browse_history_test_1 as
select user_id_browse,count(*) as browse_history_user_browse_type1 from
(
	select user_id_browse from browse_history_test where browse_type=1
)t 
group by user_id_browse;



create table if not exists feature_browse_history_test_2 as
select user_id_browse,count(*) as browse_history_user_browse_type2 from
(
	select user_id_browse from browse_history_test where browse_type=2
)t 
group by user_id_browse;



create table if not exists feature_browse_history_test_3 as
select user_id_browse,count(*) as browse_history_user_browse_type3 from
(
	select user_id_browse from browse_history_test where browse_type=3
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_4 as
select user_id_browse,count(*) as browse_history_user_browse_type4 from
(
	select user_id_browse from browse_history_test where browse_type=4
)t 
group by user_id_browse;



create table if not exists feature_browse_history_test_5 as
select user_id_browse,count(*) as browse_history_user_browse_type5 from
(
	select user_id_browse from browse_history_test where browse_type=5
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_6 as
select user_id_browse,count(*) as browse_history_user_browse_type6 from
(
	select user_id_browse from browse_history_test where browse_type=6
)t 
group by user_id_browse;





create table if not exists feature_browse_history_test_7 as
select user_id_browse,count(*) as browse_history_user_browse_type7 from
(
	select user_id_browse from browse_history_test where browse_type=7
)t 
group by user_id_browse;






create table if not exists feature_browse_history_test_8 as
select user_id_browse,count(*) as browse_history_user_browse_type8 from
(
	select user_id_browse from browse_history_test where browse_type=8
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_9 as
select user_id_browse,count(*) as browse_history_user_browse_type9 from
(
	select user_id_browse from browse_history_test where browse_type=9
)t 
group by user_id_browse;





create table if not exists feature_browse_history_test_10 as
select user_id_browse,count(*) as browse_history_user_browse_type10 from
(
	select user_id_browse from browse_history_test where browse_type=10
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_11 as
select user_id_browse,count(*) as browse_history_user_browse_type11 from
(
	select user_id_browse from browse_history_test where browse_type=11
)t 
group by user_id_browse;



create table if not exists feature_browse_history_test_12 as
select user_id_browse,
avg(browse_data) as avg_browse_data,
min(browse_data) as min_browse_data,
max(browse_data) as max_browse_data,
sum(browse_data) as sum_browse_data
from
(
	select user_id_browse,browse_data from browse_history_test 
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_13 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type1,
min(browse_data) as min_browse_data_type1,
max(browse_data) as max_browse_data_type1,
sum(browse_data) as sum_browse_data_type1
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=1
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_14 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type2,
min(browse_data) as min_browse_data_type2,
max(browse_data) as max_browse_data_type2,
sum(browse_data) as sum_browse_data_type2
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=2
)t 
group by user_id_browse;





create table if not exists feature_browse_history_test_15 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type3,
min(browse_data) as min_browse_data_type3,
max(browse_data) as max_browse_data_type3,
sum(browse_data) as sum_browse_data_type3
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=3
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_16 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type4,
min(browse_data) as min_browse_data_type4,
max(browse_data) as max_browse_data_type4,
sum(browse_data) as sum_browse_data_type4
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=4
)t 
group by user_id_browse;



create table if not exists feature_browse_history_test_17 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type5,
min(browse_data) as min_browse_data_type5,
max(browse_data) as max_browse_data_type5,
sum(browse_data) as sum_browse_data_type5
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=5
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_18 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type6,
min(browse_data) as min_browse_data_type6,
max(browse_data) as max_browse_data_type6,
sum(browse_data) as sum_browse_data_type6
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=6
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_19 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type7,
min(browse_data) as min_browse_data_type7,
max(browse_data) as max_browse_data_type7,
sum(browse_data) as sum_browse_data_type7
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=7
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_20 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type8,
min(browse_data) as min_browse_data_type8,
max(browse_data) as max_browse_data_type8,
sum(browse_data) as sum_browse_data_type8
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=8
)t 
group by user_id_browse;



create table if not exists feature_browse_history_test_21 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type9,
min(browse_data) as min_browse_data_type9,
max(browse_data) as max_browse_data_type9,
sum(browse_data) as sum_browse_data_type9
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=9
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_22 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type10,
min(browse_data) as min_browse_data_type10,
max(browse_data) as max_browse_data_type10,
sum(browse_data) as sum_browse_data_type10
from
(
	select user_id_browse,browse_data from browse_history_test where browse_type=10
)t 
group by user_id_browse;




create table if not exists feature_browse_history_test_23 as
select user_id_browse,
avg(browse_data) as avg_browse_data_type11,
min(browse_data) as min_browse_data_type11,
max(browse_data) as max_browse_data_type11,
sum(browse_data) as sum_browse_data_type11
from
(
select user_id_browse,browse_data from browse_history_test where browse_type=11
)t 
group by user_id_browse;






create table if not exists feature_browse_history_test_temp1 as     
select a12.*,
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type11/browse_history_user_total end as browse_history_user_browse_type11_total_rate, 
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type10/browse_history_user_total end as browse_history_user_browse_type10_total_rate, 
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type9/browse_history_user_total end as browse_history_user_browse_type9_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type8/browse_history_user_total end as browse_history_user_browse_type8_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type7/browse_history_user_total end as browse_history_user_browse_type7_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type6/browse_history_user_total end as browse_history_user_browse_type6_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type5/browse_history_user_total end as browse_history_user_browse_type5_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type4/browse_history_user_total end as browse_history_user_browse_type4_total_rate,  
case when browse_history_user_total =0 then -1 else browse_history_user_browse_type3/browse_history_user_total end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type2/browse_history_user_total end as browse_history_user_browse_type2_total_rate,  
case when browse_history_user_total=0 then -1 else browse_history_user_browse_type1/browse_history_user_total end as browse_history_user_browse_type1_total_rate  
from
(
select a11.*,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11
from
(
select a10.*,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10
from
(
select a09.*,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9
from
(
select a08.*,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8
from
(
select a07.*,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7
from
(
select a06.*,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6
from
(
select a05.*,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5
from
(
select a04.*,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4
from
(
select a03.*,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3
from
(
select a02.*,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2
from
(
select a01.*,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1
from
feature_browse_history_test_0 a01 left outer join feature_browse_history_test_1 b01 
on a01.user_id_browse=b01.user_id_browse
)a02 left outer join feature_browse_history_test_2 b02 
on a02.user_id_browse=b02.user_id_browse
)a03 left outer join feature_browse_history_test_3 b03
on a03.user_id_browse=b03.user_id_browse 
)a04 left outer join feature_browse_history_test_4 b04
on a04.user_id_browse=b04.user_id_browse
)a05 left outer join feature_browse_history_test_5 b05 
on a05.user_id_browse=b05.user_id_browse
)a06 left outer join feature_browse_history_test_6 b06 
on a06.user_id_browse=b06.user_id_browse
)a07 left outer join feature_browse_history_test_7 b07 
on a07.user_id_browse=b07.user_id_browse
)a08 left outer join feature_browse_history_test_8 b08
on a08.user_id_browse=b08.user_id_browse
)a09 left outer join feature_browse_history_test_9 b09
on a09.user_id_browse=b09.user_id_browse
)a10 left outer join feature_browse_history_test_10 b10
on a10.user_id_browse=b10.user_id_browse
)a11  left outer join feature_browse_history_test_11 b11
on a11.user_id_browse=b11.user_id_browse
)a12;








create table if not exists feature_browse_history_test as
select g12.*,
case when min_browse_data=0 then -1 else min_browse_data_type1/min_browse_data end as min_browse_data_type1_in_total_rate, 
case when max_browse_data=0 then -1 else max_browse_data_type1/max_browse_data end as max_browse_data_type1_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type1/avg_browse_data end as avg_browse_data_type1_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type1/sum_browse_data end as sum_browse_data_type1_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type2/min_browse_data end as min_browse_data_type2_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type2/max_browse_data end as max_browse_data_type2_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type2/avg_browse_data end as avg_browse_data_type2_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type2/sum_browse_data end as sum_browse_data_type2_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type3/min_browse_data end as min_browse_data_type3_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type3/max_browse_data end as max_browse_data_type3_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type3/avg_browse_data end as avg_browse_data_type3_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type3/sum_browse_data end as sum_browse_data_type3_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type4/min_browse_data end as min_browse_data_type4_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type4/max_browse_data end as max_browse_data_type4_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type4/avg_browse_data end as avg_browse_data_type4_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type4/sum_browse_data end as sum_browse_data_type4_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type5/min_browse_data end as min_browse_data_type5_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type5/max_browse_data end as max_browse_data_type5_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type5/avg_browse_data end as avg_browse_data_type5_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type5/sum_browse_data end as sum_browse_data_type5_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type6/min_browse_data end as min_browse_data_type6_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type6/max_browse_data end as max_browse_data_type6_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type6/avg_browse_data end as avg_browse_data_type6_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type6/sum_browse_data end as sum_browse_data_type6_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type7/min_browse_data end as min_browse_data_type7_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type7/max_browse_data end as max_browse_data_type7_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type7/avg_browse_data end as avg_browse_data_type7_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type7/sum_browse_data end as sum_browse_data_type7_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type8/min_browse_data end as min_browse_data_type8_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type8/max_browse_data end as max_browse_data_type8_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type8/avg_browse_data end as avg_browse_data_type8_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type8/sum_browse_data end as sum_browse_data_type8_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type9/min_browse_data end as min_browse_data_type9_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type9/max_browse_data end as max_browse_data_type9_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type9/avg_browse_data end as avg_browse_data_type9_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type9/sum_browse_data end as sum_browse_data_type9_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type10/min_browse_data end as min_browse_data_type10_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type10/max_browse_data end as max_browse_data_type10_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type10/avg_browse_data end as avg_browse_data_type10_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type10/sum_browse_data end as sum_browse_data_type10_in_total_rate,
case when min_browse_data=0 then -1 else min_browse_data_type11/min_browse_data end as min_browse_data_type11_in_total_rate,
case when max_browse_data=0 then -1 else max_browse_data_type11/max_browse_data end as max_browse_data_type11_in_total_rate,
case when avg_browse_data=0 then -1 else avg_browse_data_type11/avg_browse_data end as avg_browse_data_type11_in_total_rate,
case when sum_browse_data=0 then -1 else sum_browse_data_type11/sum_browse_data end as sum_browse_data_type11_in_total_rate
from
(
select g11.*,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11
from
(
select g10.*,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10
from
(
select g9.*,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9
from
(
select g8.*,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8
from
(
select g7.*,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7
from
(
select g6.*,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6
from
(
select g5.*,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5
from
(
select g4.*,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4
from
(
select g3.*,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3
from
(
select g2.*,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2
from
(
select g1.*,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1
from
(
select g0.*,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data
from
feature_browse_history_test_temp1 g0 left outer join feature_browse_history_test_12 f0
on g0.user_id_browse=f0.user_id_browse
)g1 left outer join feature_browse_history_test_13 f1
on g1.user_id_browse=f1.user_id_browse
)g2 left outer join feature_browse_history_test_14 f2
on g2.user_id_browse=f2.user_id_browse
)g3 left outer join feature_browse_history_test_15 f3
on g3.user_id_browse=f3.user_id_browse
)g4 left outer join feature_browse_history_test_16 f4
on g4.user_id_browse=f4.user_id_browse
)g5 left outer join feature_browse_history_test_17 f5
on g5.user_id_browse=f5.user_id_browse
)g6 left outer join feature_browse_history_test_18 f6
on g6.user_id_browse=f6.user_id_browse
)g7 left outer join feature_browse_history_test_19 f7
on g7.user_id_browse=f7.user_id_browse
)g8 left outer join feature_browse_history_test_20 f8
on g8.user_id_browse=f8.user_id_browse
)g9 left outer join feature_browse_history_test_21 f9
on g9.user_id_browse=f9.user_id_browse
)g10 left outer join feature_browse_history_test_22 f10
on g10.user_id_browse=f10.user_id_browse
)g11 left outer join feature_browse_history_test_23 f11
on g11.user_id_browse=f11.user_id_browse
)g12;


    
    
    
--############ for bill_detail_train   


create table if not exists feature_bill_detail_train_1 as
select user_id_bill,count(*) as bill_detail_user_total from
(
	select user_id_bill from bill_detail_train
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_train_2 as
select user_id_bill,count(*) as bill_detail_user_last_bill_money_beyond_card_limit from
(
	select user_id_bill from bill_detail_train where last_bill_money > card_limit  
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_train_3 as
select user_id_bill,count(*) as bill_detail_user_this_bill_money_beyond_card_limit from
(
	select user_id_bill from bill_detail_train where this_bill_money > card_limit  
)t 
group by user_id_bill;

    

create table if not exists feature_bill_detail_train_4 as
select user_id_bill,count(*) as bill_detail_user_remain_money_beyond_this_bill_money from
(
	select user_id_bill from bill_detail_train where last_bill_money > card_limit  
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_train_5 as
select user_id_bill,count(*) as bill_detail_user_adjust_money_positive from
(
	select user_id_bill from bill_detail_train where adjust_money>0 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_train_6 as
select user_id_bill,
avg(last_bill_money) as avg_last_bill_money,
min(last_bill_money) as min_last_bill_money,
max(last_bill_money) as max_last_bill_money,
sum(last_bill_money) as sum_last_bill_money
from
(
	select user_id_bill,last_bill_money from bill_detail_train 
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_train_7 as
select user_id_bill,
avg(last_repay_money) as avg_last_repay_money,
min(last_repay_money) as min_last_repay_money,
max(last_repay_money) as max_last_repay_money,
sum(last_repay_money) as sum_last_repay_money
from
(
	select user_id_bill,last_repay_money from bill_detail_train 
)t 
group by user_id_bill;


create table if not exists feature_bill_detail_train_8 as
select user_id_bill,
avg(card_limit) as avg_card_limit,
min(card_limit) as min_card_limit,
max(card_limit) as max_card_limit,
sum(card_limit) as sum_card_limit
from
(
	select user_id_bill,card_limit from bill_detail_train 
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_train_9 as
select user_id_bill,
avg(this_bill_money_remain) as avg_this_bill_money_remain,
min(this_bill_money_remain) as min_this_bill_money_remain,
max(this_bill_money_remain) as max_this_bill_money_remain,
sum(this_bill_money_remain) as sum_this_bill_money_remain
from
(
	select user_id_bill,this_bill_money_remain from bill_detail_train 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_train_10 as
select user_id_bill,
avg(this_bill_min_repay) as avg_this_bill_min_repay,
min(this_bill_min_repay) as min_this_bill_min_repay,
max(this_bill_min_repay) as max_this_bill_min_repay,
sum(this_bill_min_repay) as sum_this_bill_min_repay
from
(
	select user_id_bill,this_bill_min_repay from bill_detail_train 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_train_11 as
select user_id_bill,
avg(buy_times) as avg_buy_times,
min(buy_times) as min_buy_times,
max(buy_times) as max_buy_times,
sum(buy_times) as sum_buy_times
from
(
	select user_id_bill,buy_times from bill_detail_train 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_train_12 as
select user_id_bill,
avg(this_bill_money) as avg_this_bill_money,
min(this_bill_money) as min_this_bill_money,
max(this_bill_money) as max_this_bill_money,
sum(this_bill_money) as sum_this_bill_money
from
(
	select user_id_bill,this_bill_money from bill_detail_train 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_train_13 as
select user_id_bill,
avg(adjust_money) as avg_adjust_money,
min(adjust_money) as min_adjust_money,
max(adjust_money) as max_adjust_money,
sum(adjust_money) as sum_adjust_money
from
(
	select user_id_bill,adjust_money from bill_detail_train 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_train_14 as
select user_id_bill,
avg(loop_interest) as avg_loop_interest,
min(loop_interest) as min_loop_interest,
max(loop_interest) as max_loop_interest,
sum(loop_interest) as sum_loop_interest
from
(
	select user_id_bill,loop_interest from bill_detail_train 
)t 
group by user_id_bill;





create table if not exists feature_bill_detail_train_15 as
select user_id_bill,
avg(remain_money) as avg_remain_money,
min(remain_money) as min_remain_money,
max(remain_money) as max_remain_money,
sum(remain_money) as sum_remain_money
from
(
	select user_id_bill,remain_money from bill_detail_train 
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_train_16 as
select user_id_bill,
avg(borrow_limit) as avg_borrow_limit,
min(borrow_limit) as min_borrow_limit,
max(borrow_limit) as max_borrow_limit,
sum(borrow_limit) as sum_borrow_limit
from
(
	select user_id_bill,borrow_limit from bill_detail_train 
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_train_17 as
select user_id_bill,count(*) as bill_detail_user_bank_count
from
(
    select distinct user_id_bill,bank_id from bill_detail_train 
)t
group by user_id_bill;




create table if not exists feature_bill_detail_train_temp1 as     
select a05.*,
case when bill_detail_user_total=0 then -1 else bill_detail_user_bank_count/bill_detail_user_total end as bill_detail_user_bank_count_total_rate,  
case when bill_detail_user_total =0 then -1 else bill_detail_user_remain_money_beyond_this_bill_money/bill_detail_user_total end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_total=0 then -1 else bill_detail_user_this_bill_money_beyond_card_limit/bill_detail_user_total end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate  
from
(
select a04.*,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count
from
(
select a03.*,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money
from
(
select a02.*,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit
from
(
select a01.*,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit
from
feature_bill_detail_train_1 a01 left outer join feature_bill_detail_train_2 b01 
on a01.user_id_bill=b01.user_id_bill
)a02 left outer join feature_bill_detail_train_3 b02 
on a02.user_id_bill=b02.user_id_bill
)a03 left outer join feature_bill_detail_train_4 b03
on a03.user_id_bill=b03.user_id_bill 
)a04 left outer join feature_bill_detail_train_17 b04
on a04.user_id_bill=b04.user_id_bill
)a05;  






create table if not exists feature_bill_detail_train as
select g11.*,
case when min_last_bill_money=0 then -1 else min_last_repay_money/min_last_bill_money end as min_last_repay_money_in_last_bill_money_rate, 
case when max_last_bill_money=0 then -1 else max_last_repay_money/max_last_bill_money end as max_last_repay_money_in_last_bill_money_rate,
case when avg_last_bill_money=0 then -1 else avg_last_repay_money/avg_last_bill_money end as avg_last_repay_money_in_last_bill_money_rate,
case when sum_last_bill_money=0 then -1 else sum_last_repay_money/sum_last_bill_money end as sum_last_repay_money_in_last_bill_money_rate,
case when min_card_limit=0 then -1 else min_last_bill_money/min_card_limit end as min_last_bill_money_in_card_limit_rate,
case when max_card_limit=0 then -1 else max_last_bill_money/max_card_limit end as max_last_bill_money_in_card_limit_rate,
case when avg_card_limit=0 then -1 else avg_last_bill_money/avg_card_limit end as avg_last_bill_money_in_card_limit_rate,
case when sum_card_limit=0 then -1 else sum_last_bill_money/sum_card_limit end as sum_last_bill_money_in_card_limit_rate,
case when min_card_limit=0 then -1 else min_this_bill_money/min_card_limit end as min_this_bill_money_in_card_limit_rate,
case when max_card_limit=0 then -1 else max_this_bill_money/max_card_limit end as max_this_bill_money_in_card_limit_rate,
case when avg_card_limit=0 then -1 else avg_this_bill_money/avg_card_limit end as avg_this_bill_money_in_card_limit_rate,
case when sum_card_limit=0 then -1 else sum_this_bill_money/sum_card_limit end as sum_this_bill_money_in_card_limit_rate,
case when min_card_limit=0 then -1 else min_remain_money/min_card_limit end as min_remain_money_in_card_limit_rate,
case when max_card_limit=0 then -1 else max_remain_money/max_card_limit end as max_remain_money_in_card_limit_rate,
case when avg_card_limit=0 then -1 else avg_remain_money/avg_card_limit end as avg_remain_money_in_card_limit_rate,
case when sum_card_limit=0 then -1 else sum_remain_money/sum_card_limit end as sum_remain_money_in_card_limit_rate,
case when min_card_limit=0 then -1 else min_borrow_limit/min_card_limit end as min_borrow_limit_in_card_limit_rate,
case when max_card_limit=0 then -1 else max_borrow_limit/max_card_limit end as max_borrow_limit_in_card_limit_rate,
case when avg_card_limit=0 then -1 else avg_borrow_limit/avg_card_limit end as avg_borrow_limit_in_card_limit_rate,
case when sum_card_limit=0 then -1 else sum_borrow_limit/sum_card_limit end as sum_borrow_limit_in_card_limit_rate,
case when min_this_bill_money=0 then -1 else min_this_bill_money_remain/min_this_bill_money end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money=0 then -1 else max_this_bill_money_remain/max_this_bill_money end as max_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money=0 then -1 else avg_this_bill_money_remain/avg_this_bill_money end as avg_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money=0 then -1 else sum_this_bill_money_remain/sum_this_bill_money end as sum_this_bill_money_remain_in_this_bill_money_rate
from
(
select g10.*,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit
from
(
select g9.*,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money
from
(
select g8.*,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest
from
(
select g7.*,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money
from
(
select g6.*,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money
from
(
select g5.*,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times
from
(
select g4.*,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay
from
(
select g3.*,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain
from
(
select g2.*,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit
from
(
select g1.*,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money
from
(
select g0.*,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money
from
feature_bill_detail_train_temp1 g0 left outer join feature_bill_detail_train_6  f0
on g0.user_id_bill=f0.user_id_bill
)g1 left outer join feature_bill_detail_train_7  f1
on g1.user_id_bill=f1.user_id_bill
)g2 left outer join feature_bill_detail_train_8  f2
on g2.user_id_bill=f2.user_id_bill
)g3 left outer join feature_bill_detail_train_9  f3
on g3.user_id_bill=f3.user_id_bill
)g4 left outer join feature_bill_detail_train_10 f4
on g4.user_id_bill=f4.user_id_bill
)g5 left outer join feature_bill_detail_train_11 f5
on g5.user_id_bill=f5.user_id_bill
)g6 left outer join feature_bill_detail_train_12 f6
on g6.user_id_bill=f6.user_id_bill
)g7 left outer join feature_bill_detail_train_13 f7
on g7.user_id_bill=f7.user_id_bill
)g8 left outer join feature_bill_detail_train_14 f8
on g8.user_id_bill=f8.user_id_bill
)g9 left outer join feature_bill_detail_train_15 f9
on g9.user_id_bill=f9.user_id_bill
)g10 left outer join feature_bill_detail_train_16 f10
on g10.user_id_bill=f10.user_id_bill
)g11; 


    
    




--############ for bill_detail_test   


create table if not exists feature_bill_detail_test_1 as
select user_id_bill,count(*) as bill_detail_user_total from
(
	select user_id_bill from bill_detail_test
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_test_2 as
select user_id_bill,count(*) as bill_detail_user_last_bill_money_beyond_card_limit from
(
	select user_id_bill from bill_detail_test where last_bill_money > card_limit  
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_test_3 as
select user_id_bill,count(*) as bill_detail_user_this_bill_money_beyond_card_limit from
(
	select user_id_bill from bill_detail_test where this_bill_money > card_limit  
)t 
group by user_id_bill;

    

create table if not exists feature_bill_detail_test_4 as
select user_id_bill,count(*) as bill_detail_user_remain_money_beyond_this_bill_money from
(
	select user_id_bill from bill_detail_test where last_bill_money > card_limit  
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_test_5 as
select user_id_bill,count(*) as bill_detail_user_adjust_money_positive from
(
	select user_id_bill from bill_detail_test where adjust_money>0 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_test_6 as
select user_id_bill,
avg(last_bill_money) as avg_last_bill_money,
min(last_bill_money) as min_last_bill_money,
max(last_bill_money) as max_last_bill_money,
sum(last_bill_money) as sum_last_bill_money
from
(
	select user_id_bill,last_bill_money from bill_detail_test 
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_test_7 as
select user_id_bill,
avg(last_repay_money) as avg_last_repay_money,
min(last_repay_money) as min_last_repay_money,
max(last_repay_money) as max_last_repay_money,
sum(last_repay_money) as sum_last_repay_money
from
(
	select user_id_bill,last_repay_money from bill_detail_test 
)t 
group by user_id_bill;


create table if not exists feature_bill_detail_test_8 as
select user_id_bill,
avg(card_limit) as avg_card_limit,
min(card_limit) as min_card_limit,
max(card_limit) as max_card_limit,
sum(card_limit) as sum_card_limit
from
(
	select user_id_bill,card_limit from bill_detail_test 
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_test_9 as
select user_id_bill,
avg(this_bill_money_remain) as avg_this_bill_money_remain,
min(this_bill_money_remain) as min_this_bill_money_remain,
max(this_bill_money_remain) as max_this_bill_money_remain,
sum(this_bill_money_remain) as sum_this_bill_money_remain
from
(
	select user_id_bill,this_bill_money_remain from bill_detail_test 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_test_10 as
select user_id_bill,
avg(this_bill_min_repay) as avg_this_bill_min_repay,
min(this_bill_min_repay) as min_this_bill_min_repay,
max(this_bill_min_repay) as max_this_bill_min_repay,
sum(this_bill_min_repay) as sum_this_bill_min_repay
from
(
	select user_id_bill,this_bill_min_repay from bill_detail_test 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_test_11 as
select user_id_bill,
avg(buy_times) as avg_buy_times,
min(buy_times) as min_buy_times,
max(buy_times) as max_buy_times,
sum(buy_times) as sum_buy_times
from
(
	select user_id_bill,buy_times from bill_detail_test 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_test_12 as
select user_id_bill,
avg(this_bill_money) as avg_this_bill_money,
min(this_bill_money) as min_this_bill_money,
max(this_bill_money) as max_this_bill_money,
sum(this_bill_money) as sum_this_bill_money
from
(
	select user_id_bill,this_bill_money from bill_detail_test 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_test_13 as
select user_id_bill,
avg(adjust_money) as avg_adjust_money,
min(adjust_money) as min_adjust_money,
max(adjust_money) as max_adjust_money,
sum(adjust_money) as sum_adjust_money
from
(
	select user_id_bill,adjust_money from bill_detail_test 
)t 
group by user_id_bill;




create table if not exists feature_bill_detail_test_14 as
select user_id_bill,
avg(loop_interest) as avg_loop_interest,
min(loop_interest) as min_loop_interest,
max(loop_interest) as max_loop_interest,
sum(loop_interest) as sum_loop_interest
from
(
	select user_id_bill,loop_interest from bill_detail_test 
)t 
group by user_id_bill;





create table if not exists feature_bill_detail_test_15 as
select user_id_bill,
avg(remain_money) as avg_remain_money,
min(remain_money) as min_remain_money,
max(remain_money) as max_remain_money,
sum(remain_money) as sum_remain_money
from
(
	select user_id_bill,remain_money from bill_detail_test 
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_test_16 as
select user_id_bill,
avg(borrow_limit) as avg_borrow_limit,
min(borrow_limit) as min_borrow_limit,
max(borrow_limit) as max_borrow_limit,
sum(borrow_limit) as sum_borrow_limit
from
(
	select user_id_bill,borrow_limit from bill_detail_test 
)t 
group by user_id_bill;



create table if not exists feature_bill_detail_test_17 as
select user_id_bill,count(*) as bill_detail_user_bank_count
from
(
    select distinct user_id_bill,bank_id from bill_detail_test 
)t
group by user_id_bill;




create table if not exists feature_bill_detail_test_temp1 as     
select a05.*,
case when bill_detail_user_total=0 then -1 else bill_detail_user_bank_count/bill_detail_user_total end as bill_detail_user_bank_count_total_rate,  
case when bill_detail_user_total =0 then -1 else bill_detail_user_remain_money_beyond_this_bill_money/bill_detail_user_total end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_total=0 then -1 else bill_detail_user_this_bill_money_beyond_card_limit/bill_detail_user_total end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate  
from
(
select a04.*,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count
from
(
select a03.*,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money
from
(
select a02.*,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit
from
(
select a01.*,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit
from
feature_bill_detail_test_1 a01 left outer join feature_bill_detail_test_2 b01 
on a01.user_id_bill=b01.user_id_bill
)a02 left outer join feature_bill_detail_test_3 b02 
on a02.user_id_bill=b02.user_id_bill
)a03 left outer join feature_bill_detail_test_4 b03
on a03.user_id_bill=b03.user_id_bill 
)a04 left outer join feature_bill_detail_test_17 b04
on a04.user_id_bill=b04.user_id_bill
)a05;  






--#### for bill_detail_test

create table if not exists feature_bill_detail_test as
select g11.*,
case when min_last_bill_money=0 then -1 else min_last_repay_money/min_last_bill_money end as min_last_repay_money_in_last_bill_money_rate, 
case when max_last_bill_money=0 then -1 else max_last_repay_money/max_last_bill_money end as max_last_repay_money_in_last_bill_money_rate,
case when avg_last_bill_money=0 then -1 else avg_last_repay_money/avg_last_bill_money end as avg_last_repay_money_in_last_bill_money_rate,
case when sum_last_bill_money=0 then -1 else sum_last_repay_money/sum_last_bill_money end as sum_last_repay_money_in_last_bill_money_rate,
case when min_card_limit=0 then -1 else min_last_bill_money/min_card_limit end as min_last_bill_money_in_card_limit_rate,
case when max_card_limit=0 then -1 else max_last_bill_money/max_card_limit end as max_last_bill_money_in_card_limit_rate,
case when avg_card_limit=0 then -1 else avg_last_bill_money/avg_card_limit end as avg_last_bill_money_in_card_limit_rate,
case when sum_card_limit=0 then -1 else sum_last_bill_money/sum_card_limit end as sum_last_bill_money_in_card_limit_rate,
case when min_card_limit=0 then -1 else min_this_bill_money/min_card_limit end as min_this_bill_money_in_card_limit_rate,
case when max_card_limit=0 then -1 else max_this_bill_money/max_card_limit end as max_this_bill_money_in_card_limit_rate,
case when avg_card_limit=0 then -1 else avg_this_bill_money/avg_card_limit end as avg_this_bill_money_in_card_limit_rate,
case when sum_card_limit=0 then -1 else sum_this_bill_money/sum_card_limit end as sum_this_bill_money_in_card_limit_rate,
case when min_card_limit=0 then -1 else min_remain_money/min_card_limit end as min_remain_money_in_card_limit_rate,
case when max_card_limit=0 then -1 else max_remain_money/max_card_limit end as max_remain_money_in_card_limit_rate,
case when avg_card_limit=0 then -1 else avg_remain_money/avg_card_limit end as avg_remain_money_in_card_limit_rate,
case when sum_card_limit=0 then -1 else sum_remain_money/sum_card_limit end as sum_remain_money_in_card_limit_rate,
case when min_card_limit=0 then -1 else min_borrow_limit/min_card_limit end as min_borrow_limit_in_card_limit_rate,
case when max_card_limit=0 then -1 else max_borrow_limit/max_card_limit end as max_borrow_limit_in_card_limit_rate,
case when avg_card_limit=0 then -1 else avg_borrow_limit/avg_card_limit end as avg_borrow_limit_in_card_limit_rate,
case when sum_card_limit=0 then -1 else sum_borrow_limit/sum_card_limit end as sum_borrow_limit_in_card_limit_rate,
case when min_this_bill_money=0 then -1 else min_this_bill_money_remain/min_this_bill_money end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money=0 then -1 else max_this_bill_money_remain/max_this_bill_money end as max_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money=0 then -1 else avg_this_bill_money_remain/avg_this_bill_money end as avg_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money=0 then -1 else sum_this_bill_money_remain/sum_this_bill_money end as sum_this_bill_money_remain_in_this_bill_money_rate
from
(
select g10.*,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit
from
(
select g9.*,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money
from
(
select g8.*,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest
from
(
select g7.*,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money
from
(
select g6.*,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money
from
(
select g5.*,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times
from
(
select g4.*,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay
from
(
select g3.*,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain
from
(
select g2.*,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit
from
(
select g1.*,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money
from
(
select g0.*,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money
from
feature_bill_detail_test_temp1 g0 left outer join feature_bill_detail_test_6  f0
on g0.user_id_bill=f0.user_id_bill
)g1 left outer join feature_bill_detail_test_7  f1
on g1.user_id_bill=f1.user_id_bill
)g2 left outer join feature_bill_detail_test_8  f2
on g2.user_id_bill=f2.user_id_bill
)g3 left outer join feature_bill_detail_test_9  f3
on g3.user_id_bill=f3.user_id_bill
)g4 left outer join feature_bill_detail_test_10 f4
on g4.user_id_bill=f4.user_id_bill
)g5 left outer join feature_bill_detail_test_11 f5
on g5.user_id_bill=f5.user_id_bill
)g6 left outer join feature_bill_detail_test_12 f6
on g6.user_id_bill=f6.user_id_bill
)g7 left outer join feature_bill_detail_test_13 f7
on g7.user_id_bill=f7.user_id_bill
)g8 left outer join feature_bill_detail_test_14 f8
on g8.user_id_bill=f8.user_id_bill
)g9 left outer join feature_bill_detail_test_15 f9
on g9.user_id_bill=f9.user_id_bill
)g10 left outer join feature_bill_detail_test_16 f10
on g10.user_id_bill=f10.user_id_bill
)g11; 


    
    

--##for user_info_train and overdue_train


create table if not exists feature_user_info_train as 
select a.*,
b.label 
from 
user_info_train a left outer join overdue_train b
on a.user_id = b.user_id_overdue;



--##for user_info_test and usersID_test


create table if not exists feature_user_info_test as 
select * 
from 
user_info_test; 














--##################  create gui_train_set ######################


create table if not exists gui_train_set as
select a03.*,
case when bill_detail_user_total is null then 0 else bill_detail_user_total end as bill_detail_user_total,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count,
case when bill_detail_user_bank_count_total_rate is null then 0 else bill_detail_user_bank_count_total_rate end as bill_detail_user_bank_count_total_rate,
case when bill_detail_user_remain_money_beyond_this_bill_money_total_rate is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money_total_rate end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_this_bill_money_beyond_card_limit_total_rate is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit_total_rate end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when min_last_repay_money_in_last_bill_money_rate is null then 0 else min_last_repay_money_in_last_bill_money_rate end as min_last_repay_money_in_last_bill_money_rate,
case when max_last_repay_money_in_last_bill_money_rate is null then 0 else max_last_repay_money_in_last_bill_money_rate end as max_last_repay_money_in_last_bill_money_rate,
case when sum_last_repay_money_in_last_bill_money_rate is null then 0 else sum_last_repay_money_in_last_bill_money_rate end as sum_last_repay_money_in_last_bill_money_rate,
case when avg_last_repay_money_in_last_bill_money_rate is null then 0 else avg_last_repay_money_in_last_bill_money_rate end as avg_last_repay_money_in_last_bill_money_rate,
case when min_last_bill_money_in_card_limit_rate is null then 0 else min_last_bill_money_in_card_limit_rate end as min_last_bill_money_in_card_limit_rate,
case when max_last_bill_money_in_card_limit_rate is null then 0 else max_last_bill_money_in_card_limit_rate end as max_last_bill_money_in_card_limit_rate,
case when sum_last_bill_money_in_card_limit_rate is null then 0 else sum_last_bill_money_in_card_limit_rate end as sum_last_bill_money_in_card_limit_rate,
case when avg_last_bill_money_in_card_limit_rate is null then 0 else avg_last_bill_money_in_card_limit_rate end as avg_last_bill_money_in_card_limit_rate,
case when min_this_bill_money_in_card_limit_rate is null then 0 else min_this_bill_money_in_card_limit_rate end as min_this_bill_money_in_card_limit_rate,
case when max_this_bill_money_in_card_limit_rate is null then 0 else max_this_bill_money_in_card_limit_rate end as max_this_bill_money_in_card_limit_rate,
case when sum_this_bill_money_in_card_limit_rate is null then 0 else sum_this_bill_money_in_card_limit_rate end as sum_this_bill_money_in_card_limit_rate,
case when avg_this_bill_money_in_card_limit_rate is null then 0 else avg_this_bill_money_in_card_limit_rate end as avg_this_bill_money_in_card_limit_rate,
case when min_remain_money_in_card_limit_rate is null then 0 else min_remain_money_in_card_limit_rate end as min_remain_money_in_card_limit_rate,
case when max_remain_money_in_card_limit_rate is null then 0 else max_remain_money_in_card_limit_rate end as max_remain_money_in_card_limit_rate,
case when sum_remain_money_in_card_limit_rate is null then 0 else sum_remain_money_in_card_limit_rate end as sum_remain_money_in_card_limit_rate,
case when avg_remain_money_in_card_limit_rate is null then 0 else avg_remain_money_in_card_limit_rate end as avg_remain_money_in_card_limit_rate,
case when min_borrow_limit_in_card_limit_rate is null then 0 else min_borrow_limit_in_card_limit_rate end as min_borrow_limit_in_card_limit_rate,
case when max_borrow_limit_in_card_limit_rate is null then 0 else max_borrow_limit_in_card_limit_rate end as max_borrow_limit_in_card_limit_rate,
case when sum_borrow_limit_in_card_limit_rate is null then 0 else sum_borrow_limit_in_card_limit_rate end as sum_borrow_limit_in_card_limit_rate,
case when avg_borrow_limit_in_card_limit_rate is null then 0 else avg_borrow_limit_in_card_limit_rate end as avg_borrow_limit_in_card_limit_rate,
case when min_this_bill_money_remain_in_this_bill_money_rate is null then 0 else min_this_bill_money_remain_in_this_bill_money_rate end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money_remain_in_this_bill_money_rate is null then 0 else max_this_bill_money_remain_in_this_bill_money_rate end as max_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money_remain_in_this_bill_money_rate is null then 0 else sum_this_bill_money_remain_in_this_bill_money_rate end as sum_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money_remain_in_this_bill_money_rate is null then 0 else avg_this_bill_money_remain_in_this_bill_money_rate end as avg_this_bill_money_remain_in_this_bill_money_rate
from
(
select a02.*,
case when bank_detail_user_total is null then 0 else bank_detail_user_total end as bank_detail_user_total,
case when bank_detail_user_deal_type1 is null then 0 else bank_detail_user_deal_type1 end as bank_detail_user_deal_type1,
case when bank_detail_user_deal_type0 is null then 0 else bank_detail_user_deal_type0 end as bank_detail_user_deal_type0,
case when bank_detail_user_salary0 is null then 0 else bank_detail_user_salary0 end as bank_detail_user_salary0,
case when bank_detail_user_salary1 is null then 0 else bank_detail_user_salary1 end as bank_detail_user_salary1,
case when bank_detail_user_salary0_type0 is null then 0 else bank_detail_user_salary0_type0 end as bank_detail_user_salary0_type0,
case when min_deal_money is null then 0 else min_deal_money end as min_deal_money,
case when max_deal_money is null then 0 else max_deal_money end as max_deal_money,
case when sum_deal_money is null then 0 else sum_deal_money end as sum_deal_money,
case when avg_deal_money is null then 0 else avg_deal_money end as avg_deal_money,
case when min_deal_money_type0 is null then 0 else min_deal_money_type0 end as min_deal_money_type0,
case when max_deal_money_type0 is null then 0 else max_deal_money_type0 end as max_deal_money_type0,
case when sum_deal_money_type0 is null then 0 else sum_deal_money_type0 end as sum_deal_money_type0,
case when avg_deal_money_type0 is null then 0 else avg_deal_money_type0 end as avg_deal_money_type0,
case when min_deal_money_type1 is null then 0 else min_deal_money_type1 end as min_deal_money_type1,
case when max_deal_money_type1 is null then 0 else max_deal_money_type1 end as max_deal_money_type1,
case when sum_deal_money_type1 is null then 0 else sum_deal_money_type1 end as sum_deal_money_type1,
case when avg_deal_money_type1 is null then 0 else avg_deal_money_type1 end as avg_deal_money_type1,
case when min_deal_money_salary0 is null then 0 else min_deal_money_salary0 end as min_deal_money_salary0,
case when max_deal_money_salary0 is null then 0 else max_deal_money_salary0 end as max_deal_money_salary0,
case when sum_deal_money_salary0 is null then 0 else sum_deal_money_salary0 end as sum_deal_money_salary0,
case when avg_deal_money_salary0 is null then 0 else avg_deal_money_salary0 end as avg_deal_money_salary0,
case when min_deal_money_salary1 is null then 0 else min_deal_money_salary1 end as min_deal_money_salary1,
case when max_deal_money_salary1 is null then 0 else max_deal_money_salary1 end as max_deal_money_salary1,
case when sum_deal_money_salary1 is null then 0 else sum_deal_money_salary1 end as sum_deal_money_salary1,
case when avg_deal_money_salary1 is null then 0 else avg_deal_money_salary1 end as avg_deal_money_salary1,
case when min_deal_money_salary0_type0 is null then 0 else min_deal_money_salary0_type0 end as min_deal_money_salary0_type0,
case when max_deal_money_salary0_type0 is null then 0 else max_deal_money_salary0_type0 end as max_deal_money_salary0_type0,
case when sum_deal_money_salary0_type0 is null then 0 else sum_deal_money_salary0_type0 end as sum_deal_money_salary0_type0,
case when avg_deal_money_salary0_type0 is null then 0 else avg_deal_money_salary0_type0 end as avg_deal_money_salary0_type0,
case when bank_detail_user_deal_type1_total_rate is null then 0 else bank_detail_user_deal_type1_total_rate end as bank_detail_user_deal_type1_total_rate,
case when bank_detail_user_salary0_total_rate is null then 0 else bank_detail_user_salary0_total_rate end as bank_detail_user_salary0_total_rate,
case when bank_detail_user_salary0_type0_in_type0_rate is null then 0 else bank_detail_user_salary0_type0_in_type0_rate end as bank_detail_user_salary0_type0_in_type0_rate,
case when bank_detail_user_salary0_type0_in_salary0_rate is null then 0 else bank_detail_user_salary0_type0_in_salary0_rate end as bank_detail_user_salary0_type0_in_salary0_rate,
case when sum_deal_money_type0_in_total_rate is null then 0 else sum_deal_money_type0_in_total_rate end as sum_deal_money_type0_in_total_rate,
case when avg_deal_money_type0_in_total_rate is null then 0 else avg_deal_money_type0_in_total_rate end as avg_deal_money_type0_in_total_rate,
case when sum_deal_money_salary0_in_total_rate is null then 0 else sum_deal_money_salary0_in_total_rate end as sum_deal_money_salary0_in_total_rate,
case when avg_deal_money_salary0_in_total_rate is null then 0 else avg_deal_money_salary0_in_total_rate end as avg_deal_money_salary0_in_total_rate,
case when sum_deal_money_salary0_type0_in_salary0_rate is null then 0 else sum_deal_money_salary0_type0_in_salary0_rate end as sum_deal_money_salary0_type0_in_salary0_rate,
case when avg_deal_money_salary0_type0_in_salary0_rate is null then 0 else avg_deal_money_salary0_type0_in_salary0_rate end as avg_deal_money_salary0_type0_in_salary0_rate,
case when sum_deal_money_salary0_type0_in_type0_rate is null then 0 else sum_deal_money_salary0_type0_in_type0_rate end as sum_deal_money_salary0_type0_in_type0_rate,
case when avg_deal_money_salary0_type0_in_type0_rate is null then 0 else avg_deal_money_salary0_type0_in_type0_rate end as avg_deal_money_salary0_type0_in_type0_rate
from
(
select a01.*,
case when browse_history_user_total is null then 0 else browse_history_user_total end as browse_history_user_total,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11,
case when browse_history_user_browse_type1_total_rate is null then 0 else browse_history_user_browse_type1_total_rate end as browse_history_user_browse_type1_total_rate,
case when browse_history_user_browse_type2_total_rate is null then 0 else browse_history_user_browse_type2_total_rate end as browse_history_user_browse_type2_total_rate,
case when browse_history_user_browse_type3_total_rate is null then 0 else browse_history_user_browse_type3_total_rate end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_browse_type4_total_rate is null then 0 else browse_history_user_browse_type4_total_rate end as browse_history_user_browse_type4_total_rate,
case when browse_history_user_browse_type5_total_rate is null then 0 else browse_history_user_browse_type5_total_rate end as browse_history_user_browse_type5_total_rate,
case when browse_history_user_browse_type6_total_rate is null then 0 else browse_history_user_browse_type6_total_rate end as browse_history_user_browse_type6_total_rate,
case when browse_history_user_browse_type7_total_rate is null then 0 else browse_history_user_browse_type7_total_rate end as browse_history_user_browse_type7_total_rate,
case when browse_history_user_browse_type8_total_rate is null then 0 else browse_history_user_browse_type8_total_rate end as browse_history_user_browse_type8_total_rate,
case when browse_history_user_browse_type9_total_rate is null then 0 else browse_history_user_browse_type9_total_rate end as browse_history_user_browse_type9_total_rate,
case when browse_history_user_browse_type10_total_rate is null then 0 else browse_history_user_browse_type10_total_rate end as browse_history_user_browse_type10_total_rate,
case when browse_history_user_browse_type11_total_rate is null then 0 else browse_history_user_browse_type11_total_rate end as browse_history_user_browse_type11_total_rate,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when min_browse_data_type1_in_total_rate is null then 0 else min_browse_data_type1_in_total_rate end as min_browse_data_type1_in_total_rate,
case when max_browse_data_type1_in_total_rate is null then 0 else max_browse_data_type1_in_total_rate end as max_browse_data_type1_in_total_rate,
case when sum_browse_data_type1_in_total_rate is null then 0 else sum_browse_data_type1_in_total_rate end as sum_browse_data_type1_in_total_rate,
case when avg_browse_data_type1_in_total_rate is null then 0 else avg_browse_data_type1_in_total_rate end as avg_browse_data_type1_in_total_rate,
case when min_browse_data_type2_in_total_rate is null then 0 else min_browse_data_type2_in_total_rate end as min_browse_data_type2_in_total_rate,
case when max_browse_data_type2_in_total_rate is null then 0 else max_browse_data_type2_in_total_rate end as max_browse_data_type2_in_total_rate,
case when sum_browse_data_type2_in_total_rate is null then 0 else sum_browse_data_type2_in_total_rate end as sum_browse_data_type2_in_total_rate,
case when avg_browse_data_type2_in_total_rate is null then 0 else avg_browse_data_type2_in_total_rate end as avg_browse_data_type2_in_total_rate,
case when min_browse_data_type3_in_total_rate is null then 0 else min_browse_data_type3_in_total_rate end as min_browse_data_type3_in_total_rate,
case when max_browse_data_type3_in_total_rate is null then 0 else max_browse_data_type3_in_total_rate end as max_browse_data_type3_in_total_rate,
case when sum_browse_data_type3_in_total_rate is null then 0 else sum_browse_data_type3_in_total_rate end as sum_browse_data_type3_in_total_rate,
case when avg_browse_data_type3_in_total_rate is null then 0 else avg_browse_data_type3_in_total_rate end as avg_browse_data_type3_in_total_rate,
case when min_browse_data_type4_in_total_rate is null then 0 else min_browse_data_type4_in_total_rate end as min_browse_data_type4_in_total_rate,
case when max_browse_data_type4_in_total_rate is null then 0 else max_browse_data_type4_in_total_rate end as max_browse_data_type4_in_total_rate,
case when sum_browse_data_type4_in_total_rate is null then 0 else sum_browse_data_type4_in_total_rate end as sum_browse_data_type4_in_total_rate,
case when avg_browse_data_type4_in_total_rate is null then 0 else avg_browse_data_type4_in_total_rate end as avg_browse_data_type4_in_total_rate,
case when min_browse_data_type5_in_total_rate is null then 0 else min_browse_data_type5_in_total_rate end as min_browse_data_type5_in_total_rate,
case when max_browse_data_type5_in_total_rate is null then 0 else max_browse_data_type5_in_total_rate end as max_browse_data_type5_in_total_rate,
case when sum_browse_data_type5_in_total_rate is null then 0 else sum_browse_data_type5_in_total_rate end as sum_browse_data_type5_in_total_rate,
case when avg_browse_data_type5_in_total_rate is null then 0 else avg_browse_data_type5_in_total_rate end as avg_browse_data_type5_in_total_rate,
case when min_browse_data_type6_in_total_rate is null then 0 else min_browse_data_type6_in_total_rate end as min_browse_data_type6_in_total_rate,
case when max_browse_data_type6_in_total_rate is null then 0 else max_browse_data_type6_in_total_rate end as max_browse_data_type6_in_total_rate,
case when sum_browse_data_type6_in_total_rate is null then 0 else sum_browse_data_type6_in_total_rate end as sum_browse_data_type6_in_total_rate,
case when avg_browse_data_type6_in_total_rate is null then 0 else avg_browse_data_type6_in_total_rate end as avg_browse_data_type6_in_total_rate,
case when min_browse_data_type7_in_total_rate is null then 0 else min_browse_data_type7_in_total_rate end as min_browse_data_type7_in_total_rate,
case when max_browse_data_type7_in_total_rate is null then 0 else max_browse_data_type7_in_total_rate end as max_browse_data_type7_in_total_rate,
case when sum_browse_data_type7_in_total_rate is null then 0 else sum_browse_data_type7_in_total_rate end as sum_browse_data_type7_in_total_rate,
case when avg_browse_data_type7_in_total_rate is null then 0 else avg_browse_data_type7_in_total_rate end as avg_browse_data_type7_in_total_rate,
case when min_browse_data_type8_in_total_rate is null then 0 else min_browse_data_type8_in_total_rate end as min_browse_data_type8_in_total_rate,
case when max_browse_data_type8_in_total_rate is null then 0 else max_browse_data_type8_in_total_rate end as max_browse_data_type8_in_total_rate,
case when sum_browse_data_type8_in_total_rate is null then 0 else sum_browse_data_type8_in_total_rate end as sum_browse_data_type8_in_total_rate,
case when avg_browse_data_type8_in_total_rate is null then 0 else avg_browse_data_type8_in_total_rate end as avg_browse_data_type8_in_total_rate,
case when min_browse_data_type9_in_total_rate is null then 0 else min_browse_data_type9_in_total_rate end as min_browse_data_type9_in_total_rate,
case when max_browse_data_type9_in_total_rate is null then 0 else max_browse_data_type9_in_total_rate end as max_browse_data_type9_in_total_rate,
case when sum_browse_data_type9_in_total_rate is null then 0 else sum_browse_data_type9_in_total_rate end as sum_browse_data_type9_in_total_rate,
case when avg_browse_data_type9_in_total_rate is null then 0 else avg_browse_data_type9_in_total_rate end as avg_browse_data_type9_in_total_rate,
case when min_browse_data_type10_in_total_rate is null then 0 else min_browse_data_type10_in_total_rate end as min_browse_data_type10_in_total_rate,
case when max_browse_data_type10_in_total_rate is null then 0 else max_browse_data_type10_in_total_rate end as max_browse_data_type10_in_total_rate,
case when sum_browse_data_type10_in_total_rate is null then 0 else sum_browse_data_type10_in_total_rate end as sum_browse_data_type10_in_total_rate,
case when avg_browse_data_type10_in_total_rate is null then 0 else avg_browse_data_type10_in_total_rate end as avg_browse_data_type10_in_total_rate,
case when min_browse_data_type11_in_total_rate is null then 0 else min_browse_data_type11_in_total_rate end as min_browse_data_type11_in_total_rate,
case when max_browse_data_type11_in_total_rate is null then 0 else max_browse_data_type11_in_total_rate end as max_browse_data_type11_in_total_rate,
case when sum_browse_data_type11_in_total_rate is null then 0 else sum_browse_data_type11_in_total_rate end as sum_browse_data_type11_in_total_rate,
case when avg_browse_data_type11_in_total_rate is null then 0 else avg_browse_data_type11_in_total_rate end as avg_browse_data_type11_in_total_rate
from
feature_user_info_train a01 left outer join feature_browse_history_train b01 
on a01.user_id=b01.user_id_browse
)a02 left outer join feature_bank_detail_train b02 
on a02.user_id=b02.user_id_bank
)a03 left outer join feature_bill_detail_train b03
on a03.user_id=b03.user_id_bill;






--##################  create gui_test_set ######################


create table if not exists gui_test_set as
select a03.*,
case when bill_detail_user_total is null then 0 else bill_detail_user_total end as bill_detail_user_total,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count,
case when bill_detail_user_bank_count_total_rate is null then 0 else bill_detail_user_bank_count_total_rate end as bill_detail_user_bank_count_total_rate,
case when bill_detail_user_remain_money_beyond_this_bill_money_total_rate is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money_total_rate end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_this_bill_money_beyond_card_limit_total_rate is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit_total_rate end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when min_last_repay_money_in_last_bill_money_rate is null then 0 else min_last_repay_money_in_last_bill_money_rate end as min_last_repay_money_in_last_bill_money_rate,
case when max_last_repay_money_in_last_bill_money_rate is null then 0 else max_last_repay_money_in_last_bill_money_rate end as max_last_repay_money_in_last_bill_money_rate,
case when sum_last_repay_money_in_last_bill_money_rate is null then 0 else sum_last_repay_money_in_last_bill_money_rate end as sum_last_repay_money_in_last_bill_money_rate,
case when avg_last_repay_money_in_last_bill_money_rate is null then 0 else avg_last_repay_money_in_last_bill_money_rate end as avg_last_repay_money_in_last_bill_money_rate,
case when min_last_bill_money_in_card_limit_rate is null then 0 else min_last_bill_money_in_card_limit_rate end as min_last_bill_money_in_card_limit_rate,
case when max_last_bill_money_in_card_limit_rate is null then 0 else max_last_bill_money_in_card_limit_rate end as max_last_bill_money_in_card_limit_rate,
case when sum_last_bill_money_in_card_limit_rate is null then 0 else sum_last_bill_money_in_card_limit_rate end as sum_last_bill_money_in_card_limit_rate,
case when avg_last_bill_money_in_card_limit_rate is null then 0 else avg_last_bill_money_in_card_limit_rate end as avg_last_bill_money_in_card_limit_rate,
case when min_this_bill_money_in_card_limit_rate is null then 0 else min_this_bill_money_in_card_limit_rate end as min_this_bill_money_in_card_limit_rate,
case when max_this_bill_money_in_card_limit_rate is null then 0 else max_this_bill_money_in_card_limit_rate end as max_this_bill_money_in_card_limit_rate,
case when sum_this_bill_money_in_card_limit_rate is null then 0 else sum_this_bill_money_in_card_limit_rate end as sum_this_bill_money_in_card_limit_rate,
case when avg_this_bill_money_in_card_limit_rate is null then 0 else avg_this_bill_money_in_card_limit_rate end as avg_this_bill_money_in_card_limit_rate,
case when min_remain_money_in_card_limit_rate is null then 0 else min_remain_money_in_card_limit_rate end as min_remain_money_in_card_limit_rate,
case when max_remain_money_in_card_limit_rate is null then 0 else max_remain_money_in_card_limit_rate end as max_remain_money_in_card_limit_rate,
case when sum_remain_money_in_card_limit_rate is null then 0 else sum_remain_money_in_card_limit_rate end as sum_remain_money_in_card_limit_rate,
case when avg_remain_money_in_card_limit_rate is null then 0 else avg_remain_money_in_card_limit_rate end as avg_remain_money_in_card_limit_rate,
case when min_borrow_limit_in_card_limit_rate is null then 0 else min_borrow_limit_in_card_limit_rate end as min_borrow_limit_in_card_limit_rate,
case when max_borrow_limit_in_card_limit_rate is null then 0 else max_borrow_limit_in_card_limit_rate end as max_borrow_limit_in_card_limit_rate,
case when sum_borrow_limit_in_card_limit_rate is null then 0 else sum_borrow_limit_in_card_limit_rate end as sum_borrow_limit_in_card_limit_rate,
case when avg_borrow_limit_in_card_limit_rate is null then 0 else avg_borrow_limit_in_card_limit_rate end as avg_borrow_limit_in_card_limit_rate,
case when min_this_bill_money_remain_in_this_bill_money_rate is null then 0 else min_this_bill_money_remain_in_this_bill_money_rate end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money_remain_in_this_bill_money_rate is null then 0 else max_this_bill_money_remain_in_this_bill_money_rate end as max_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money_remain_in_this_bill_money_rate is null then 0 else sum_this_bill_money_remain_in_this_bill_money_rate end as sum_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money_remain_in_this_bill_money_rate is null then 0 else avg_this_bill_money_remain_in_this_bill_money_rate end as avg_this_bill_money_remain_in_this_bill_money_rate
from
(
select a02.*,
case when bank_detail_user_total is null then 0 else bank_detail_user_total end as bank_detail_user_total,
case when bank_detail_user_deal_type1 is null then 0 else bank_detail_user_deal_type1 end as bank_detail_user_deal_type1,
case when bank_detail_user_deal_type0 is null then 0 else bank_detail_user_deal_type0 end as bank_detail_user_deal_type0,
case when bank_detail_user_salary0 is null then 0 else bank_detail_user_salary0 end as bank_detail_user_salary0,
case when bank_detail_user_salary1 is null then 0 else bank_detail_user_salary1 end as bank_detail_user_salary1,
case when bank_detail_user_salary0_type0 is null then 0 else bank_detail_user_salary0_type0 end as bank_detail_user_salary0_type0,
case when min_deal_money is null then 0 else min_deal_money end as min_deal_money,
case when max_deal_money is null then 0 else max_deal_money end as max_deal_money,
case when sum_deal_money is null then 0 else sum_deal_money end as sum_deal_money,
case when avg_deal_money is null then 0 else avg_deal_money end as avg_deal_money,
case when min_deal_money_type0 is null then 0 else min_deal_money_type0 end as min_deal_money_type0,
case when max_deal_money_type0 is null then 0 else max_deal_money_type0 end as max_deal_money_type0,
case when sum_deal_money_type0 is null then 0 else sum_deal_money_type0 end as sum_deal_money_type0,
case when avg_deal_money_type0 is null then 0 else avg_deal_money_type0 end as avg_deal_money_type0,
case when min_deal_money_type1 is null then 0 else min_deal_money_type1 end as min_deal_money_type1,
case when max_deal_money_type1 is null then 0 else max_deal_money_type1 end as max_deal_money_type1,
case when sum_deal_money_type1 is null then 0 else sum_deal_money_type1 end as sum_deal_money_type1,
case when avg_deal_money_type1 is null then 0 else avg_deal_money_type1 end as avg_deal_money_type1,
case when min_deal_money_salary0 is null then 0 else min_deal_money_salary0 end as min_deal_money_salary0,
case when max_deal_money_salary0 is null then 0 else max_deal_money_salary0 end as max_deal_money_salary0,
case when sum_deal_money_salary0 is null then 0 else sum_deal_money_salary0 end as sum_deal_money_salary0,
case when avg_deal_money_salary0 is null then 0 else avg_deal_money_salary0 end as avg_deal_money_salary0,
case when min_deal_money_salary1 is null then 0 else min_deal_money_salary1 end as min_deal_money_salary1,
case when max_deal_money_salary1 is null then 0 else max_deal_money_salary1 end as max_deal_money_salary1,
case when sum_deal_money_salary1 is null then 0 else sum_deal_money_salary1 end as sum_deal_money_salary1,
case when avg_deal_money_salary1 is null then 0 else avg_deal_money_salary1 end as avg_deal_money_salary1,
case when min_deal_money_salary0_type0 is null then 0 else min_deal_money_salary0_type0 end as min_deal_money_salary0_type0,
case when max_deal_money_salary0_type0 is null then 0 else max_deal_money_salary0_type0 end as max_deal_money_salary0_type0,
case when sum_deal_money_salary0_type0 is null then 0 else sum_deal_money_salary0_type0 end as sum_deal_money_salary0_type0,
case when avg_deal_money_salary0_type0 is null then 0 else avg_deal_money_salary0_type0 end as avg_deal_money_salary0_type0,
case when bank_detail_user_deal_type1_total_rate is null then 0 else bank_detail_user_deal_type1_total_rate end as bank_detail_user_deal_type1_total_rate,
case when bank_detail_user_salary0_total_rate is null then 0 else bank_detail_user_salary0_total_rate end as bank_detail_user_salary0_total_rate,
case when bank_detail_user_salary0_type0_in_type0_rate is null then 0 else bank_detail_user_salary0_type0_in_type0_rate end as bank_detail_user_salary0_type0_in_type0_rate,
case when bank_detail_user_salary0_type0_in_salary0_rate is null then 0 else bank_detail_user_salary0_type0_in_salary0_rate end as bank_detail_user_salary0_type0_in_salary0_rate,
case when sum_deal_money_type0_in_total_rate is null then 0 else sum_deal_money_type0_in_total_rate end as sum_deal_money_type0_in_total_rate,
case when avg_deal_money_type0_in_total_rate is null then 0 else avg_deal_money_type0_in_total_rate end as avg_deal_money_type0_in_total_rate,
case when sum_deal_money_salary0_in_total_rate is null then 0 else sum_deal_money_salary0_in_total_rate end as sum_deal_money_salary0_in_total_rate,
case when avg_deal_money_salary0_in_total_rate is null then 0 else avg_deal_money_salary0_in_total_rate end as avg_deal_money_salary0_in_total_rate,
case when sum_deal_money_salary0_type0_in_salary0_rate is null then 0 else sum_deal_money_salary0_type0_in_salary0_rate end as sum_deal_money_salary0_type0_in_salary0_rate,
case when avg_deal_money_salary0_type0_in_salary0_rate is null then 0 else avg_deal_money_salary0_type0_in_salary0_rate end as avg_deal_money_salary0_type0_in_salary0_rate,
case when sum_deal_money_salary0_type0_in_type0_rate is null then 0 else sum_deal_money_salary0_type0_in_type0_rate end as sum_deal_money_salary0_type0_in_type0_rate,
case when avg_deal_money_salary0_type0_in_type0_rate is null then 0 else avg_deal_money_salary0_type0_in_type0_rate end as avg_deal_money_salary0_type0_in_type0_rate
from
(
select a01.*,
case when browse_history_user_total is null then 0 else browse_history_user_total end as browse_history_user_total,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11,
case when browse_history_user_browse_type1_total_rate is null then 0 else browse_history_user_browse_type1_total_rate end as browse_history_user_browse_type1_total_rate,
case when browse_history_user_browse_type2_total_rate is null then 0 else browse_history_user_browse_type2_total_rate end as browse_history_user_browse_type2_total_rate,
case when browse_history_user_browse_type3_total_rate is null then 0 else browse_history_user_browse_type3_total_rate end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_browse_type4_total_rate is null then 0 else browse_history_user_browse_type4_total_rate end as browse_history_user_browse_type4_total_rate,
case when browse_history_user_browse_type5_total_rate is null then 0 else browse_history_user_browse_type5_total_rate end as browse_history_user_browse_type5_total_rate,
case when browse_history_user_browse_type6_total_rate is null then 0 else browse_history_user_browse_type6_total_rate end as browse_history_user_browse_type6_total_rate,
case when browse_history_user_browse_type7_total_rate is null then 0 else browse_history_user_browse_type7_total_rate end as browse_history_user_browse_type7_total_rate,
case when browse_history_user_browse_type8_total_rate is null then 0 else browse_history_user_browse_type8_total_rate end as browse_history_user_browse_type8_total_rate,
case when browse_history_user_browse_type9_total_rate is null then 0 else browse_history_user_browse_type9_total_rate end as browse_history_user_browse_type9_total_rate,
case when browse_history_user_browse_type10_total_rate is null then 0 else browse_history_user_browse_type10_total_rate end as browse_history_user_browse_type10_total_rate,
case when browse_history_user_browse_type11_total_rate is null then 0 else browse_history_user_browse_type11_total_rate end as browse_history_user_browse_type11_total_rate,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when min_browse_data_type1_in_total_rate is null then 0 else min_browse_data_type1_in_total_rate end as min_browse_data_type1_in_total_rate,
case when max_browse_data_type1_in_total_rate is null then 0 else max_browse_data_type1_in_total_rate end as max_browse_data_type1_in_total_rate,
case when sum_browse_data_type1_in_total_rate is null then 0 else sum_browse_data_type1_in_total_rate end as sum_browse_data_type1_in_total_rate,
case when avg_browse_data_type1_in_total_rate is null then 0 else avg_browse_data_type1_in_total_rate end as avg_browse_data_type1_in_total_rate,
case when min_browse_data_type2_in_total_rate is null then 0 else min_browse_data_type2_in_total_rate end as min_browse_data_type2_in_total_rate,
case when max_browse_data_type2_in_total_rate is null then 0 else max_browse_data_type2_in_total_rate end as max_browse_data_type2_in_total_rate,
case when sum_browse_data_type2_in_total_rate is null then 0 else sum_browse_data_type2_in_total_rate end as sum_browse_data_type2_in_total_rate,
case when avg_browse_data_type2_in_total_rate is null then 0 else avg_browse_data_type2_in_total_rate end as avg_browse_data_type2_in_total_rate,
case when min_browse_data_type3_in_total_rate is null then 0 else min_browse_data_type3_in_total_rate end as min_browse_data_type3_in_total_rate,
case when max_browse_data_type3_in_total_rate is null then 0 else max_browse_data_type3_in_total_rate end as max_browse_data_type3_in_total_rate,
case when sum_browse_data_type3_in_total_rate is null then 0 else sum_browse_data_type3_in_total_rate end as sum_browse_data_type3_in_total_rate,
case when avg_browse_data_type3_in_total_rate is null then 0 else avg_browse_data_type3_in_total_rate end as avg_browse_data_type3_in_total_rate,
case when min_browse_data_type4_in_total_rate is null then 0 else min_browse_data_type4_in_total_rate end as min_browse_data_type4_in_total_rate,
case when max_browse_data_type4_in_total_rate is null then 0 else max_browse_data_type4_in_total_rate end as max_browse_data_type4_in_total_rate,
case when sum_browse_data_type4_in_total_rate is null then 0 else sum_browse_data_type4_in_total_rate end as sum_browse_data_type4_in_total_rate,
case when avg_browse_data_type4_in_total_rate is null then 0 else avg_browse_data_type4_in_total_rate end as avg_browse_data_type4_in_total_rate,
case when min_browse_data_type5_in_total_rate is null then 0 else min_browse_data_type5_in_total_rate end as min_browse_data_type5_in_total_rate,
case when max_browse_data_type5_in_total_rate is null then 0 else max_browse_data_type5_in_total_rate end as max_browse_data_type5_in_total_rate,
case when sum_browse_data_type5_in_total_rate is null then 0 else sum_browse_data_type5_in_total_rate end as sum_browse_data_type5_in_total_rate,
case when avg_browse_data_type5_in_total_rate is null then 0 else avg_browse_data_type5_in_total_rate end as avg_browse_data_type5_in_total_rate,
case when min_browse_data_type6_in_total_rate is null then 0 else min_browse_data_type6_in_total_rate end as min_browse_data_type6_in_total_rate,
case when max_browse_data_type6_in_total_rate is null then 0 else max_browse_data_type6_in_total_rate end as max_browse_data_type6_in_total_rate,
case when sum_browse_data_type6_in_total_rate is null then 0 else sum_browse_data_type6_in_total_rate end as sum_browse_data_type6_in_total_rate,
case when avg_browse_data_type6_in_total_rate is null then 0 else avg_browse_data_type6_in_total_rate end as avg_browse_data_type6_in_total_rate,
case when min_browse_data_type7_in_total_rate is null then 0 else min_browse_data_type7_in_total_rate end as min_browse_data_type7_in_total_rate,
case when max_browse_data_type7_in_total_rate is null then 0 else max_browse_data_type7_in_total_rate end as max_browse_data_type7_in_total_rate,
case when sum_browse_data_type7_in_total_rate is null then 0 else sum_browse_data_type7_in_total_rate end as sum_browse_data_type7_in_total_rate,
case when avg_browse_data_type7_in_total_rate is null then 0 else avg_browse_data_type7_in_total_rate end as avg_browse_data_type7_in_total_rate,
case when min_browse_data_type8_in_total_rate is null then 0 else min_browse_data_type8_in_total_rate end as min_browse_data_type8_in_total_rate,
case when max_browse_data_type8_in_total_rate is null then 0 else max_browse_data_type8_in_total_rate end as max_browse_data_type8_in_total_rate,
case when sum_browse_data_type8_in_total_rate is null then 0 else sum_browse_data_type8_in_total_rate end as sum_browse_data_type8_in_total_rate,
case when avg_browse_data_type8_in_total_rate is null then 0 else avg_browse_data_type8_in_total_rate end as avg_browse_data_type8_in_total_rate,
case when min_browse_data_type9_in_total_rate is null then 0 else min_browse_data_type9_in_total_rate end as min_browse_data_type9_in_total_rate,
case when max_browse_data_type9_in_total_rate is null then 0 else max_browse_data_type9_in_total_rate end as max_browse_data_type9_in_total_rate,
case when sum_browse_data_type9_in_total_rate is null then 0 else sum_browse_data_type9_in_total_rate end as sum_browse_data_type9_in_total_rate,
case when avg_browse_data_type9_in_total_rate is null then 0 else avg_browse_data_type9_in_total_rate end as avg_browse_data_type9_in_total_rate,
case when min_browse_data_type10_in_total_rate is null then 0 else min_browse_data_type10_in_total_rate end as min_browse_data_type10_in_total_rate,
case when max_browse_data_type10_in_total_rate is null then 0 else max_browse_data_type10_in_total_rate end as max_browse_data_type10_in_total_rate,
case when sum_browse_data_type10_in_total_rate is null then 0 else sum_browse_data_type10_in_total_rate end as sum_browse_data_type10_in_total_rate,
case when avg_browse_data_type10_in_total_rate is null then 0 else avg_browse_data_type10_in_total_rate end as avg_browse_data_type10_in_total_rate,
case when min_browse_data_type11_in_total_rate is null then 0 else min_browse_data_type11_in_total_rate end as min_browse_data_type11_in_total_rate,
case when max_browse_data_type11_in_total_rate is null then 0 else max_browse_data_type11_in_total_rate end as max_browse_data_type11_in_total_rate,
case when sum_browse_data_type11_in_total_rate is null then 0 else sum_browse_data_type11_in_total_rate end as sum_browse_data_type11_in_total_rate,
case when avg_browse_data_type11_in_total_rate is null then 0 else avg_browse_data_type11_in_total_rate end as avg_browse_data_type11_in_total_rate
from
feature_user_info_test a01 left outer join feature_browse_history_test b01 
on a01.user_id=b01.user_id_browse
)a02 left outer join feature_bank_detail_test b02 
on a02.user_id=b02.user_id_bank
)a03 left outer join feature_bill_detail_test b03
on a03.user_id=b03.user_id_bill;







--##################  create gui_train_set_not_have_bank_detail ######################


create table if not exists gui_train_set_not_have_bank_detail as
select a03.*,
case when bill_detail_user_total is null then 0 else bill_detail_user_total end as bill_detail_user_total,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count,
case when bill_detail_user_bank_count_total_rate is null then 0 else bill_detail_user_bank_count_total_rate end as bill_detail_user_bank_count_total_rate,
case when bill_detail_user_remain_money_beyond_this_bill_money_total_rate is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money_total_rate end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_this_bill_money_beyond_card_limit_total_rate is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit_total_rate end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when min_last_repay_money_in_last_bill_money_rate is null then 0 else min_last_repay_money_in_last_bill_money_rate end as min_last_repay_money_in_last_bill_money_rate,
case when max_last_repay_money_in_last_bill_money_rate is null then 0 else max_last_repay_money_in_last_bill_money_rate end as max_last_repay_money_in_last_bill_money_rate,
case when sum_last_repay_money_in_last_bill_money_rate is null then 0 else sum_last_repay_money_in_last_bill_money_rate end as sum_last_repay_money_in_last_bill_money_rate,
case when avg_last_repay_money_in_last_bill_money_rate is null then 0 else avg_last_repay_money_in_last_bill_money_rate end as avg_last_repay_money_in_last_bill_money_rate,
case when min_last_bill_money_in_card_limit_rate is null then 0 else min_last_bill_money_in_card_limit_rate end as min_last_bill_money_in_card_limit_rate,
case when max_last_bill_money_in_card_limit_rate is null then 0 else max_last_bill_money_in_card_limit_rate end as max_last_bill_money_in_card_limit_rate,
case when sum_last_bill_money_in_card_limit_rate is null then 0 else sum_last_bill_money_in_card_limit_rate end as sum_last_bill_money_in_card_limit_rate,
case when avg_last_bill_money_in_card_limit_rate is null then 0 else avg_last_bill_money_in_card_limit_rate end as avg_last_bill_money_in_card_limit_rate,
case when min_this_bill_money_in_card_limit_rate is null then 0 else min_this_bill_money_in_card_limit_rate end as min_this_bill_money_in_card_limit_rate,
case when max_this_bill_money_in_card_limit_rate is null then 0 else max_this_bill_money_in_card_limit_rate end as max_this_bill_money_in_card_limit_rate,
case when sum_this_bill_money_in_card_limit_rate is null then 0 else sum_this_bill_money_in_card_limit_rate end as sum_this_bill_money_in_card_limit_rate,
case when avg_this_bill_money_in_card_limit_rate is null then 0 else avg_this_bill_money_in_card_limit_rate end as avg_this_bill_money_in_card_limit_rate,
case when min_remain_money_in_card_limit_rate is null then 0 else min_remain_money_in_card_limit_rate end as min_remain_money_in_card_limit_rate,
case when max_remain_money_in_card_limit_rate is null then 0 else max_remain_money_in_card_limit_rate end as max_remain_money_in_card_limit_rate,
case when sum_remain_money_in_card_limit_rate is null then 0 else sum_remain_money_in_card_limit_rate end as sum_remain_money_in_card_limit_rate,
case when avg_remain_money_in_card_limit_rate is null then 0 else avg_remain_money_in_card_limit_rate end as avg_remain_money_in_card_limit_rate,
case when min_borrow_limit_in_card_limit_rate is null then 0 else min_borrow_limit_in_card_limit_rate end as min_borrow_limit_in_card_limit_rate,
case when max_borrow_limit_in_card_limit_rate is null then 0 else max_borrow_limit_in_card_limit_rate end as max_borrow_limit_in_card_limit_rate,
case when sum_borrow_limit_in_card_limit_rate is null then 0 else sum_borrow_limit_in_card_limit_rate end as sum_borrow_limit_in_card_limit_rate,
case when avg_borrow_limit_in_card_limit_rate is null then 0 else avg_borrow_limit_in_card_limit_rate end as avg_borrow_limit_in_card_limit_rate,
case when min_this_bill_money_remain_in_this_bill_money_rate is null then 0 else min_this_bill_money_remain_in_this_bill_money_rate end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money_remain_in_this_bill_money_rate is null then 0 else max_this_bill_money_remain_in_this_bill_money_rate end as max_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money_remain_in_this_bill_money_rate is null then 0 else sum_this_bill_money_remain_in_this_bill_money_rate end as sum_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money_remain_in_this_bill_money_rate is null then 0 else avg_this_bill_money_remain_in_this_bill_money_rate end as avg_this_bill_money_remain_in_this_bill_money_rate
from
(
select a01.*,
case when browse_history_user_total is null then 0 else browse_history_user_total end as browse_history_user_total,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11,
case when browse_history_user_browse_type1_total_rate is null then 0 else browse_history_user_browse_type1_total_rate end as browse_history_user_browse_type1_total_rate,
case when browse_history_user_browse_type2_total_rate is null then 0 else browse_history_user_browse_type2_total_rate end as browse_history_user_browse_type2_total_rate,
case when browse_history_user_browse_type3_total_rate is null then 0 else browse_history_user_browse_type3_total_rate end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_browse_type4_total_rate is null then 0 else browse_history_user_browse_type4_total_rate end as browse_history_user_browse_type4_total_rate,
case when browse_history_user_browse_type5_total_rate is null then 0 else browse_history_user_browse_type5_total_rate end as browse_history_user_browse_type5_total_rate,
case when browse_history_user_browse_type6_total_rate is null then 0 else browse_history_user_browse_type6_total_rate end as browse_history_user_browse_type6_total_rate,
case when browse_history_user_browse_type7_total_rate is null then 0 else browse_history_user_browse_type7_total_rate end as browse_history_user_browse_type7_total_rate,
case when browse_history_user_browse_type8_total_rate is null then 0 else browse_history_user_browse_type8_total_rate end as browse_history_user_browse_type8_total_rate,
case when browse_history_user_browse_type9_total_rate is null then 0 else browse_history_user_browse_type9_total_rate end as browse_history_user_browse_type9_total_rate,
case when browse_history_user_browse_type10_total_rate is null then 0 else browse_history_user_browse_type10_total_rate end as browse_history_user_browse_type10_total_rate,
case when browse_history_user_browse_type11_total_rate is null then 0 else browse_history_user_browse_type11_total_rate end as browse_history_user_browse_type11_total_rate,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when min_browse_data_type1_in_total_rate is null then 0 else min_browse_data_type1_in_total_rate end as min_browse_data_type1_in_total_rate,
case when max_browse_data_type1_in_total_rate is null then 0 else max_browse_data_type1_in_total_rate end as max_browse_data_type1_in_total_rate,
case when sum_browse_data_type1_in_total_rate is null then 0 else sum_browse_data_type1_in_total_rate end as sum_browse_data_type1_in_total_rate,
case when avg_browse_data_type1_in_total_rate is null then 0 else avg_browse_data_type1_in_total_rate end as avg_browse_data_type1_in_total_rate,
case when min_browse_data_type2_in_total_rate is null then 0 else min_browse_data_type2_in_total_rate end as min_browse_data_type2_in_total_rate,
case when max_browse_data_type2_in_total_rate is null then 0 else max_browse_data_type2_in_total_rate end as max_browse_data_type2_in_total_rate,
case when sum_browse_data_type2_in_total_rate is null then 0 else sum_browse_data_type2_in_total_rate end as sum_browse_data_type2_in_total_rate,
case when avg_browse_data_type2_in_total_rate is null then 0 else avg_browse_data_type2_in_total_rate end as avg_browse_data_type2_in_total_rate,
case when min_browse_data_type3_in_total_rate is null then 0 else min_browse_data_type3_in_total_rate end as min_browse_data_type3_in_total_rate,
case when max_browse_data_type3_in_total_rate is null then 0 else max_browse_data_type3_in_total_rate end as max_browse_data_type3_in_total_rate,
case when sum_browse_data_type3_in_total_rate is null then 0 else sum_browse_data_type3_in_total_rate end as sum_browse_data_type3_in_total_rate,
case when avg_browse_data_type3_in_total_rate is null then 0 else avg_browse_data_type3_in_total_rate end as avg_browse_data_type3_in_total_rate,
case when min_browse_data_type4_in_total_rate is null then 0 else min_browse_data_type4_in_total_rate end as min_browse_data_type4_in_total_rate,
case when max_browse_data_type4_in_total_rate is null then 0 else max_browse_data_type4_in_total_rate end as max_browse_data_type4_in_total_rate,
case when sum_browse_data_type4_in_total_rate is null then 0 else sum_browse_data_type4_in_total_rate end as sum_browse_data_type4_in_total_rate,
case when avg_browse_data_type4_in_total_rate is null then 0 else avg_browse_data_type4_in_total_rate end as avg_browse_data_type4_in_total_rate,
case when min_browse_data_type5_in_total_rate is null then 0 else min_browse_data_type5_in_total_rate end as min_browse_data_type5_in_total_rate,
case when max_browse_data_type5_in_total_rate is null then 0 else max_browse_data_type5_in_total_rate end as max_browse_data_type5_in_total_rate,
case when sum_browse_data_type5_in_total_rate is null then 0 else sum_browse_data_type5_in_total_rate end as sum_browse_data_type5_in_total_rate,
case when avg_browse_data_type5_in_total_rate is null then 0 else avg_browse_data_type5_in_total_rate end as avg_browse_data_type5_in_total_rate,
case when min_browse_data_type6_in_total_rate is null then 0 else min_browse_data_type6_in_total_rate end as min_browse_data_type6_in_total_rate,
case when max_browse_data_type6_in_total_rate is null then 0 else max_browse_data_type6_in_total_rate end as max_browse_data_type6_in_total_rate,
case when sum_browse_data_type6_in_total_rate is null then 0 else sum_browse_data_type6_in_total_rate end as sum_browse_data_type6_in_total_rate,
case when avg_browse_data_type6_in_total_rate is null then 0 else avg_browse_data_type6_in_total_rate end as avg_browse_data_type6_in_total_rate,
case when min_browse_data_type7_in_total_rate is null then 0 else min_browse_data_type7_in_total_rate end as min_browse_data_type7_in_total_rate,
case when max_browse_data_type7_in_total_rate is null then 0 else max_browse_data_type7_in_total_rate end as max_browse_data_type7_in_total_rate,
case when sum_browse_data_type7_in_total_rate is null then 0 else sum_browse_data_type7_in_total_rate end as sum_browse_data_type7_in_total_rate,
case when avg_browse_data_type7_in_total_rate is null then 0 else avg_browse_data_type7_in_total_rate end as avg_browse_data_type7_in_total_rate,
case when min_browse_data_type8_in_total_rate is null then 0 else min_browse_data_type8_in_total_rate end as min_browse_data_type8_in_total_rate,
case when max_browse_data_type8_in_total_rate is null then 0 else max_browse_data_type8_in_total_rate end as max_browse_data_type8_in_total_rate,
case when sum_browse_data_type8_in_total_rate is null then 0 else sum_browse_data_type8_in_total_rate end as sum_browse_data_type8_in_total_rate,
case when avg_browse_data_type8_in_total_rate is null then 0 else avg_browse_data_type8_in_total_rate end as avg_browse_data_type8_in_total_rate,
case when min_browse_data_type9_in_total_rate is null then 0 else min_browse_data_type9_in_total_rate end as min_browse_data_type9_in_total_rate,
case when max_browse_data_type9_in_total_rate is null then 0 else max_browse_data_type9_in_total_rate end as max_browse_data_type9_in_total_rate,
case when sum_browse_data_type9_in_total_rate is null then 0 else sum_browse_data_type9_in_total_rate end as sum_browse_data_type9_in_total_rate,
case when avg_browse_data_type9_in_total_rate is null then 0 else avg_browse_data_type9_in_total_rate end as avg_browse_data_type9_in_total_rate,
case when min_browse_data_type10_in_total_rate is null then 0 else min_browse_data_type10_in_total_rate end as min_browse_data_type10_in_total_rate,
case when max_browse_data_type10_in_total_rate is null then 0 else max_browse_data_type10_in_total_rate end as max_browse_data_type10_in_total_rate,
case when sum_browse_data_type10_in_total_rate is null then 0 else sum_browse_data_type10_in_total_rate end as sum_browse_data_type10_in_total_rate,
case when avg_browse_data_type10_in_total_rate is null then 0 else avg_browse_data_type10_in_total_rate end as avg_browse_data_type10_in_total_rate,
case when min_browse_data_type11_in_total_rate is null then 0 else min_browse_data_type11_in_total_rate end as min_browse_data_type11_in_total_rate,
case when max_browse_data_type11_in_total_rate is null then 0 else max_browse_data_type11_in_total_rate end as max_browse_data_type11_in_total_rate,
case when sum_browse_data_type11_in_total_rate is null then 0 else sum_browse_data_type11_in_total_rate end as sum_browse_data_type11_in_total_rate,
case when avg_browse_data_type11_in_total_rate is null then 0 else avg_browse_data_type11_in_total_rate end as avg_browse_data_type11_in_total_rate
from
feature_user_info_train a01 left outer join feature_browse_history_train b01 
on a01.user_id=b01.user_id_browse
)a03 left outer join feature_bill_detail_train b03
on a03.user_id=b03.user_id_bill;






--##################  create gui_test_set_not_have_bank_detail ######################


create table if not exists gui_test_set_not_have_bank_detail as
select a03.*,
case when bill_detail_user_total is null then 0 else bill_detail_user_total end as bill_detail_user_total,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count,
case when bill_detail_user_bank_count_total_rate is null then 0 else bill_detail_user_bank_count_total_rate end as bill_detail_user_bank_count_total_rate,
case when bill_detail_user_remain_money_beyond_this_bill_money_total_rate is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money_total_rate end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_this_bill_money_beyond_card_limit_total_rate is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit_total_rate end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when min_last_repay_money_in_last_bill_money_rate is null then 0 else min_last_repay_money_in_last_bill_money_rate end as min_last_repay_money_in_last_bill_money_rate,
case when max_last_repay_money_in_last_bill_money_rate is null then 0 else max_last_repay_money_in_last_bill_money_rate end as max_last_repay_money_in_last_bill_money_rate,
case when sum_last_repay_money_in_last_bill_money_rate is null then 0 else sum_last_repay_money_in_last_bill_money_rate end as sum_last_repay_money_in_last_bill_money_rate,
case when avg_last_repay_money_in_last_bill_money_rate is null then 0 else avg_last_repay_money_in_last_bill_money_rate end as avg_last_repay_money_in_last_bill_money_rate,
case when min_last_bill_money_in_card_limit_rate is null then 0 else min_last_bill_money_in_card_limit_rate end as min_last_bill_money_in_card_limit_rate,
case when max_last_bill_money_in_card_limit_rate is null then 0 else max_last_bill_money_in_card_limit_rate end as max_last_bill_money_in_card_limit_rate,
case when sum_last_bill_money_in_card_limit_rate is null then 0 else sum_last_bill_money_in_card_limit_rate end as sum_last_bill_money_in_card_limit_rate,
case when avg_last_bill_money_in_card_limit_rate is null then 0 else avg_last_bill_money_in_card_limit_rate end as avg_last_bill_money_in_card_limit_rate,
case when min_this_bill_money_in_card_limit_rate is null then 0 else min_this_bill_money_in_card_limit_rate end as min_this_bill_money_in_card_limit_rate,
case when max_this_bill_money_in_card_limit_rate is null then 0 else max_this_bill_money_in_card_limit_rate end as max_this_bill_money_in_card_limit_rate,
case when sum_this_bill_money_in_card_limit_rate is null then 0 else sum_this_bill_money_in_card_limit_rate end as sum_this_bill_money_in_card_limit_rate,
case when avg_this_bill_money_in_card_limit_rate is null then 0 else avg_this_bill_money_in_card_limit_rate end as avg_this_bill_money_in_card_limit_rate,
case when min_remain_money_in_card_limit_rate is null then 0 else min_remain_money_in_card_limit_rate end as min_remain_money_in_card_limit_rate,
case when max_remain_money_in_card_limit_rate is null then 0 else max_remain_money_in_card_limit_rate end as max_remain_money_in_card_limit_rate,
case when sum_remain_money_in_card_limit_rate is null then 0 else sum_remain_money_in_card_limit_rate end as sum_remain_money_in_card_limit_rate,
case when avg_remain_money_in_card_limit_rate is null then 0 else avg_remain_money_in_card_limit_rate end as avg_remain_money_in_card_limit_rate,
case when min_borrow_limit_in_card_limit_rate is null then 0 else min_borrow_limit_in_card_limit_rate end as min_borrow_limit_in_card_limit_rate,
case when max_borrow_limit_in_card_limit_rate is null then 0 else max_borrow_limit_in_card_limit_rate end as max_borrow_limit_in_card_limit_rate,
case when sum_borrow_limit_in_card_limit_rate is null then 0 else sum_borrow_limit_in_card_limit_rate end as sum_borrow_limit_in_card_limit_rate,
case when avg_borrow_limit_in_card_limit_rate is null then 0 else avg_borrow_limit_in_card_limit_rate end as avg_borrow_limit_in_card_limit_rate,
case when min_this_bill_money_remain_in_this_bill_money_rate is null then 0 else min_this_bill_money_remain_in_this_bill_money_rate end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money_remain_in_this_bill_money_rate is null then 0 else max_this_bill_money_remain_in_this_bill_money_rate end as max_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money_remain_in_this_bill_money_rate is null then 0 else sum_this_bill_money_remain_in_this_bill_money_rate end as sum_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money_remain_in_this_bill_money_rate is null then 0 else avg_this_bill_money_remain_in_this_bill_money_rate end as avg_this_bill_money_remain_in_this_bill_money_rate
from
(
select a01.*,
case when browse_history_user_total is null then 0 else browse_history_user_total end as browse_history_user_total,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11,
case when browse_history_user_browse_type1_total_rate is null then 0 else browse_history_user_browse_type1_total_rate end as browse_history_user_browse_type1_total_rate,
case when browse_history_user_browse_type2_total_rate is null then 0 else browse_history_user_browse_type2_total_rate end as browse_history_user_browse_type2_total_rate,
case when browse_history_user_browse_type3_total_rate is null then 0 else browse_history_user_browse_type3_total_rate end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_browse_type4_total_rate is null then 0 else browse_history_user_browse_type4_total_rate end as browse_history_user_browse_type4_total_rate,
case when browse_history_user_browse_type5_total_rate is null then 0 else browse_history_user_browse_type5_total_rate end as browse_history_user_browse_type5_total_rate,
case when browse_history_user_browse_type6_total_rate is null then 0 else browse_history_user_browse_type6_total_rate end as browse_history_user_browse_type6_total_rate,
case when browse_history_user_browse_type7_total_rate is null then 0 else browse_history_user_browse_type7_total_rate end as browse_history_user_browse_type7_total_rate,
case when browse_history_user_browse_type8_total_rate is null then 0 else browse_history_user_browse_type8_total_rate end as browse_history_user_browse_type8_total_rate,
case when browse_history_user_browse_type9_total_rate is null then 0 else browse_history_user_browse_type9_total_rate end as browse_history_user_browse_type9_total_rate,
case when browse_history_user_browse_type10_total_rate is null then 0 else browse_history_user_browse_type10_total_rate end as browse_history_user_browse_type10_total_rate,
case when browse_history_user_browse_type11_total_rate is null then 0 else browse_history_user_browse_type11_total_rate end as browse_history_user_browse_type11_total_rate,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when min_browse_data_type1_in_total_rate is null then 0 else min_browse_data_type1_in_total_rate end as min_browse_data_type1_in_total_rate,
case when max_browse_data_type1_in_total_rate is null then 0 else max_browse_data_type1_in_total_rate end as max_browse_data_type1_in_total_rate,
case when sum_browse_data_type1_in_total_rate is null then 0 else sum_browse_data_type1_in_total_rate end as sum_browse_data_type1_in_total_rate,
case when avg_browse_data_type1_in_total_rate is null then 0 else avg_browse_data_type1_in_total_rate end as avg_browse_data_type1_in_total_rate,
case when min_browse_data_type2_in_total_rate is null then 0 else min_browse_data_type2_in_total_rate end as min_browse_data_type2_in_total_rate,
case when max_browse_data_type2_in_total_rate is null then 0 else max_browse_data_type2_in_total_rate end as max_browse_data_type2_in_total_rate,
case when sum_browse_data_type2_in_total_rate is null then 0 else sum_browse_data_type2_in_total_rate end as sum_browse_data_type2_in_total_rate,
case when avg_browse_data_type2_in_total_rate is null then 0 else avg_browse_data_type2_in_total_rate end as avg_browse_data_type2_in_total_rate,
case when min_browse_data_type3_in_total_rate is null then 0 else min_browse_data_type3_in_total_rate end as min_browse_data_type3_in_total_rate,
case when max_browse_data_type3_in_total_rate is null then 0 else max_browse_data_type3_in_total_rate end as max_browse_data_type3_in_total_rate,
case when sum_browse_data_type3_in_total_rate is null then 0 else sum_browse_data_type3_in_total_rate end as sum_browse_data_type3_in_total_rate,
case when avg_browse_data_type3_in_total_rate is null then 0 else avg_browse_data_type3_in_total_rate end as avg_browse_data_type3_in_total_rate,
case when min_browse_data_type4_in_total_rate is null then 0 else min_browse_data_type4_in_total_rate end as min_browse_data_type4_in_total_rate,
case when max_browse_data_type4_in_total_rate is null then 0 else max_browse_data_type4_in_total_rate end as max_browse_data_type4_in_total_rate,
case when sum_browse_data_type4_in_total_rate is null then 0 else sum_browse_data_type4_in_total_rate end as sum_browse_data_type4_in_total_rate,
case when avg_browse_data_type4_in_total_rate is null then 0 else avg_browse_data_type4_in_total_rate end as avg_browse_data_type4_in_total_rate,
case when min_browse_data_type5_in_total_rate is null then 0 else min_browse_data_type5_in_total_rate end as min_browse_data_type5_in_total_rate,
case when max_browse_data_type5_in_total_rate is null then 0 else max_browse_data_type5_in_total_rate end as max_browse_data_type5_in_total_rate,
case when sum_browse_data_type5_in_total_rate is null then 0 else sum_browse_data_type5_in_total_rate end as sum_browse_data_type5_in_total_rate,
case when avg_browse_data_type5_in_total_rate is null then 0 else avg_browse_data_type5_in_total_rate end as avg_browse_data_type5_in_total_rate,
case when min_browse_data_type6_in_total_rate is null then 0 else min_browse_data_type6_in_total_rate end as min_browse_data_type6_in_total_rate,
case when max_browse_data_type6_in_total_rate is null then 0 else max_browse_data_type6_in_total_rate end as max_browse_data_type6_in_total_rate,
case when sum_browse_data_type6_in_total_rate is null then 0 else sum_browse_data_type6_in_total_rate end as sum_browse_data_type6_in_total_rate,
case when avg_browse_data_type6_in_total_rate is null then 0 else avg_browse_data_type6_in_total_rate end as avg_browse_data_type6_in_total_rate,
case when min_browse_data_type7_in_total_rate is null then 0 else min_browse_data_type7_in_total_rate end as min_browse_data_type7_in_total_rate,
case when max_browse_data_type7_in_total_rate is null then 0 else max_browse_data_type7_in_total_rate end as max_browse_data_type7_in_total_rate,
case when sum_browse_data_type7_in_total_rate is null then 0 else sum_browse_data_type7_in_total_rate end as sum_browse_data_type7_in_total_rate,
case when avg_browse_data_type7_in_total_rate is null then 0 else avg_browse_data_type7_in_total_rate end as avg_browse_data_type7_in_total_rate,
case when min_browse_data_type8_in_total_rate is null then 0 else min_browse_data_type8_in_total_rate end as min_browse_data_type8_in_total_rate,
case when max_browse_data_type8_in_total_rate is null then 0 else max_browse_data_type8_in_total_rate end as max_browse_data_type8_in_total_rate,
case when sum_browse_data_type8_in_total_rate is null then 0 else sum_browse_data_type8_in_total_rate end as sum_browse_data_type8_in_total_rate,
case when avg_browse_data_type8_in_total_rate is null then 0 else avg_browse_data_type8_in_total_rate end as avg_browse_data_type8_in_total_rate,
case when min_browse_data_type9_in_total_rate is null then 0 else min_browse_data_type9_in_total_rate end as min_browse_data_type9_in_total_rate,
case when max_browse_data_type9_in_total_rate is null then 0 else max_browse_data_type9_in_total_rate end as max_browse_data_type9_in_total_rate,
case when sum_browse_data_type9_in_total_rate is null then 0 else sum_browse_data_type9_in_total_rate end as sum_browse_data_type9_in_total_rate,
case when avg_browse_data_type9_in_total_rate is null then 0 else avg_browse_data_type9_in_total_rate end as avg_browse_data_type9_in_total_rate,
case when min_browse_data_type10_in_total_rate is null then 0 else min_browse_data_type10_in_total_rate end as min_browse_data_type10_in_total_rate,
case when max_browse_data_type10_in_total_rate is null then 0 else max_browse_data_type10_in_total_rate end as max_browse_data_type10_in_total_rate,
case when sum_browse_data_type10_in_total_rate is null then 0 else sum_browse_data_type10_in_total_rate end as sum_browse_data_type10_in_total_rate,
case when avg_browse_data_type10_in_total_rate is null then 0 else avg_browse_data_type10_in_total_rate end as avg_browse_data_type10_in_total_rate,
case when min_browse_data_type11_in_total_rate is null then 0 else min_browse_data_type11_in_total_rate end as min_browse_data_type11_in_total_rate,
case when max_browse_data_type11_in_total_rate is null then 0 else max_browse_data_type11_in_total_rate end as max_browse_data_type11_in_total_rate,
case when sum_browse_data_type11_in_total_rate is null then 0 else sum_browse_data_type11_in_total_rate end as sum_browse_data_type11_in_total_rate,
case when avg_browse_data_type11_in_total_rate is null then 0 else avg_browse_data_type11_in_total_rate end as avg_browse_data_type11_in_total_rate
from
feature_user_info_test a01 left outer join feature_browse_history_test b01 
on a01.user_id=b01.user_id_browse
)a03 left outer join feature_bill_detail_test b03
on a03.user_id=b03.user_id_bill;
















--##################  create gui_train_set_inner_join_bank_detail ######################


create table if not exists gui_train_set_inner_join_bank_detail as
select a03.*,
case when bill_detail_user_total is null then 0 else bill_detail_user_total end as bill_detail_user_total,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count,
case when bill_detail_user_bank_count_total_rate is null then 0 else bill_detail_user_bank_count_total_rate end as bill_detail_user_bank_count_total_rate,
case when bill_detail_user_remain_money_beyond_this_bill_money_total_rate is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money_total_rate end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_this_bill_money_beyond_card_limit_total_rate is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit_total_rate end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when min_last_repay_money_in_last_bill_money_rate is null then 0 else min_last_repay_money_in_last_bill_money_rate end as min_last_repay_money_in_last_bill_money_rate,
case when max_last_repay_money_in_last_bill_money_rate is null then 0 else max_last_repay_money_in_last_bill_money_rate end as max_last_repay_money_in_last_bill_money_rate,
case when sum_last_repay_money_in_last_bill_money_rate is null then 0 else sum_last_repay_money_in_last_bill_money_rate end as sum_last_repay_money_in_last_bill_money_rate,
case when avg_last_repay_money_in_last_bill_money_rate is null then 0 else avg_last_repay_money_in_last_bill_money_rate end as avg_last_repay_money_in_last_bill_money_rate,
case when min_last_bill_money_in_card_limit_rate is null then 0 else min_last_bill_money_in_card_limit_rate end as min_last_bill_money_in_card_limit_rate,
case when max_last_bill_money_in_card_limit_rate is null then 0 else max_last_bill_money_in_card_limit_rate end as max_last_bill_money_in_card_limit_rate,
case when sum_last_bill_money_in_card_limit_rate is null then 0 else sum_last_bill_money_in_card_limit_rate end as sum_last_bill_money_in_card_limit_rate,
case when avg_last_bill_money_in_card_limit_rate is null then 0 else avg_last_bill_money_in_card_limit_rate end as avg_last_bill_money_in_card_limit_rate,
case when min_this_bill_money_in_card_limit_rate is null then 0 else min_this_bill_money_in_card_limit_rate end as min_this_bill_money_in_card_limit_rate,
case when max_this_bill_money_in_card_limit_rate is null then 0 else max_this_bill_money_in_card_limit_rate end as max_this_bill_money_in_card_limit_rate,
case when sum_this_bill_money_in_card_limit_rate is null then 0 else sum_this_bill_money_in_card_limit_rate end as sum_this_bill_money_in_card_limit_rate,
case when avg_this_bill_money_in_card_limit_rate is null then 0 else avg_this_bill_money_in_card_limit_rate end as avg_this_bill_money_in_card_limit_rate,
case when min_remain_money_in_card_limit_rate is null then 0 else min_remain_money_in_card_limit_rate end as min_remain_money_in_card_limit_rate,
case when max_remain_money_in_card_limit_rate is null then 0 else max_remain_money_in_card_limit_rate end as max_remain_money_in_card_limit_rate,
case when sum_remain_money_in_card_limit_rate is null then 0 else sum_remain_money_in_card_limit_rate end as sum_remain_money_in_card_limit_rate,
case when avg_remain_money_in_card_limit_rate is null then 0 else avg_remain_money_in_card_limit_rate end as avg_remain_money_in_card_limit_rate,
case when min_borrow_limit_in_card_limit_rate is null then 0 else min_borrow_limit_in_card_limit_rate end as min_borrow_limit_in_card_limit_rate,
case when max_borrow_limit_in_card_limit_rate is null then 0 else max_borrow_limit_in_card_limit_rate end as max_borrow_limit_in_card_limit_rate,
case when sum_borrow_limit_in_card_limit_rate is null then 0 else sum_borrow_limit_in_card_limit_rate end as sum_borrow_limit_in_card_limit_rate,
case when avg_borrow_limit_in_card_limit_rate is null then 0 else avg_borrow_limit_in_card_limit_rate end as avg_borrow_limit_in_card_limit_rate,
case when min_this_bill_money_remain_in_this_bill_money_rate is null then 0 else min_this_bill_money_remain_in_this_bill_money_rate end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money_remain_in_this_bill_money_rate is null then 0 else max_this_bill_money_remain_in_this_bill_money_rate end as max_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money_remain_in_this_bill_money_rate is null then 0 else sum_this_bill_money_remain_in_this_bill_money_rate end as sum_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money_remain_in_this_bill_money_rate is null then 0 else avg_this_bill_money_remain_in_this_bill_money_rate end as avg_this_bill_money_remain_in_this_bill_money_rate
from
(
select a02.*,
case when bank_detail_user_total is null then 0 else bank_detail_user_total end as bank_detail_user_total,
case when bank_detail_user_deal_type1 is null then 0 else bank_detail_user_deal_type1 end as bank_detail_user_deal_type1,
case when bank_detail_user_deal_type0 is null then 0 else bank_detail_user_deal_type0 end as bank_detail_user_deal_type0,
case when bank_detail_user_salary0 is null then 0 else bank_detail_user_salary0 end as bank_detail_user_salary0,
case when bank_detail_user_salary1 is null then 0 else bank_detail_user_salary1 end as bank_detail_user_salary1,
case when bank_detail_user_salary0_type0 is null then 0 else bank_detail_user_salary0_type0 end as bank_detail_user_salary0_type0,
case when min_deal_money is null then 0 else min_deal_money end as min_deal_money,
case when max_deal_money is null then 0 else max_deal_money end as max_deal_money,
case when sum_deal_money is null then 0 else sum_deal_money end as sum_deal_money,
case when avg_deal_money is null then 0 else avg_deal_money end as avg_deal_money,
case when min_deal_money_type0 is null then 0 else min_deal_money_type0 end as min_deal_money_type0,
case when max_deal_money_type0 is null then 0 else max_deal_money_type0 end as max_deal_money_type0,
case when sum_deal_money_type0 is null then 0 else sum_deal_money_type0 end as sum_deal_money_type0,
case when avg_deal_money_type0 is null then 0 else avg_deal_money_type0 end as avg_deal_money_type0,
case when min_deal_money_type1 is null then 0 else min_deal_money_type1 end as min_deal_money_type1,
case when max_deal_money_type1 is null then 0 else max_deal_money_type1 end as max_deal_money_type1,
case when sum_deal_money_type1 is null then 0 else sum_deal_money_type1 end as sum_deal_money_type1,
case when avg_deal_money_type1 is null then 0 else avg_deal_money_type1 end as avg_deal_money_type1,
case when min_deal_money_salary0 is null then 0 else min_deal_money_salary0 end as min_deal_money_salary0,
case when max_deal_money_salary0 is null then 0 else max_deal_money_salary0 end as max_deal_money_salary0,
case when sum_deal_money_salary0 is null then 0 else sum_deal_money_salary0 end as sum_deal_money_salary0,
case when avg_deal_money_salary0 is null then 0 else avg_deal_money_salary0 end as avg_deal_money_salary0,
case when min_deal_money_salary1 is null then 0 else min_deal_money_salary1 end as min_deal_money_salary1,
case when max_deal_money_salary1 is null then 0 else max_deal_money_salary1 end as max_deal_money_salary1,
case when sum_deal_money_salary1 is null then 0 else sum_deal_money_salary1 end as sum_deal_money_salary1,
case when avg_deal_money_salary1 is null then 0 else avg_deal_money_salary1 end as avg_deal_money_salary1,
case when min_deal_money_salary0_type0 is null then 0 else min_deal_money_salary0_type0 end as min_deal_money_salary0_type0,
case when max_deal_money_salary0_type0 is null then 0 else max_deal_money_salary0_type0 end as max_deal_money_salary0_type0,
case when sum_deal_money_salary0_type0 is null then 0 else sum_deal_money_salary0_type0 end as sum_deal_money_salary0_type0,
case when avg_deal_money_salary0_type0 is null then 0 else avg_deal_money_salary0_type0 end as avg_deal_money_salary0_type0,
case when bank_detail_user_deal_type1_total_rate is null then 0 else bank_detail_user_deal_type1_total_rate end as bank_detail_user_deal_type1_total_rate,
case when bank_detail_user_salary0_total_rate is null then 0 else bank_detail_user_salary0_total_rate end as bank_detail_user_salary0_total_rate,
case when bank_detail_user_salary0_type0_in_type0_rate is null then 0 else bank_detail_user_salary0_type0_in_type0_rate end as bank_detail_user_salary0_type0_in_type0_rate,
case when bank_detail_user_salary0_type0_in_salary0_rate is null then 0 else bank_detail_user_salary0_type0_in_salary0_rate end as bank_detail_user_salary0_type0_in_salary0_rate,
case when sum_deal_money_type0_in_total_rate is null then 0 else sum_deal_money_type0_in_total_rate end as sum_deal_money_type0_in_total_rate,
case when avg_deal_money_type0_in_total_rate is null then 0 else avg_deal_money_type0_in_total_rate end as avg_deal_money_type0_in_total_rate,
case when sum_deal_money_salary0_in_total_rate is null then 0 else sum_deal_money_salary0_in_total_rate end as sum_deal_money_salary0_in_total_rate,
case when avg_deal_money_salary0_in_total_rate is null then 0 else avg_deal_money_salary0_in_total_rate end as avg_deal_money_salary0_in_total_rate,
case when sum_deal_money_salary0_type0_in_salary0_rate is null then 0 else sum_deal_money_salary0_type0_in_salary0_rate end as sum_deal_money_salary0_type0_in_salary0_rate,
case when avg_deal_money_salary0_type0_in_salary0_rate is null then 0 else avg_deal_money_salary0_type0_in_salary0_rate end as avg_deal_money_salary0_type0_in_salary0_rate,
case when sum_deal_money_salary0_type0_in_type0_rate is null then 0 else sum_deal_money_salary0_type0_in_type0_rate end as sum_deal_money_salary0_type0_in_type0_rate,
case when avg_deal_money_salary0_type0_in_type0_rate is null then 0 else avg_deal_money_salary0_type0_in_type0_rate end as avg_deal_money_salary0_type0_in_type0_rate
from
(
select a01.*,
case when browse_history_user_total is null then 0 else browse_history_user_total end as browse_history_user_total,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11,
case when browse_history_user_browse_type1_total_rate is null then 0 else browse_history_user_browse_type1_total_rate end as browse_history_user_browse_type1_total_rate,
case when browse_history_user_browse_type2_total_rate is null then 0 else browse_history_user_browse_type2_total_rate end as browse_history_user_browse_type2_total_rate,
case when browse_history_user_browse_type3_total_rate is null then 0 else browse_history_user_browse_type3_total_rate end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_browse_type4_total_rate is null then 0 else browse_history_user_browse_type4_total_rate end as browse_history_user_browse_type4_total_rate,
case when browse_history_user_browse_type5_total_rate is null then 0 else browse_history_user_browse_type5_total_rate end as browse_history_user_browse_type5_total_rate,
case when browse_history_user_browse_type6_total_rate is null then 0 else browse_history_user_browse_type6_total_rate end as browse_history_user_browse_type6_total_rate,
case when browse_history_user_browse_type7_total_rate is null then 0 else browse_history_user_browse_type7_total_rate end as browse_history_user_browse_type7_total_rate,
case when browse_history_user_browse_type8_total_rate is null then 0 else browse_history_user_browse_type8_total_rate end as browse_history_user_browse_type8_total_rate,
case when browse_history_user_browse_type9_total_rate is null then 0 else browse_history_user_browse_type9_total_rate end as browse_history_user_browse_type9_total_rate,
case when browse_history_user_browse_type10_total_rate is null then 0 else browse_history_user_browse_type10_total_rate end as browse_history_user_browse_type10_total_rate,
case when browse_history_user_browse_type11_total_rate is null then 0 else browse_history_user_browse_type11_total_rate end as browse_history_user_browse_type11_total_rate,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when min_browse_data_type1_in_total_rate is null then 0 else min_browse_data_type1_in_total_rate end as min_browse_data_type1_in_total_rate,
case when max_browse_data_type1_in_total_rate is null then 0 else max_browse_data_type1_in_total_rate end as max_browse_data_type1_in_total_rate,
case when sum_browse_data_type1_in_total_rate is null then 0 else sum_browse_data_type1_in_total_rate end as sum_browse_data_type1_in_total_rate,
case when avg_browse_data_type1_in_total_rate is null then 0 else avg_browse_data_type1_in_total_rate end as avg_browse_data_type1_in_total_rate,
case when min_browse_data_type2_in_total_rate is null then 0 else min_browse_data_type2_in_total_rate end as min_browse_data_type2_in_total_rate,
case when max_browse_data_type2_in_total_rate is null then 0 else max_browse_data_type2_in_total_rate end as max_browse_data_type2_in_total_rate,
case when sum_browse_data_type2_in_total_rate is null then 0 else sum_browse_data_type2_in_total_rate end as sum_browse_data_type2_in_total_rate,
case when avg_browse_data_type2_in_total_rate is null then 0 else avg_browse_data_type2_in_total_rate end as avg_browse_data_type2_in_total_rate,
case when min_browse_data_type3_in_total_rate is null then 0 else min_browse_data_type3_in_total_rate end as min_browse_data_type3_in_total_rate,
case when max_browse_data_type3_in_total_rate is null then 0 else max_browse_data_type3_in_total_rate end as max_browse_data_type3_in_total_rate,
case when sum_browse_data_type3_in_total_rate is null then 0 else sum_browse_data_type3_in_total_rate end as sum_browse_data_type3_in_total_rate,
case when avg_browse_data_type3_in_total_rate is null then 0 else avg_browse_data_type3_in_total_rate end as avg_browse_data_type3_in_total_rate,
case when min_browse_data_type4_in_total_rate is null then 0 else min_browse_data_type4_in_total_rate end as min_browse_data_type4_in_total_rate,
case when max_browse_data_type4_in_total_rate is null then 0 else max_browse_data_type4_in_total_rate end as max_browse_data_type4_in_total_rate,
case when sum_browse_data_type4_in_total_rate is null then 0 else sum_browse_data_type4_in_total_rate end as sum_browse_data_type4_in_total_rate,
case when avg_browse_data_type4_in_total_rate is null then 0 else avg_browse_data_type4_in_total_rate end as avg_browse_data_type4_in_total_rate,
case when min_browse_data_type5_in_total_rate is null then 0 else min_browse_data_type5_in_total_rate end as min_browse_data_type5_in_total_rate,
case when max_browse_data_type5_in_total_rate is null then 0 else max_browse_data_type5_in_total_rate end as max_browse_data_type5_in_total_rate,
case when sum_browse_data_type5_in_total_rate is null then 0 else sum_browse_data_type5_in_total_rate end as sum_browse_data_type5_in_total_rate,
case when avg_browse_data_type5_in_total_rate is null then 0 else avg_browse_data_type5_in_total_rate end as avg_browse_data_type5_in_total_rate,
case when min_browse_data_type6_in_total_rate is null then 0 else min_browse_data_type6_in_total_rate end as min_browse_data_type6_in_total_rate,
case when max_browse_data_type6_in_total_rate is null then 0 else max_browse_data_type6_in_total_rate end as max_browse_data_type6_in_total_rate,
case when sum_browse_data_type6_in_total_rate is null then 0 else sum_browse_data_type6_in_total_rate end as sum_browse_data_type6_in_total_rate,
case when avg_browse_data_type6_in_total_rate is null then 0 else avg_browse_data_type6_in_total_rate end as avg_browse_data_type6_in_total_rate,
case when min_browse_data_type7_in_total_rate is null then 0 else min_browse_data_type7_in_total_rate end as min_browse_data_type7_in_total_rate,
case when max_browse_data_type7_in_total_rate is null then 0 else max_browse_data_type7_in_total_rate end as max_browse_data_type7_in_total_rate,
case when sum_browse_data_type7_in_total_rate is null then 0 else sum_browse_data_type7_in_total_rate end as sum_browse_data_type7_in_total_rate,
case when avg_browse_data_type7_in_total_rate is null then 0 else avg_browse_data_type7_in_total_rate end as avg_browse_data_type7_in_total_rate,
case when min_browse_data_type8_in_total_rate is null then 0 else min_browse_data_type8_in_total_rate end as min_browse_data_type8_in_total_rate,
case when max_browse_data_type8_in_total_rate is null then 0 else max_browse_data_type8_in_total_rate end as max_browse_data_type8_in_total_rate,
case when sum_browse_data_type8_in_total_rate is null then 0 else sum_browse_data_type8_in_total_rate end as sum_browse_data_type8_in_total_rate,
case when avg_browse_data_type8_in_total_rate is null then 0 else avg_browse_data_type8_in_total_rate end as avg_browse_data_type8_in_total_rate,
case when min_browse_data_type9_in_total_rate is null then 0 else min_browse_data_type9_in_total_rate end as min_browse_data_type9_in_total_rate,
case when max_browse_data_type9_in_total_rate is null then 0 else max_browse_data_type9_in_total_rate end as max_browse_data_type9_in_total_rate,
case when sum_browse_data_type9_in_total_rate is null then 0 else sum_browse_data_type9_in_total_rate end as sum_browse_data_type9_in_total_rate,
case when avg_browse_data_type9_in_total_rate is null then 0 else avg_browse_data_type9_in_total_rate end as avg_browse_data_type9_in_total_rate,
case when min_browse_data_type10_in_total_rate is null then 0 else min_browse_data_type10_in_total_rate end as min_browse_data_type10_in_total_rate,
case when max_browse_data_type10_in_total_rate is null then 0 else max_browse_data_type10_in_total_rate end as max_browse_data_type10_in_total_rate,
case when sum_browse_data_type10_in_total_rate is null then 0 else sum_browse_data_type10_in_total_rate end as sum_browse_data_type10_in_total_rate,
case when avg_browse_data_type10_in_total_rate is null then 0 else avg_browse_data_type10_in_total_rate end as avg_browse_data_type10_in_total_rate,
case when min_browse_data_type11_in_total_rate is null then 0 else min_browse_data_type11_in_total_rate end as min_browse_data_type11_in_total_rate,
case when max_browse_data_type11_in_total_rate is null then 0 else max_browse_data_type11_in_total_rate end as max_browse_data_type11_in_total_rate,
case when sum_browse_data_type11_in_total_rate is null then 0 else sum_browse_data_type11_in_total_rate end as sum_browse_data_type11_in_total_rate,
case when avg_browse_data_type11_in_total_rate is null then 0 else avg_browse_data_type11_in_total_rate end as avg_browse_data_type11_in_total_rate
from
feature_user_info_train a01 left outer join feature_browse_history_train b01 
on a01.user_id=b01.user_id_browse
)a02 inner join feature_bank_detail_train b02 
on a02.user_id=b02.user_id_bank
)a03 left outer join feature_bill_detail_train b03
on a03.user_id=b03.user_id_bill;






--##################  create gui_test_set_inner_join_bank_detail ######################


create table if not exists gui_test_set_inner_join_bank_detail as
select a03.*,
case when bill_detail_user_total is null then 0 else bill_detail_user_total end as bill_detail_user_total,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count,
case when bill_detail_user_bank_count_total_rate is null then 0 else bill_detail_user_bank_count_total_rate end as bill_detail_user_bank_count_total_rate,
case when bill_detail_user_remain_money_beyond_this_bill_money_total_rate is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money_total_rate end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_this_bill_money_beyond_card_limit_total_rate is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit_total_rate end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when min_last_repay_money_in_last_bill_money_rate is null then 0 else min_last_repay_money_in_last_bill_money_rate end as min_last_repay_money_in_last_bill_money_rate,
case when max_last_repay_money_in_last_bill_money_rate is null then 0 else max_last_repay_money_in_last_bill_money_rate end as max_last_repay_money_in_last_bill_money_rate,
case when sum_last_repay_money_in_last_bill_money_rate is null then 0 else sum_last_repay_money_in_last_bill_money_rate end as sum_last_repay_money_in_last_bill_money_rate,
case when avg_last_repay_money_in_last_bill_money_rate is null then 0 else avg_last_repay_money_in_last_bill_money_rate end as avg_last_repay_money_in_last_bill_money_rate,
case when min_last_bill_money_in_card_limit_rate is null then 0 else min_last_bill_money_in_card_limit_rate end as min_last_bill_money_in_card_limit_rate,
case when max_last_bill_money_in_card_limit_rate is null then 0 else max_last_bill_money_in_card_limit_rate end as max_last_bill_money_in_card_limit_rate,
case when sum_last_bill_money_in_card_limit_rate is null then 0 else sum_last_bill_money_in_card_limit_rate end as sum_last_bill_money_in_card_limit_rate,
case when avg_last_bill_money_in_card_limit_rate is null then 0 else avg_last_bill_money_in_card_limit_rate end as avg_last_bill_money_in_card_limit_rate,
case when min_this_bill_money_in_card_limit_rate is null then 0 else min_this_bill_money_in_card_limit_rate end as min_this_bill_money_in_card_limit_rate,
case when max_this_bill_money_in_card_limit_rate is null then 0 else max_this_bill_money_in_card_limit_rate end as max_this_bill_money_in_card_limit_rate,
case when sum_this_bill_money_in_card_limit_rate is null then 0 else sum_this_bill_money_in_card_limit_rate end as sum_this_bill_money_in_card_limit_rate,
case when avg_this_bill_money_in_card_limit_rate is null then 0 else avg_this_bill_money_in_card_limit_rate end as avg_this_bill_money_in_card_limit_rate,
case when min_remain_money_in_card_limit_rate is null then 0 else min_remain_money_in_card_limit_rate end as min_remain_money_in_card_limit_rate,
case when max_remain_money_in_card_limit_rate is null then 0 else max_remain_money_in_card_limit_rate end as max_remain_money_in_card_limit_rate,
case when sum_remain_money_in_card_limit_rate is null then 0 else sum_remain_money_in_card_limit_rate end as sum_remain_money_in_card_limit_rate,
case when avg_remain_money_in_card_limit_rate is null then 0 else avg_remain_money_in_card_limit_rate end as avg_remain_money_in_card_limit_rate,
case when min_borrow_limit_in_card_limit_rate is null then 0 else min_borrow_limit_in_card_limit_rate end as min_borrow_limit_in_card_limit_rate,
case when max_borrow_limit_in_card_limit_rate is null then 0 else max_borrow_limit_in_card_limit_rate end as max_borrow_limit_in_card_limit_rate,
case when sum_borrow_limit_in_card_limit_rate is null then 0 else sum_borrow_limit_in_card_limit_rate end as sum_borrow_limit_in_card_limit_rate,
case when avg_borrow_limit_in_card_limit_rate is null then 0 else avg_borrow_limit_in_card_limit_rate end as avg_borrow_limit_in_card_limit_rate,
case when min_this_bill_money_remain_in_this_bill_money_rate is null then 0 else min_this_bill_money_remain_in_this_bill_money_rate end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money_remain_in_this_bill_money_rate is null then 0 else max_this_bill_money_remain_in_this_bill_money_rate end as max_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money_remain_in_this_bill_money_rate is null then 0 else sum_this_bill_money_remain_in_this_bill_money_rate end as sum_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money_remain_in_this_bill_money_rate is null then 0 else avg_this_bill_money_remain_in_this_bill_money_rate end as avg_this_bill_money_remain_in_this_bill_money_rate
from
(
select a02.*,
case when bank_detail_user_total is null then 0 else bank_detail_user_total end as bank_detail_user_total,
case when bank_detail_user_deal_type1 is null then 0 else bank_detail_user_deal_type1 end as bank_detail_user_deal_type1,
case when bank_detail_user_deal_type0 is null then 0 else bank_detail_user_deal_type0 end as bank_detail_user_deal_type0,
case when bank_detail_user_salary0 is null then 0 else bank_detail_user_salary0 end as bank_detail_user_salary0,
case when bank_detail_user_salary1 is null then 0 else bank_detail_user_salary1 end as bank_detail_user_salary1,
case when bank_detail_user_salary0_type0 is null then 0 else bank_detail_user_salary0_type0 end as bank_detail_user_salary0_type0,
case when min_deal_money is null then 0 else min_deal_money end as min_deal_money,
case when max_deal_money is null then 0 else max_deal_money end as max_deal_money,
case when sum_deal_money is null then 0 else sum_deal_money end as sum_deal_money,
case when avg_deal_money is null then 0 else avg_deal_money end as avg_deal_money,
case when min_deal_money_type0 is null then 0 else min_deal_money_type0 end as min_deal_money_type0,
case when max_deal_money_type0 is null then 0 else max_deal_money_type0 end as max_deal_money_type0,
case when sum_deal_money_type0 is null then 0 else sum_deal_money_type0 end as sum_deal_money_type0,
case when avg_deal_money_type0 is null then 0 else avg_deal_money_type0 end as avg_deal_money_type0,
case when min_deal_money_type1 is null then 0 else min_deal_money_type1 end as min_deal_money_type1,
case when max_deal_money_type1 is null then 0 else max_deal_money_type1 end as max_deal_money_type1,
case when sum_deal_money_type1 is null then 0 else sum_deal_money_type1 end as sum_deal_money_type1,
case when avg_deal_money_type1 is null then 0 else avg_deal_money_type1 end as avg_deal_money_type1,
case when min_deal_money_salary0 is null then 0 else min_deal_money_salary0 end as min_deal_money_salary0,
case when max_deal_money_salary0 is null then 0 else max_deal_money_salary0 end as max_deal_money_salary0,
case when sum_deal_money_salary0 is null then 0 else sum_deal_money_salary0 end as sum_deal_money_salary0,
case when avg_deal_money_salary0 is null then 0 else avg_deal_money_salary0 end as avg_deal_money_salary0,
case when min_deal_money_salary1 is null then 0 else min_deal_money_salary1 end as min_deal_money_salary1,
case when max_deal_money_salary1 is null then 0 else max_deal_money_salary1 end as max_deal_money_salary1,
case when sum_deal_money_salary1 is null then 0 else sum_deal_money_salary1 end as sum_deal_money_salary1,
case when avg_deal_money_salary1 is null then 0 else avg_deal_money_salary1 end as avg_deal_money_salary1,
case when min_deal_money_salary0_type0 is null then 0 else min_deal_money_salary0_type0 end as min_deal_money_salary0_type0,
case when max_deal_money_salary0_type0 is null then 0 else max_deal_money_salary0_type0 end as max_deal_money_salary0_type0,
case when sum_deal_money_salary0_type0 is null then 0 else sum_deal_money_salary0_type0 end as sum_deal_money_salary0_type0,
case when avg_deal_money_salary0_type0 is null then 0 else avg_deal_money_salary0_type0 end as avg_deal_money_salary0_type0,
case when bank_detail_user_deal_type1_total_rate is null then 0 else bank_detail_user_deal_type1_total_rate end as bank_detail_user_deal_type1_total_rate,
case when bank_detail_user_salary0_total_rate is null then 0 else bank_detail_user_salary0_total_rate end as bank_detail_user_salary0_total_rate,
case when bank_detail_user_salary0_type0_in_type0_rate is null then 0 else bank_detail_user_salary0_type0_in_type0_rate end as bank_detail_user_salary0_type0_in_type0_rate,
case when bank_detail_user_salary0_type0_in_salary0_rate is null then 0 else bank_detail_user_salary0_type0_in_salary0_rate end as bank_detail_user_salary0_type0_in_salary0_rate,
case when sum_deal_money_type0_in_total_rate is null then 0 else sum_deal_money_type0_in_total_rate end as sum_deal_money_type0_in_total_rate,
case when avg_deal_money_type0_in_total_rate is null then 0 else avg_deal_money_type0_in_total_rate end as avg_deal_money_type0_in_total_rate,
case when sum_deal_money_salary0_in_total_rate is null then 0 else sum_deal_money_salary0_in_total_rate end as sum_deal_money_salary0_in_total_rate,
case when avg_deal_money_salary0_in_total_rate is null then 0 else avg_deal_money_salary0_in_total_rate end as avg_deal_money_salary0_in_total_rate,
case when sum_deal_money_salary0_type0_in_salary0_rate is null then 0 else sum_deal_money_salary0_type0_in_salary0_rate end as sum_deal_money_salary0_type0_in_salary0_rate,
case when avg_deal_money_salary0_type0_in_salary0_rate is null then 0 else avg_deal_money_salary0_type0_in_salary0_rate end as avg_deal_money_salary0_type0_in_salary0_rate,
case when sum_deal_money_salary0_type0_in_type0_rate is null then 0 else sum_deal_money_salary0_type0_in_type0_rate end as sum_deal_money_salary0_type0_in_type0_rate,
case when avg_deal_money_salary0_type0_in_type0_rate is null then 0 else avg_deal_money_salary0_type0_in_type0_rate end as avg_deal_money_salary0_type0_in_type0_rate
from
(
select a01.*,
case when browse_history_user_total is null then 0 else browse_history_user_total end as browse_history_user_total,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11,
case when browse_history_user_browse_type1_total_rate is null then 0 else browse_history_user_browse_type1_total_rate end as browse_history_user_browse_type1_total_rate,
case when browse_history_user_browse_type2_total_rate is null then 0 else browse_history_user_browse_type2_total_rate end as browse_history_user_browse_type2_total_rate,
case when browse_history_user_browse_type3_total_rate is null then 0 else browse_history_user_browse_type3_total_rate end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_browse_type4_total_rate is null then 0 else browse_history_user_browse_type4_total_rate end as browse_history_user_browse_type4_total_rate,
case when browse_history_user_browse_type5_total_rate is null then 0 else browse_history_user_browse_type5_total_rate end as browse_history_user_browse_type5_total_rate,
case when browse_history_user_browse_type6_total_rate is null then 0 else browse_history_user_browse_type6_total_rate end as browse_history_user_browse_type6_total_rate,
case when browse_history_user_browse_type7_total_rate is null then 0 else browse_history_user_browse_type7_total_rate end as browse_history_user_browse_type7_total_rate,
case when browse_history_user_browse_type8_total_rate is null then 0 else browse_history_user_browse_type8_total_rate end as browse_history_user_browse_type8_total_rate,
case when browse_history_user_browse_type9_total_rate is null then 0 else browse_history_user_browse_type9_total_rate end as browse_history_user_browse_type9_total_rate,
case when browse_history_user_browse_type10_total_rate is null then 0 else browse_history_user_browse_type10_total_rate end as browse_history_user_browse_type10_total_rate,
case when browse_history_user_browse_type11_total_rate is null then 0 else browse_history_user_browse_type11_total_rate end as browse_history_user_browse_type11_total_rate,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when min_browse_data_type1_in_total_rate is null then 0 else min_browse_data_type1_in_total_rate end as min_browse_data_type1_in_total_rate,
case when max_browse_data_type1_in_total_rate is null then 0 else max_browse_data_type1_in_total_rate end as max_browse_data_type1_in_total_rate,
case when sum_browse_data_type1_in_total_rate is null then 0 else sum_browse_data_type1_in_total_rate end as sum_browse_data_type1_in_total_rate,
case when avg_browse_data_type1_in_total_rate is null then 0 else avg_browse_data_type1_in_total_rate end as avg_browse_data_type1_in_total_rate,
case when min_browse_data_type2_in_total_rate is null then 0 else min_browse_data_type2_in_total_rate end as min_browse_data_type2_in_total_rate,
case when max_browse_data_type2_in_total_rate is null then 0 else max_browse_data_type2_in_total_rate end as max_browse_data_type2_in_total_rate,
case when sum_browse_data_type2_in_total_rate is null then 0 else sum_browse_data_type2_in_total_rate end as sum_browse_data_type2_in_total_rate,
case when avg_browse_data_type2_in_total_rate is null then 0 else avg_browse_data_type2_in_total_rate end as avg_browse_data_type2_in_total_rate,
case when min_browse_data_type3_in_total_rate is null then 0 else min_browse_data_type3_in_total_rate end as min_browse_data_type3_in_total_rate,
case when max_browse_data_type3_in_total_rate is null then 0 else max_browse_data_type3_in_total_rate end as max_browse_data_type3_in_total_rate,
case when sum_browse_data_type3_in_total_rate is null then 0 else sum_browse_data_type3_in_total_rate end as sum_browse_data_type3_in_total_rate,
case when avg_browse_data_type3_in_total_rate is null then 0 else avg_browse_data_type3_in_total_rate end as avg_browse_data_type3_in_total_rate,
case when min_browse_data_type4_in_total_rate is null then 0 else min_browse_data_type4_in_total_rate end as min_browse_data_type4_in_total_rate,
case when max_browse_data_type4_in_total_rate is null then 0 else max_browse_data_type4_in_total_rate end as max_browse_data_type4_in_total_rate,
case when sum_browse_data_type4_in_total_rate is null then 0 else sum_browse_data_type4_in_total_rate end as sum_browse_data_type4_in_total_rate,
case when avg_browse_data_type4_in_total_rate is null then 0 else avg_browse_data_type4_in_total_rate end as avg_browse_data_type4_in_total_rate,
case when min_browse_data_type5_in_total_rate is null then 0 else min_browse_data_type5_in_total_rate end as min_browse_data_type5_in_total_rate,
case when max_browse_data_type5_in_total_rate is null then 0 else max_browse_data_type5_in_total_rate end as max_browse_data_type5_in_total_rate,
case when sum_browse_data_type5_in_total_rate is null then 0 else sum_browse_data_type5_in_total_rate end as sum_browse_data_type5_in_total_rate,
case when avg_browse_data_type5_in_total_rate is null then 0 else avg_browse_data_type5_in_total_rate end as avg_browse_data_type5_in_total_rate,
case when min_browse_data_type6_in_total_rate is null then 0 else min_browse_data_type6_in_total_rate end as min_browse_data_type6_in_total_rate,
case when max_browse_data_type6_in_total_rate is null then 0 else max_browse_data_type6_in_total_rate end as max_browse_data_type6_in_total_rate,
case when sum_browse_data_type6_in_total_rate is null then 0 else sum_browse_data_type6_in_total_rate end as sum_browse_data_type6_in_total_rate,
case when avg_browse_data_type6_in_total_rate is null then 0 else avg_browse_data_type6_in_total_rate end as avg_browse_data_type6_in_total_rate,
case when min_browse_data_type7_in_total_rate is null then 0 else min_browse_data_type7_in_total_rate end as min_browse_data_type7_in_total_rate,
case when max_browse_data_type7_in_total_rate is null then 0 else max_browse_data_type7_in_total_rate end as max_browse_data_type7_in_total_rate,
case when sum_browse_data_type7_in_total_rate is null then 0 else sum_browse_data_type7_in_total_rate end as sum_browse_data_type7_in_total_rate,
case when avg_browse_data_type7_in_total_rate is null then 0 else avg_browse_data_type7_in_total_rate end as avg_browse_data_type7_in_total_rate,
case when min_browse_data_type8_in_total_rate is null then 0 else min_browse_data_type8_in_total_rate end as min_browse_data_type8_in_total_rate,
case when max_browse_data_type8_in_total_rate is null then 0 else max_browse_data_type8_in_total_rate end as max_browse_data_type8_in_total_rate,
case when sum_browse_data_type8_in_total_rate is null then 0 else sum_browse_data_type8_in_total_rate end as sum_browse_data_type8_in_total_rate,
case when avg_browse_data_type8_in_total_rate is null then 0 else avg_browse_data_type8_in_total_rate end as avg_browse_data_type8_in_total_rate,
case when min_browse_data_type9_in_total_rate is null then 0 else min_browse_data_type9_in_total_rate end as min_browse_data_type9_in_total_rate,
case when max_browse_data_type9_in_total_rate is null then 0 else max_browse_data_type9_in_total_rate end as max_browse_data_type9_in_total_rate,
case when sum_browse_data_type9_in_total_rate is null then 0 else sum_browse_data_type9_in_total_rate end as sum_browse_data_type9_in_total_rate,
case when avg_browse_data_type9_in_total_rate is null then 0 else avg_browse_data_type9_in_total_rate end as avg_browse_data_type9_in_total_rate,
case when min_browse_data_type10_in_total_rate is null then 0 else min_browse_data_type10_in_total_rate end as min_browse_data_type10_in_total_rate,
case when max_browse_data_type10_in_total_rate is null then 0 else max_browse_data_type10_in_total_rate end as max_browse_data_type10_in_total_rate,
case when sum_browse_data_type10_in_total_rate is null then 0 else sum_browse_data_type10_in_total_rate end as sum_browse_data_type10_in_total_rate,
case when avg_browse_data_type10_in_total_rate is null then 0 else avg_browse_data_type10_in_total_rate end as avg_browse_data_type10_in_total_rate,
case when min_browse_data_type11_in_total_rate is null then 0 else min_browse_data_type11_in_total_rate end as min_browse_data_type11_in_total_rate,
case when max_browse_data_type11_in_total_rate is null then 0 else max_browse_data_type11_in_total_rate end as max_browse_data_type11_in_total_rate,
case when sum_browse_data_type11_in_total_rate is null then 0 else sum_browse_data_type11_in_total_rate end as sum_browse_data_type11_in_total_rate,
case when avg_browse_data_type11_in_total_rate is null then 0 else avg_browse_data_type11_in_total_rate end as avg_browse_data_type11_in_total_rate
from
feature_user_info_test a01 left outer join feature_browse_history_test b01 
on a01.user_id=b01.user_id_browse
)a02 inner join feature_bank_detail_test b02 
on a02.user_id=b02.user_id_bank
)a03 left outer join feature_bill_detail_test b03
on a03.user_id=b03.user_id_bill;







--##################  create gui_train_set_not_have_bank_detail_and_inner_join_all   ( about have 45000 user) ######################


create table if not exists gui_train_set_not_have_bank_detail_and_inner_join_all as
select a03.*,
case when bill_detail_user_total is null then 0 else bill_detail_user_total end as bill_detail_user_total,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count,
case when bill_detail_user_bank_count_total_rate is null then 0 else bill_detail_user_bank_count_total_rate end as bill_detail_user_bank_count_total_rate,
case when bill_detail_user_remain_money_beyond_this_bill_money_total_rate is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money_total_rate end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_this_bill_money_beyond_card_limit_total_rate is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit_total_rate end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when min_last_repay_money_in_last_bill_money_rate is null then 0 else min_last_repay_money_in_last_bill_money_rate end as min_last_repay_money_in_last_bill_money_rate,
case when max_last_repay_money_in_last_bill_money_rate is null then 0 else max_last_repay_money_in_last_bill_money_rate end as max_last_repay_money_in_last_bill_money_rate,
case when sum_last_repay_money_in_last_bill_money_rate is null then 0 else sum_last_repay_money_in_last_bill_money_rate end as sum_last_repay_money_in_last_bill_money_rate,
case when avg_last_repay_money_in_last_bill_money_rate is null then 0 else avg_last_repay_money_in_last_bill_money_rate end as avg_last_repay_money_in_last_bill_money_rate,
case when min_last_bill_money_in_card_limit_rate is null then 0 else min_last_bill_money_in_card_limit_rate end as min_last_bill_money_in_card_limit_rate,
case when max_last_bill_money_in_card_limit_rate is null then 0 else max_last_bill_money_in_card_limit_rate end as max_last_bill_money_in_card_limit_rate,
case when sum_last_bill_money_in_card_limit_rate is null then 0 else sum_last_bill_money_in_card_limit_rate end as sum_last_bill_money_in_card_limit_rate,
case when avg_last_bill_money_in_card_limit_rate is null then 0 else avg_last_bill_money_in_card_limit_rate end as avg_last_bill_money_in_card_limit_rate,
case when min_this_bill_money_in_card_limit_rate is null then 0 else min_this_bill_money_in_card_limit_rate end as min_this_bill_money_in_card_limit_rate,
case when max_this_bill_money_in_card_limit_rate is null then 0 else max_this_bill_money_in_card_limit_rate end as max_this_bill_money_in_card_limit_rate,
case when sum_this_bill_money_in_card_limit_rate is null then 0 else sum_this_bill_money_in_card_limit_rate end as sum_this_bill_money_in_card_limit_rate,
case when avg_this_bill_money_in_card_limit_rate is null then 0 else avg_this_bill_money_in_card_limit_rate end as avg_this_bill_money_in_card_limit_rate,
case when min_remain_money_in_card_limit_rate is null then 0 else min_remain_money_in_card_limit_rate end as min_remain_money_in_card_limit_rate,
case when max_remain_money_in_card_limit_rate is null then 0 else max_remain_money_in_card_limit_rate end as max_remain_money_in_card_limit_rate,
case when sum_remain_money_in_card_limit_rate is null then 0 else sum_remain_money_in_card_limit_rate end as sum_remain_money_in_card_limit_rate,
case when avg_remain_money_in_card_limit_rate is null then 0 else avg_remain_money_in_card_limit_rate end as avg_remain_money_in_card_limit_rate,
case when min_borrow_limit_in_card_limit_rate is null then 0 else min_borrow_limit_in_card_limit_rate end as min_borrow_limit_in_card_limit_rate,
case when max_borrow_limit_in_card_limit_rate is null then 0 else max_borrow_limit_in_card_limit_rate end as max_borrow_limit_in_card_limit_rate,
case when sum_borrow_limit_in_card_limit_rate is null then 0 else sum_borrow_limit_in_card_limit_rate end as sum_borrow_limit_in_card_limit_rate,
case when avg_borrow_limit_in_card_limit_rate is null then 0 else avg_borrow_limit_in_card_limit_rate end as avg_borrow_limit_in_card_limit_rate,
case when min_this_bill_money_remain_in_this_bill_money_rate is null then 0 else min_this_bill_money_remain_in_this_bill_money_rate end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money_remain_in_this_bill_money_rate is null then 0 else max_this_bill_money_remain_in_this_bill_money_rate end as max_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money_remain_in_this_bill_money_rate is null then 0 else sum_this_bill_money_remain_in_this_bill_money_rate end as sum_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money_remain_in_this_bill_money_rate is null then 0 else avg_this_bill_money_remain_in_this_bill_money_rate end as avg_this_bill_money_remain_in_this_bill_money_rate
from
(
select a01.*,
case when browse_history_user_total is null then 0 else browse_history_user_total end as browse_history_user_total,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11,
case when browse_history_user_browse_type1_total_rate is null then 0 else browse_history_user_browse_type1_total_rate end as browse_history_user_browse_type1_total_rate,
case when browse_history_user_browse_type2_total_rate is null then 0 else browse_history_user_browse_type2_total_rate end as browse_history_user_browse_type2_total_rate,
case when browse_history_user_browse_type3_total_rate is null then 0 else browse_history_user_browse_type3_total_rate end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_browse_type4_total_rate is null then 0 else browse_history_user_browse_type4_total_rate end as browse_history_user_browse_type4_total_rate,
case when browse_history_user_browse_type5_total_rate is null then 0 else browse_history_user_browse_type5_total_rate end as browse_history_user_browse_type5_total_rate,
case when browse_history_user_browse_type6_total_rate is null then 0 else browse_history_user_browse_type6_total_rate end as browse_history_user_browse_type6_total_rate,
case when browse_history_user_browse_type7_total_rate is null then 0 else browse_history_user_browse_type7_total_rate end as browse_history_user_browse_type7_total_rate,
case when browse_history_user_browse_type8_total_rate is null then 0 else browse_history_user_browse_type8_total_rate end as browse_history_user_browse_type8_total_rate,
case when browse_history_user_browse_type9_total_rate is null then 0 else browse_history_user_browse_type9_total_rate end as browse_history_user_browse_type9_total_rate,
case when browse_history_user_browse_type10_total_rate is null then 0 else browse_history_user_browse_type10_total_rate end as browse_history_user_browse_type10_total_rate,
case when browse_history_user_browse_type11_total_rate is null then 0 else browse_history_user_browse_type11_total_rate end as browse_history_user_browse_type11_total_rate,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when min_browse_data_type1_in_total_rate is null then 0 else min_browse_data_type1_in_total_rate end as min_browse_data_type1_in_total_rate,
case when max_browse_data_type1_in_total_rate is null then 0 else max_browse_data_type1_in_total_rate end as max_browse_data_type1_in_total_rate,
case when sum_browse_data_type1_in_total_rate is null then 0 else sum_browse_data_type1_in_total_rate end as sum_browse_data_type1_in_total_rate,
case when avg_browse_data_type1_in_total_rate is null then 0 else avg_browse_data_type1_in_total_rate end as avg_browse_data_type1_in_total_rate,
case when min_browse_data_type2_in_total_rate is null then 0 else min_browse_data_type2_in_total_rate end as min_browse_data_type2_in_total_rate,
case when max_browse_data_type2_in_total_rate is null then 0 else max_browse_data_type2_in_total_rate end as max_browse_data_type2_in_total_rate,
case when sum_browse_data_type2_in_total_rate is null then 0 else sum_browse_data_type2_in_total_rate end as sum_browse_data_type2_in_total_rate,
case when avg_browse_data_type2_in_total_rate is null then 0 else avg_browse_data_type2_in_total_rate end as avg_browse_data_type2_in_total_rate,
case when min_browse_data_type3_in_total_rate is null then 0 else min_browse_data_type3_in_total_rate end as min_browse_data_type3_in_total_rate,
case when max_browse_data_type3_in_total_rate is null then 0 else max_browse_data_type3_in_total_rate end as max_browse_data_type3_in_total_rate,
case when sum_browse_data_type3_in_total_rate is null then 0 else sum_browse_data_type3_in_total_rate end as sum_browse_data_type3_in_total_rate,
case when avg_browse_data_type3_in_total_rate is null then 0 else avg_browse_data_type3_in_total_rate end as avg_browse_data_type3_in_total_rate,
case when min_browse_data_type4_in_total_rate is null then 0 else min_browse_data_type4_in_total_rate end as min_browse_data_type4_in_total_rate,
case when max_browse_data_type4_in_total_rate is null then 0 else max_browse_data_type4_in_total_rate end as max_browse_data_type4_in_total_rate,
case when sum_browse_data_type4_in_total_rate is null then 0 else sum_browse_data_type4_in_total_rate end as sum_browse_data_type4_in_total_rate,
case when avg_browse_data_type4_in_total_rate is null then 0 else avg_browse_data_type4_in_total_rate end as avg_browse_data_type4_in_total_rate,
case when min_browse_data_type5_in_total_rate is null then 0 else min_browse_data_type5_in_total_rate end as min_browse_data_type5_in_total_rate,
case when max_browse_data_type5_in_total_rate is null then 0 else max_browse_data_type5_in_total_rate end as max_browse_data_type5_in_total_rate,
case when sum_browse_data_type5_in_total_rate is null then 0 else sum_browse_data_type5_in_total_rate end as sum_browse_data_type5_in_total_rate,
case when avg_browse_data_type5_in_total_rate is null then 0 else avg_browse_data_type5_in_total_rate end as avg_browse_data_type5_in_total_rate,
case when min_browse_data_type6_in_total_rate is null then 0 else min_browse_data_type6_in_total_rate end as min_browse_data_type6_in_total_rate,
case when max_browse_data_type6_in_total_rate is null then 0 else max_browse_data_type6_in_total_rate end as max_browse_data_type6_in_total_rate,
case when sum_browse_data_type6_in_total_rate is null then 0 else sum_browse_data_type6_in_total_rate end as sum_browse_data_type6_in_total_rate,
case when avg_browse_data_type6_in_total_rate is null then 0 else avg_browse_data_type6_in_total_rate end as avg_browse_data_type6_in_total_rate,
case when min_browse_data_type7_in_total_rate is null then 0 else min_browse_data_type7_in_total_rate end as min_browse_data_type7_in_total_rate,
case when max_browse_data_type7_in_total_rate is null then 0 else max_browse_data_type7_in_total_rate end as max_browse_data_type7_in_total_rate,
case when sum_browse_data_type7_in_total_rate is null then 0 else sum_browse_data_type7_in_total_rate end as sum_browse_data_type7_in_total_rate,
case when avg_browse_data_type7_in_total_rate is null then 0 else avg_browse_data_type7_in_total_rate end as avg_browse_data_type7_in_total_rate,
case when min_browse_data_type8_in_total_rate is null then 0 else min_browse_data_type8_in_total_rate end as min_browse_data_type8_in_total_rate,
case when max_browse_data_type8_in_total_rate is null then 0 else max_browse_data_type8_in_total_rate end as max_browse_data_type8_in_total_rate,
case when sum_browse_data_type8_in_total_rate is null then 0 else sum_browse_data_type8_in_total_rate end as sum_browse_data_type8_in_total_rate,
case when avg_browse_data_type8_in_total_rate is null then 0 else avg_browse_data_type8_in_total_rate end as avg_browse_data_type8_in_total_rate,
case when min_browse_data_type9_in_total_rate is null then 0 else min_browse_data_type9_in_total_rate end as min_browse_data_type9_in_total_rate,
case when max_browse_data_type9_in_total_rate is null then 0 else max_browse_data_type9_in_total_rate end as max_browse_data_type9_in_total_rate,
case when sum_browse_data_type9_in_total_rate is null then 0 else sum_browse_data_type9_in_total_rate end as sum_browse_data_type9_in_total_rate,
case when avg_browse_data_type9_in_total_rate is null then 0 else avg_browse_data_type9_in_total_rate end as avg_browse_data_type9_in_total_rate,
case when min_browse_data_type10_in_total_rate is null then 0 else min_browse_data_type10_in_total_rate end as min_browse_data_type10_in_total_rate,
case when max_browse_data_type10_in_total_rate is null then 0 else max_browse_data_type10_in_total_rate end as max_browse_data_type10_in_total_rate,
case when sum_browse_data_type10_in_total_rate is null then 0 else sum_browse_data_type10_in_total_rate end as sum_browse_data_type10_in_total_rate,
case when avg_browse_data_type10_in_total_rate is null then 0 else avg_browse_data_type10_in_total_rate end as avg_browse_data_type10_in_total_rate,
case when min_browse_data_type11_in_total_rate is null then 0 else min_browse_data_type11_in_total_rate end as min_browse_data_type11_in_total_rate,
case when max_browse_data_type11_in_total_rate is null then 0 else max_browse_data_type11_in_total_rate end as max_browse_data_type11_in_total_rate,
case when sum_browse_data_type11_in_total_rate is null then 0 else sum_browse_data_type11_in_total_rate end as sum_browse_data_type11_in_total_rate,
case when avg_browse_data_type11_in_total_rate is null then 0 else avg_browse_data_type11_in_total_rate end as avg_browse_data_type11_in_total_rate
from
feature_user_info_train a01 inner join feature_browse_history_train b01 
on a01.user_id=b01.user_id_browse
)a03 inner join feature_bill_detail_train b03
on a03.user_id=b03.user_id_bill;






--##################  create gui_test_set_not_have_bank_detail_and_inner_join_all  (about have 12000 user) ######################


create table if not exists gui_test_set_not_have_bank_detail_and_inner_join_all as
select a03.*,
case when bill_detail_user_total is null then 0 else bill_detail_user_total end as bill_detail_user_total,
case when bill_detail_user_last_bill_money_beyond_card_limit is null then 0 else bill_detail_user_last_bill_money_beyond_card_limit end as bill_detail_user_last_bill_money_beyond_card_limit,
case when bill_detail_user_this_bill_money_beyond_card_limit is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit end as bill_detail_user_this_bill_money_beyond_card_limit,
case when bill_detail_user_remain_money_beyond_this_bill_money is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money end as bill_detail_user_remain_money_beyond_this_bill_money,
case when bill_detail_user_bank_count is null then 0 else bill_detail_user_bank_count end as bill_detail_user_bank_count,
case when bill_detail_user_bank_count_total_rate is null then 0 else bill_detail_user_bank_count_total_rate end as bill_detail_user_bank_count_total_rate,
case when bill_detail_user_remain_money_beyond_this_bill_money_total_rate is null then 0 else bill_detail_user_remain_money_beyond_this_bill_money_total_rate end as bill_detail_user_remain_money_beyond_this_bill_money_total_rate,
case when bill_detail_user_this_bill_money_beyond_card_limit_total_rate is null then 0 else bill_detail_user_this_bill_money_beyond_card_limit_total_rate end as bill_detail_user_this_bill_money_beyond_card_limit_total_rate,
case when min_last_bill_money is null then 0 else min_last_bill_money end as min_last_bill_money,
case when max_last_bill_money is null then 0 else max_last_bill_money end as max_last_bill_money,
case when avg_last_bill_money is null then 0 else avg_last_bill_money end as avg_last_bill_money,
case when sum_last_bill_money is null then 0 else sum_last_bill_money end as sum_last_bill_money,
case when min_last_repay_money is null then 0 else min_last_repay_money end as min_last_repay_money,
case when max_last_repay_money is null then 0 else max_last_repay_money end as max_last_repay_money,
case when avg_last_repay_money is null then 0 else avg_last_repay_money end as avg_last_repay_money,
case when sum_last_repay_money is null then 0 else sum_last_repay_money end as sum_last_repay_money,
case when min_card_limit is null then 0 else min_card_limit end as min_card_limit,
case when max_card_limit is null then 0 else max_card_limit end as max_card_limit,
case when avg_card_limit is null then 0 else avg_card_limit end as avg_card_limit,
case when sum_card_limit is null then 0 else sum_card_limit end as sum_card_limit,
case when min_this_bill_money_remain is null then 0 else min_this_bill_money_remain end as min_this_bill_money_remain,
case when max_this_bill_money_remain is null then 0 else max_this_bill_money_remain end as max_this_bill_money_remain,
case when sum_this_bill_money_remain is null then 0 else sum_this_bill_money_remain end as sum_this_bill_money_remain,
case when avg_this_bill_money_remain is null then 0 else avg_this_bill_money_remain end as avg_this_bill_money_remain,
case when min_this_bill_min_repay is null then 0 else min_this_bill_min_repay end as min_this_bill_min_repay,
case when max_this_bill_min_repay is null then 0 else max_this_bill_min_repay end as max_this_bill_min_repay,
case when sum_this_bill_min_repay is null then 0 else sum_this_bill_min_repay end as sum_this_bill_min_repay,
case when avg_this_bill_min_repay is null then 0 else avg_this_bill_min_repay end as avg_this_bill_min_repay,
case when min_buy_times is null then 0 else min_buy_times end as min_buy_times,
case when max_buy_times is null then 0 else max_buy_times end as max_buy_times,
case when sum_buy_times is null then 0 else sum_buy_times end as sum_buy_times,
case when avg_buy_times is null then 0 else avg_buy_times end as avg_buy_times,
case when min_this_bill_money is null then 0 else min_this_bill_money end as min_this_bill_money,
case when max_this_bill_money is null then 0 else max_this_bill_money end as max_this_bill_money,
case when sum_this_bill_money is null then 0 else sum_this_bill_money end as sum_this_bill_money,
case when avg_this_bill_money is null then 0 else avg_this_bill_money end as avg_this_bill_money,
case when min_adjust_money is null then 0 else min_adjust_money end as min_adjust_money,
case when max_adjust_money is null then 0 else max_adjust_money end as max_adjust_money,
case when sum_adjust_money is null then 0 else sum_adjust_money end as sum_adjust_money,
case when avg_adjust_money is null then 0 else avg_adjust_money end as avg_adjust_money,
case when min_loop_interest is null then 0 else min_loop_interest end as min_loop_interest,
case when max_loop_interest is null then 0 else max_loop_interest end as max_loop_interest,
case when sum_loop_interest is null then 0 else sum_loop_interest end as sum_loop_interest,
case when avg_loop_interest is null then 0 else avg_loop_interest end as avg_loop_interest,
case when min_remain_money is null then 0 else min_remain_money end as min_remain_money,
case when max_remain_money is null then 0 else max_remain_money end as max_remain_money,
case when sum_remain_money is null then 0 else sum_remain_money end as sum_remain_money,
case when avg_remain_money is null then 0 else avg_remain_money end as avg_remain_money,
case when min_borrow_limit is null then 0 else min_borrow_limit end as min_borrow_limit,
case when max_borrow_limit is null then 0 else max_borrow_limit end as max_borrow_limit,
case when sum_borrow_limit is null then 0 else sum_borrow_limit end as sum_borrow_limit,
case when avg_borrow_limit is null then 0 else avg_borrow_limit end as avg_borrow_limit,
case when min_last_repay_money_in_last_bill_money_rate is null then 0 else min_last_repay_money_in_last_bill_money_rate end as min_last_repay_money_in_last_bill_money_rate,
case when max_last_repay_money_in_last_bill_money_rate is null then 0 else max_last_repay_money_in_last_bill_money_rate end as max_last_repay_money_in_last_bill_money_rate,
case when sum_last_repay_money_in_last_bill_money_rate is null then 0 else sum_last_repay_money_in_last_bill_money_rate end as sum_last_repay_money_in_last_bill_money_rate,
case when avg_last_repay_money_in_last_bill_money_rate is null then 0 else avg_last_repay_money_in_last_bill_money_rate end as avg_last_repay_money_in_last_bill_money_rate,
case when min_last_bill_money_in_card_limit_rate is null then 0 else min_last_bill_money_in_card_limit_rate end as min_last_bill_money_in_card_limit_rate,
case when max_last_bill_money_in_card_limit_rate is null then 0 else max_last_bill_money_in_card_limit_rate end as max_last_bill_money_in_card_limit_rate,
case when sum_last_bill_money_in_card_limit_rate is null then 0 else sum_last_bill_money_in_card_limit_rate end as sum_last_bill_money_in_card_limit_rate,
case when avg_last_bill_money_in_card_limit_rate is null then 0 else avg_last_bill_money_in_card_limit_rate end as avg_last_bill_money_in_card_limit_rate,
case when min_this_bill_money_in_card_limit_rate is null then 0 else min_this_bill_money_in_card_limit_rate end as min_this_bill_money_in_card_limit_rate,
case when max_this_bill_money_in_card_limit_rate is null then 0 else max_this_bill_money_in_card_limit_rate end as max_this_bill_money_in_card_limit_rate,
case when sum_this_bill_money_in_card_limit_rate is null then 0 else sum_this_bill_money_in_card_limit_rate end as sum_this_bill_money_in_card_limit_rate,
case when avg_this_bill_money_in_card_limit_rate is null then 0 else avg_this_bill_money_in_card_limit_rate end as avg_this_bill_money_in_card_limit_rate,
case when min_remain_money_in_card_limit_rate is null then 0 else min_remain_money_in_card_limit_rate end as min_remain_money_in_card_limit_rate,
case when max_remain_money_in_card_limit_rate is null then 0 else max_remain_money_in_card_limit_rate end as max_remain_money_in_card_limit_rate,
case when sum_remain_money_in_card_limit_rate is null then 0 else sum_remain_money_in_card_limit_rate end as sum_remain_money_in_card_limit_rate,
case when avg_remain_money_in_card_limit_rate is null then 0 else avg_remain_money_in_card_limit_rate end as avg_remain_money_in_card_limit_rate,
case when min_borrow_limit_in_card_limit_rate is null then 0 else min_borrow_limit_in_card_limit_rate end as min_borrow_limit_in_card_limit_rate,
case when max_borrow_limit_in_card_limit_rate is null then 0 else max_borrow_limit_in_card_limit_rate end as max_borrow_limit_in_card_limit_rate,
case when sum_borrow_limit_in_card_limit_rate is null then 0 else sum_borrow_limit_in_card_limit_rate end as sum_borrow_limit_in_card_limit_rate,
case when avg_borrow_limit_in_card_limit_rate is null then 0 else avg_borrow_limit_in_card_limit_rate end as avg_borrow_limit_in_card_limit_rate,
case when min_this_bill_money_remain_in_this_bill_money_rate is null then 0 else min_this_bill_money_remain_in_this_bill_money_rate end as min_this_bill_money_remain_in_this_bill_money_rate,
case when max_this_bill_money_remain_in_this_bill_money_rate is null then 0 else max_this_bill_money_remain_in_this_bill_money_rate end as max_this_bill_money_remain_in_this_bill_money_rate,
case when sum_this_bill_money_remain_in_this_bill_money_rate is null then 0 else sum_this_bill_money_remain_in_this_bill_money_rate end as sum_this_bill_money_remain_in_this_bill_money_rate,
case when avg_this_bill_money_remain_in_this_bill_money_rate is null then 0 else avg_this_bill_money_remain_in_this_bill_money_rate end as avg_this_bill_money_remain_in_this_bill_money_rate
from
(
select a01.*,
case when browse_history_user_total is null then 0 else browse_history_user_total end as browse_history_user_total,
case when browse_history_user_browse_type1 is null then 0 else browse_history_user_browse_type1 end as browse_history_user_browse_type1,
case when browse_history_user_browse_type2 is null then 0 else browse_history_user_browse_type2 end as browse_history_user_browse_type2,
case when browse_history_user_browse_type3 is null then 0 else browse_history_user_browse_type3 end as browse_history_user_browse_type3,
case when browse_history_user_browse_type4 is null then 0 else browse_history_user_browse_type4 end as browse_history_user_browse_type4,
case when browse_history_user_browse_type5 is null then 0 else browse_history_user_browse_type5 end as browse_history_user_browse_type5,
case when browse_history_user_browse_type6 is null then 0 else browse_history_user_browse_type6 end as browse_history_user_browse_type6,
case when browse_history_user_browse_type7 is null then 0 else browse_history_user_browse_type7 end as browse_history_user_browse_type7,
case when browse_history_user_browse_type8 is null then 0 else browse_history_user_browse_type8 end as browse_history_user_browse_type8,
case when browse_history_user_browse_type9 is null then 0 else browse_history_user_browse_type9 end as browse_history_user_browse_type9,
case when browse_history_user_browse_type10 is null then 0 else browse_history_user_browse_type10 end as browse_history_user_browse_type10,
case when browse_history_user_browse_type11 is null then 0 else browse_history_user_browse_type11 end as browse_history_user_browse_type11,
case when browse_history_user_browse_type1_total_rate is null then 0 else browse_history_user_browse_type1_total_rate end as browse_history_user_browse_type1_total_rate,
case when browse_history_user_browse_type2_total_rate is null then 0 else browse_history_user_browse_type2_total_rate end as browse_history_user_browse_type2_total_rate,
case when browse_history_user_browse_type3_total_rate is null then 0 else browse_history_user_browse_type3_total_rate end as browse_history_user_browse_type3_total_rate,
case when browse_history_user_browse_type4_total_rate is null then 0 else browse_history_user_browse_type4_total_rate end as browse_history_user_browse_type4_total_rate,
case when browse_history_user_browse_type5_total_rate is null then 0 else browse_history_user_browse_type5_total_rate end as browse_history_user_browse_type5_total_rate,
case when browse_history_user_browse_type6_total_rate is null then 0 else browse_history_user_browse_type6_total_rate end as browse_history_user_browse_type6_total_rate,
case when browse_history_user_browse_type7_total_rate is null then 0 else browse_history_user_browse_type7_total_rate end as browse_history_user_browse_type7_total_rate,
case when browse_history_user_browse_type8_total_rate is null then 0 else browse_history_user_browse_type8_total_rate end as browse_history_user_browse_type8_total_rate,
case when browse_history_user_browse_type9_total_rate is null then 0 else browse_history_user_browse_type9_total_rate end as browse_history_user_browse_type9_total_rate,
case when browse_history_user_browse_type10_total_rate is null then 0 else browse_history_user_browse_type10_total_rate end as browse_history_user_browse_type10_total_rate,
case when browse_history_user_browse_type11_total_rate is null then 0 else browse_history_user_browse_type11_total_rate end as browse_history_user_browse_type11_total_rate,
case when min_browse_data is null then 0 else min_browse_data end as min_browse_data,
case when max_browse_data is null then 0 else max_browse_data end as max_browse_data,
case when sum_browse_data is null then 0 else sum_browse_data end as sum_browse_data,
case when avg_browse_data is null then 0 else avg_browse_data end as avg_browse_data,
case when min_browse_data_type1 is null then 0 else min_browse_data_type1 end as min_browse_data_type1,
case when max_browse_data_type1 is null then 0 else max_browse_data_type1 end as max_browse_data_type1,
case when sum_browse_data_type1 is null then 0 else sum_browse_data_type1 end as sum_browse_data_type1,
case when avg_browse_data_type1 is null then 0 else avg_browse_data_type1 end as avg_browse_data_type1,
case when min_browse_data_type2 is null then 0 else min_browse_data_type2 end as min_browse_data_type2,
case when max_browse_data_type2 is null then 0 else max_browse_data_type2 end as max_browse_data_type2,
case when sum_browse_data_type2 is null then 0 else sum_browse_data_type2 end as sum_browse_data_type2,
case when avg_browse_data_type2 is null then 0 else avg_browse_data_type2 end as avg_browse_data_type2,
case when min_browse_data_type3 is null then 0 else min_browse_data_type3 end as min_browse_data_type3,
case when max_browse_data_type3 is null then 0 else max_browse_data_type3 end as max_browse_data_type3,
case when sum_browse_data_type3 is null then 0 else sum_browse_data_type3 end as sum_browse_data_type3,
case when avg_browse_data_type3 is null then 0 else avg_browse_data_type3 end as avg_browse_data_type3,
case when min_browse_data_type4 is null then 0 else min_browse_data_type4 end as min_browse_data_type4,
case when max_browse_data_type4 is null then 0 else max_browse_data_type4 end as max_browse_data_type4,
case when sum_browse_data_type4 is null then 0 else sum_browse_data_type4 end as sum_browse_data_type4,
case when avg_browse_data_type4 is null then 0 else avg_browse_data_type4 end as avg_browse_data_type4,
case when min_browse_data_type5 is null then 0 else min_browse_data_type5 end as min_browse_data_type5,
case when max_browse_data_type5 is null then 0 else max_browse_data_type5 end as max_browse_data_type5,
case when sum_browse_data_type5 is null then 0 else sum_browse_data_type5 end as sum_browse_data_type5,
case when avg_browse_data_type5 is null then 0 else avg_browse_data_type5 end as avg_browse_data_type5,
case when min_browse_data_type6 is null then 0 else min_browse_data_type6 end as min_browse_data_type6,
case when max_browse_data_type6 is null then 0 else max_browse_data_type6 end as max_browse_data_type6,
case when sum_browse_data_type6 is null then 0 else sum_browse_data_type6 end as sum_browse_data_type6,
case when avg_browse_data_type6 is null then 0 else avg_browse_data_type6 end as avg_browse_data_type6,
case when min_browse_data_type7 is null then 0 else min_browse_data_type7 end as min_browse_data_type7,
case when max_browse_data_type7 is null then 0 else max_browse_data_type7 end as max_browse_data_type7,
case when sum_browse_data_type7 is null then 0 else sum_browse_data_type7 end as sum_browse_data_type7,
case when avg_browse_data_type7 is null then 0 else avg_browse_data_type7 end as avg_browse_data_type7,
case when min_browse_data_type8 is null then 0 else min_browse_data_type8 end as min_browse_data_type8,
case when max_browse_data_type8 is null then 0 else max_browse_data_type8 end as max_browse_data_type8,
case when sum_browse_data_type8 is null then 0 else sum_browse_data_type8 end as sum_browse_data_type8,
case when avg_browse_data_type8 is null then 0 else avg_browse_data_type8 end as avg_browse_data_type8,
case when min_browse_data_type9 is null then 0 else min_browse_data_type9 end as min_browse_data_type9,
case when max_browse_data_type9 is null then 0 else max_browse_data_type9 end as max_browse_data_type9,
case when sum_browse_data_type9 is null then 0 else sum_browse_data_type9 end as sum_browse_data_type9,
case when avg_browse_data_type9 is null then 0 else avg_browse_data_type9 end as avg_browse_data_type9,
case when min_browse_data_type10 is null then 0 else min_browse_data_type10 end as min_browse_data_type10,
case when max_browse_data_type10 is null then 0 else max_browse_data_type10 end as max_browse_data_type10,
case when sum_browse_data_type10 is null then 0 else sum_browse_data_type10 end as sum_browse_data_type10,
case when avg_browse_data_type10 is null then 0 else avg_browse_data_type10 end as avg_browse_data_type10,
case when min_browse_data_type11 is null then 0 else min_browse_data_type11 end as min_browse_data_type11,
case when max_browse_data_type11 is null then 0 else max_browse_data_type11 end as max_browse_data_type11,
case when sum_browse_data_type11 is null then 0 else sum_browse_data_type11 end as sum_browse_data_type11,
case when avg_browse_data_type11 is null then 0 else avg_browse_data_type11 end as avg_browse_data_type11,
case when min_browse_data_type1_in_total_rate is null then 0 else min_browse_data_type1_in_total_rate end as min_browse_data_type1_in_total_rate,
case when max_browse_data_type1_in_total_rate is null then 0 else max_browse_data_type1_in_total_rate end as max_browse_data_type1_in_total_rate,
case when sum_browse_data_type1_in_total_rate is null then 0 else sum_browse_data_type1_in_total_rate end as sum_browse_data_type1_in_total_rate,
case when avg_browse_data_type1_in_total_rate is null then 0 else avg_browse_data_type1_in_total_rate end as avg_browse_data_type1_in_total_rate,
case when min_browse_data_type2_in_total_rate is null then 0 else min_browse_data_type2_in_total_rate end as min_browse_data_type2_in_total_rate,
case when max_browse_data_type2_in_total_rate is null then 0 else max_browse_data_type2_in_total_rate end as max_browse_data_type2_in_total_rate,
case when sum_browse_data_type2_in_total_rate is null then 0 else sum_browse_data_type2_in_total_rate end as sum_browse_data_type2_in_total_rate,
case when avg_browse_data_type2_in_total_rate is null then 0 else avg_browse_data_type2_in_total_rate end as avg_browse_data_type2_in_total_rate,
case when min_browse_data_type3_in_total_rate is null then 0 else min_browse_data_type3_in_total_rate end as min_browse_data_type3_in_total_rate,
case when max_browse_data_type3_in_total_rate is null then 0 else max_browse_data_type3_in_total_rate end as max_browse_data_type3_in_total_rate,
case when sum_browse_data_type3_in_total_rate is null then 0 else sum_browse_data_type3_in_total_rate end as sum_browse_data_type3_in_total_rate,
case when avg_browse_data_type3_in_total_rate is null then 0 else avg_browse_data_type3_in_total_rate end as avg_browse_data_type3_in_total_rate,
case when min_browse_data_type4_in_total_rate is null then 0 else min_browse_data_type4_in_total_rate end as min_browse_data_type4_in_total_rate,
case when max_browse_data_type4_in_total_rate is null then 0 else max_browse_data_type4_in_total_rate end as max_browse_data_type4_in_total_rate,
case when sum_browse_data_type4_in_total_rate is null then 0 else sum_browse_data_type4_in_total_rate end as sum_browse_data_type4_in_total_rate,
case when avg_browse_data_type4_in_total_rate is null then 0 else avg_browse_data_type4_in_total_rate end as avg_browse_data_type4_in_total_rate,
case when min_browse_data_type5_in_total_rate is null then 0 else min_browse_data_type5_in_total_rate end as min_browse_data_type5_in_total_rate,
case when max_browse_data_type5_in_total_rate is null then 0 else max_browse_data_type5_in_total_rate end as max_browse_data_type5_in_total_rate,
case when sum_browse_data_type5_in_total_rate is null then 0 else sum_browse_data_type5_in_total_rate end as sum_browse_data_type5_in_total_rate,
case when avg_browse_data_type5_in_total_rate is null then 0 else avg_browse_data_type5_in_total_rate end as avg_browse_data_type5_in_total_rate,
case when min_browse_data_type6_in_total_rate is null then 0 else min_browse_data_type6_in_total_rate end as min_browse_data_type6_in_total_rate,
case when max_browse_data_type6_in_total_rate is null then 0 else max_browse_data_type6_in_total_rate end as max_browse_data_type6_in_total_rate,
case when sum_browse_data_type6_in_total_rate is null then 0 else sum_browse_data_type6_in_total_rate end as sum_browse_data_type6_in_total_rate,
case when avg_browse_data_type6_in_total_rate is null then 0 else avg_browse_data_type6_in_total_rate end as avg_browse_data_type6_in_total_rate,
case when min_browse_data_type7_in_total_rate is null then 0 else min_browse_data_type7_in_total_rate end as min_browse_data_type7_in_total_rate,
case when max_browse_data_type7_in_total_rate is null then 0 else max_browse_data_type7_in_total_rate end as max_browse_data_type7_in_total_rate,
case when sum_browse_data_type7_in_total_rate is null then 0 else sum_browse_data_type7_in_total_rate end as sum_browse_data_type7_in_total_rate,
case when avg_browse_data_type7_in_total_rate is null then 0 else avg_browse_data_type7_in_total_rate end as avg_browse_data_type7_in_total_rate,
case when min_browse_data_type8_in_total_rate is null then 0 else min_browse_data_type8_in_total_rate end as min_browse_data_type8_in_total_rate,
case when max_browse_data_type8_in_total_rate is null then 0 else max_browse_data_type8_in_total_rate end as max_browse_data_type8_in_total_rate,
case when sum_browse_data_type8_in_total_rate is null then 0 else sum_browse_data_type8_in_total_rate end as sum_browse_data_type8_in_total_rate,
case when avg_browse_data_type8_in_total_rate is null then 0 else avg_browse_data_type8_in_total_rate end as avg_browse_data_type8_in_total_rate,
case when min_browse_data_type9_in_total_rate is null then 0 else min_browse_data_type9_in_total_rate end as min_browse_data_type9_in_total_rate,
case when max_browse_data_type9_in_total_rate is null then 0 else max_browse_data_type9_in_total_rate end as max_browse_data_type9_in_total_rate,
case when sum_browse_data_type9_in_total_rate is null then 0 else sum_browse_data_type9_in_total_rate end as sum_browse_data_type9_in_total_rate,
case when avg_browse_data_type9_in_total_rate is null then 0 else avg_browse_data_type9_in_total_rate end as avg_browse_data_type9_in_total_rate,
case when min_browse_data_type10_in_total_rate is null then 0 else min_browse_data_type10_in_total_rate end as min_browse_data_type10_in_total_rate,
case when max_browse_data_type10_in_total_rate is null then 0 else max_browse_data_type10_in_total_rate end as max_browse_data_type10_in_total_rate,
case when sum_browse_data_type10_in_total_rate is null then 0 else sum_browse_data_type10_in_total_rate end as sum_browse_data_type10_in_total_rate,
case when avg_browse_data_type10_in_total_rate is null then 0 else avg_browse_data_type10_in_total_rate end as avg_browse_data_type10_in_total_rate,
case when min_browse_data_type11_in_total_rate is null then 0 else min_browse_data_type11_in_total_rate end as min_browse_data_type11_in_total_rate,
case when max_browse_data_type11_in_total_rate is null then 0 else max_browse_data_type11_in_total_rate end as max_browse_data_type11_in_total_rate,
case when sum_browse_data_type11_in_total_rate is null then 0 else sum_browse_data_type11_in_total_rate end as sum_browse_data_type11_in_total_rate,
case when avg_browse_data_type11_in_total_rate is null then 0 else avg_browse_data_type11_in_total_rate end as avg_browse_data_type11_in_total_rate
from
feature_user_info_test a01 inner join feature_browse_history_test b01 
on a01.user_id=b01.user_id_browse
)a03 inner join feature_bill_detail_test b03
on a03.user_id=b03.user_id_bill;





--#  create table gui_train_set_just_user_info_55000 (55000 all users)

create table if not exists gui_train_set_just_user_info_55000 as 
select *
from
feature_user_info_train;


--# create table gui_test_set_just_user_info_2000  (2000 users )

create table if not exists gui_test_set_just_user_info_2000 as 
select a.*
from 
feature_user_info_test a where a.user_id not in (select user_id from gui_test_set_not_have_bank_detail_and_inner_join_all)  ;


--# create table gui_test_set_beyond_max_loan_time_test (about 7000 users)

create table if not exists gui_test_set_beyond_max_loan_time_test
select user_id_bill,count(*) as user_id_bill_beyond_max_loan_time_count from bill_detail_test where bill_time >5934036687 and repay_state =0 group by user_id_bill ;










