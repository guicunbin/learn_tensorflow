import fire
import pandas as pd
import numpy as np
from sqlalchemy import create_engine
engine_global=create_engine('mysql://root:0@localhost/'+"tianchi_2017_03_v3")


def get_from_mysql(table_train,db='tianchi_2017_03_v3'):
    sql1='select * from '+table_train
    print('Load data...')
    engine=create_engine('mysql://root:0@localhost/'+db)
    df_train=pd.read_sql(sql1,engine)
    return df_train




def add_median_features(df,column_name_li,median_type):
    if median_type==1:
        for column_name in column_name_li:
            df_col=df.groupby('shop_id',as_index=False)[column_name].median().rename(columns={column_name:"median_"+column_name})
            df=pd.merge(df,df_col,on='shop_id')
        return df
    else:
        for column_name in column_name_li:
            columns=["before_"+str(i)+"_"+column_name for i in range(1,8)]
            for j in range(len(df)):
                ## this is j row 
                j_list=[]
                for col in columns:
                    j_list.append(df.loc[j,col])
                print j_list
                print np.mean(j_list)
                df.loc[j,'last_7_days_median_'+column_name]=np.mean(j_list)
    return df




def recreate_table(train_table,median_type):
    '''
    median_type=1:  get the median_value  group by    shop_id;  so every shop_id has a value 
    median_type=0:  get the median_value  group by  every row;  so every row     has a value 
    '''
    if median_type==1:
        df_train = get_from_mysql(train_table)
        column_name_li=["user_pay_shop_with_user_cnt",
                        "user_pay_day_shop_id_cnt",
                        "user_pay_shop_id_cnt",
                        "user_pay_shop_with_day_cnt",
                        "user_pay_day_with_shop_cnt",
                        "user_pay_day_with_user_cnt",
                        "user_pay_day_shop_in_shop_rate",
                        "user_pay_day_shop_id_cnt_no_distinct",
                        "user_pay_day_with_user_cnt_no_distinct"]
        df_train=add_median_features(df_train,column_name_li,median_type)
        df_train.to_sql(train_table,engine_global,if_exists="replace",index=False,chunksize=5000)
    else:
        df_train = get_from_mysql(train_table)
        column_name_li=["user_pay_shop_with_user_cnt",
                        "user_pay_day_shop_id_cnt",
                        "user_pay_shop_id_cnt",
                        "user_pay_shop_with_day_cnt",
                        "user_pay_day_with_shop_cnt",
                        "user_pay_day_with_user_cnt",
                        "user_pay_day_shop_in_shop_rate",
                        "label",
                        "user_pay_day_with_user_cnt_no_distinct"]
        df_train=add_median_features(df_train,column_name_li,median_type)
        df_train.to_sql(train_table,engine_global,if_exists="replace",index=False,chunksize=5000)



if __name__=="__main__":
    fire.Fire(recreate_table)
    
