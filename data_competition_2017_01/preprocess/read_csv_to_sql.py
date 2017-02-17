import sys
from sqlalchemy import create_engine
import pandas as pd
import MySQLdb
import time
start=time.time()
if len(sys.argv)!=3:
    print ('usage: python '+str(sys.argv[0])+' csv_file database_name ')
    sys.exit()
csv_file=sys.argv[1]
database_name=sys.argv[2]
table_name=sys.argv[1].split('/')[-1].split('.')[0]
#####
engine=create_engine('mysql://root:0@localhost/'+database_name)
conn = MySQLdb.connect(host = "localhost", user = "root", passwd = "0", db = database_name, charset="utf8")
cur = conn.cursor()
cur.execute('drop table '+" if exists "+table_name)
with open(sys.argv[1],'r') as fr:
    line_0_0=fr.readline().split(',')[0]   ##read the first line first str
try:
    line_0_0_int=int(line_0_0)   # if line_0_0 is str then raise Exception
    df=pd.read_csv(csv_file,header=None)
    print ("please input the "+str(df.shape[1])+' columns name')
    columns=raw_input("please split with ',': \n").split(',')
    print "columns: ",columns
    #columns=[]
    #for i in range(df.shape[1]):
    #    columns.append(raw_input(" column_"+str(i)+' : '))
    df.columns=columns
    df.to_sql(table_name,engine,index=False,chunksize=10000)
except:
    print ("this csv_file has columns")
    df=pd.read_csv(csv_file)
    df.to_sql(table_name,engine,index=False,chunksize=10000)
print("has write into sql ")
df.to_csv(csv_file,index=False)
print("has write into csv")
end=time.time()
print ("run_time: "+str(end-start)+' s')



