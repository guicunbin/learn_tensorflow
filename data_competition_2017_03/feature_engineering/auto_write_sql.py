sql1="create table if not exists gui_train_set_10_shop_id_"
sql2="  as select shop_id,pay_day,week_num,day_distance_to_20161114,week_distance_to_20161114,weekday_0_to_6,\
                day_of_pay_day, month_of_pay_day, weather_1,weather_2,weather_3, holiday, \
                label from gui_train_set_10 where shop_id="
sql3="create index index0 on gui_train_set_10_shop_id_"
sql4="  (pay_day)"
sql5="--## create train and valid set"
sql6='_train as  select * from   gui_train_set_10_shop_id_'
sql7='  where pay_day<="2016-10-17"'
sql8='_valid as  select * from   gui_train_set_10_shop_id_'
sql9='  where pay_day>="2016-10-18"'
with open("/home/gui/work2017/tianchi_2017_03/work_of_sql/feature_of_tianchi_2017_03_v3_add.sql",'w') as fw:
    for i in range(1,2001):
        sql12=sql1+str(i)+sql2+str(i)+';\n\n'
        fw.writelines(sql12)
        #### create index
        sql34=sql3+str(i)+sql4+';\n\n'
        fw.writelines(sql34)
        #### create train valid set
        fw.writelines(sql5+'\n')
        sql167=sql1+str(i)+sql6+str(i)+sql7+';\n'
        sql189=sql1+str(i)+sql8+str(i)+sql9+';\n'
        fw.writelines(sql167+sql189)
        fw.writelines("\n\n\n\n")
