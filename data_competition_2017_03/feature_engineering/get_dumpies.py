import fire
import pandas as pd
from sqlalchemy import create_engine
def get_dumpy(db_name,old_table_name,new_table_name,column_li):
    print column_li
    print "please ensure the table is not chinese "
    engine=create_engine("mysql://root:0@localhost/"+db_name)
    sql1="select * from "+old_table_name
    print "Load data from "+db_name+"."+old_table_name
    df_old=pd.read_sql(sql1,engine)
    print "old_shape: ",df_old.shape
    df_new=pd.get_dummies(df_old,columns=column_li)
    print "new_shape: ",df_new.shape
    print "insert data to "+db_name+"."+new_table_name
    df_new.to_sql(new_table_name,engine,index=False,chunksize=1000,if_exists="replace")

if __name__=="__main__":
    fire.Fire(get_dumpy)
