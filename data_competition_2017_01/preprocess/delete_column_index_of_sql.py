import pandas as pd
from sqlalchemy import create_engine
import sys
try:
    database_name=sys.argv[1]
    tablename=sys.argv[2]
except:
    raise Exception('usage: python '+str(sys.argv[0])+' database_name tablename')
del_column_name='index'

def change_sql():
    engine=create_engine('mysql://root:0@localhost/'+database_name)
    sql='select * from '+str(tablename)
    df_sql=pd.read_sql(sql,engine)
    try:
        df_sql.drop(del_column_name,axis=1, inplace=True)
    except:
        raise Exception(' no "index"')
    df_sql.to_sql(tablename+"__",engine,index=False,chunksize=10000)
    return df_sql

if __name__=='__main__':
    change_sql()
