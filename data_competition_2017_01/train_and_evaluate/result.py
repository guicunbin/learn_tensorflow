#!/usr/bin/python
#encoding: utf-8

import csv
import sys
import re

if len(sys.argv) != 2:
    print("usage: "+sys.argv[0]+" [csv file]")
    sys.exit(1)

csv_file=sys.argv[1]
file=open(csv_file,'r')
result=csv.reader(file)
pos_num=0
neg_num=0
num=0
data=list()
#read the pro and labels
for row in result:
    if num > 0:
        if row[2]== '1.0':
            pos_num += 1
        if row[2]== '0.0':
            neg_num += 1
        data.append([float(row[1]),float(row[2])])
    num += 1
#    print(row,num)
file.close()
#print 'pos_num: ',pos_num
#print 'neg_num: ',neg_num
#sort by pro
data.sort(key=lambda x:x[0],reverse=False)
#for i in range(len(data)):
#    print data[i]
#print(data)
#calculate the score
score_pos=dict()
score_neg=dict()
score_pos_num=0
score_neg_num=0
for i in range(len(data)):
#    print data[i]
    if data[i][1]==1.0 :
        if data[i][0] not in score_pos :
            score_pos[data[i][0]]=score_pos_num+1
        else:
            score_pos[data[i][0]] += 1
        score_pos_num += 1
        if data[i][0] not in score_neg:
            score_neg[data[i][0]]=score_neg_num
    if data[i][1]==0.0:
        if data[i][0] not in score_neg:
            score_neg[data[i][0]]=score_neg_num+1
        else:
            score_neg[data[i][0]] += 1
        score_neg_num += 1
        if data[i][0] not in score_pos:
            score_pos[data[i][0]]=score_pos_num
#check 
#    print score_pos[data[i][0]]
#print score_neg
#print score_pos
if score_neg_num+score_pos_num!= pos_num + neg_num:
    print("something went wrong,the number is different")
    sys.exit(1)
#get the final score
#score=dict()
max_value=0

for x in score_pos:
    pos_rate=round(score_pos[x]*1.0/pos_num,5)
    neg_rate=round(score_neg[x]*1.0/neg_num,5)
   # print pos_rate,neg_rate
    tmp=abs(pos_rate-neg_rate)
  #  print ("pos_rate,neg_rate,tmp :",pos_rate,neg_rate,tmp)
    if tmp > max_value:
        max_value=tmp
       # print pos_rate,neg_rate
print("the score is:",max_value)

