import os
dir_1='/home/gui/work2017/work_of_sql/datacastle/train/'
dir_2='/home/gui/work2017/work_of_sql/datacastle/test/'
li_1=os.listdir(dir_1)
print li_1
li_2=os.listdir(dir_2)
for file1 in li_1:
    os.system("python read_csv_to_sql.py "+dir_1+file1+" datacastle1")
for file2 in li_2:
    os.system("python read_csv_to_sql.py "+dir_2+file2+" datacastle1")
