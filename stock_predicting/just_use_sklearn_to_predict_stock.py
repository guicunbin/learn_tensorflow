
#######################

def loadgupiao(num='000651',fromSQL=True):
    '''
    return: 4 lists; 
    return traindata,trainlabel,testdata,testlabel 
    '''
    print ' loading the share '+num
    import pandas as pd
    import tushare as ts
    import numpy as np
    from sqlalchemy import create_engine
    engine=create_engine('mysql://root:0@localhost/share')
    if fromSQL:
        sql1='select * from code_'+num
        datamat=mat(pd.read_sql(sql1,engine))    
        datamat=delete(datamat,0,1)   # the end 1  is denote: the column  # so this is to delete the column of index
        data=datamat[:,0:-1]
        label=datamat[:,-1]
    else:
        datamat=mat(ts.get_hist_data(num))
        data=column_stack((datamat[:,0:6],datamat[:,-1]))
        label=datamat[:,6]
    ##### the sign is to predict the stock is up or down #####
    #    label=sign(datamat[:,5])
    #######the following is making the + or - samples'number to be same  
    data=np.delete(data,0,0)
    label=np.delete(label,-1,0)
    #####  add the before 2 days' data####
    m=shape(data)[0]
    data1=mat(ones(shape(data)))
    data2=mat(ones(shape(data)))
    for i in range(m-1):
        data1[i]=data[i+1]
    for i in range(m-2):
        data2[i]=data[i+2]
    data=column_stack((data2,data1,data))
    data=delete(data,[-1,-2],0)
    label=delete(label,[-1,-2],0)
    #####################################
    uptop_index=[]
    not_uptop_index=[]
    for i in range(len(label)):
        if float(label[i])>9.0:
            label[i,0]=1
            uptop_index.append(i)
        else:
            label[i,0]=-1
            not_uptop_index.append(i)
    len1=len(uptop_index)
    len2=len(not_uptop_index)
    del_index=[]
    for i in range(len2-len1-2):
        j=random.randint(0,len(data)-1)
        while (j in uptop_index) or (j in del_index): # need two condition to ensure the del_index don't have the same element 
            j=random.randint(0,len(data)-1)
        del_index.append(j)
    print 'len(del_index) : ',len(del_index)
    print 'before delete shape(label): shape(data):  ',shape(label),shape(data)
    label=np.delete(label,del_index,0)
    data=np.delete(data,del_index,0)
    print 'after delete :  len(label):',len(label)
    ####the following 3 line is regular the data###                                    
    for i in range(shape(data)[0]):
        dp=float(data[i]*data[i].T)**(0.5)
        data[i]=data[i]/dp
    ######the following 4 line is shuffle the data_label
    data_label_mat=column_stack((data,label))
    data_label_list=data_label_mat.tolist()
    random.shuffle(data_label_list)
    data_label_mat11=mat(data_label_list)
    ###############################################
    data=data_label_mat11[:,0:-1].tolist()
    label=array(data_label_mat11[:,-1]).reshape(-1,).tolist()
    return data,label



def extend_share_data(gupiaolist,numtraindata=100000,numtestdata=10000,fromSQL=True): 
    from sqlalchemy import create_engine
    import pandas as pd
    import random
    engine=create_engine('mysql://root:0@localhost/share')
    data=[]
    label=[]
    for i in range(len(gupiaolist)):
        sql2='select * from code_'+gupiaolist[i]
        try:
            df=pd.read_sql(sql2,engine)
            print 'the share '+gupiaolist[i]+' data length : ',len(mat(df))
            if len(mat(df))<5:
                continue
        except:
            continue
        data1,label1=loadgupiao(gupiaolist[i],fromSQL)
        data.extend(data1)
        label.extend(label1)
    if len(data)<(numtraindata+numtestdata):
        numtraindata=int(len(data)*0.8)
        numtestdata=len(data)-numtraindata
    print " shape(data),shape(label):  ",shape(data),shape(label)
    ##### the list to shuffle #####
    data_label=column_stack((mat(data),mat(label).T)).tolist()
    random.shuffle(data_label)
    data_label=mat(data_label)
    data=data_label[:,:-1].tolist()
    label=array(data_label[:,-1]).reshape(-1,).tolist()
    ##################################
    print 'label[0:10]:  ',label[0:10]
    print " shape(data),shape(label):  ",shape(data),shape(label)
    traindata1=data[0:numtraindata]
    trainlabel1=label[0:numtraindata]
    print " shape(traindata1),shape(trainlabel1):  ",shape(traindata1),shape(trainlabel1)
    testdata1=data[numtraindata:numtestdata+numtraindata]
    testlabel1=label[numtraindata:numtestdata+numtraindata]
    return traindata1,trainlabel1,testdata1,testlabel1 



def new_share_data(gupiaolist):
    newdata=[]
    newdata_code=[]
    for i in range(len(gupiaolist)):
        data0=ts.get_hist_data(gupiaolist[i])     
        ## the new day'data need to get from net  instead of sql
        if data0 is not None and len(mat(data0))>5:
            datamat0=mat(data0)
            newdaymat0=column_stack((datamat0[0,0:6],datamat0[0,-1]))
            newdaymat1=column_stack((datamat0[1,0:6],datamat0[1,-1]))
            newdaymat2=column_stack((datamat0[2,0:6],datamat0[2,-1]))
            newdaymat=column_stack((newdaymat0,newdaymat1,newdaymat2))
            newdaylist=array(newdaymat).reshape(-1,).tolist()
            newdata.append(newdaylist)
            newdata_code.append(gupiaolist[i])
            print 'has load the new day data  of the share '+gupiaolist[i]
    return newdata,newdata_code



def paqu_code_stock():
    import re
    import urllib
    page = urllib.urlopen('http://quote.eastmoney.com/stocklist.html')
    html = page.read()
    reg = r'\d{6}'
    regg = re.compile(reg)
    list1 = re.findall(regg,html)
    list2=list(set(list1))
    random.shuffle(list2)
    return list2     




def stock_data_2_sql():
    from sqlalchemy import create_engine
    import tushare as ts 
    import pandas as pd    
    gupiaolist=paqu_code_stock()
    print 'len(gupiaolist):  ',len(gupiaolist)
    engine=create_engine('mysql://root:0@localhost/share')
    for i in range(len(gupiaolist)):
        df = ts.get_hist_data(gupiaolist[i])
        if df is not None and shape(mat(df))[1]==14 and shape(mat(df)[0])>10:
            datamat=column_stack((mat(df)[:,0:6],mat(df)[:,-1]))
            labelmat=mat(df)[:,6]
            data_label_mat=column_stack((datamat,labelmat))
            column_names=['open', 'high', 'close', 'low', 'volume','price_change','turnover','p_change']
            df1=pd.DataFrame(data=data_label_mat,columns=column_names)
            df1.to_sql('code_'+gupiaolist[i],engine)
            print('has insert    '+str(i)+' : '+str(gupiaolist[i]))




def GBDT_train_test_gupiao_fromSQL(num_trees=10,numSteps=0.1,Mdepth=5, num_gupiao=4000,iternum=100,numtraindata=1000000,numtestdata=100000,fromSQL=True):
    '''
    return weakClassArr # the list of dicts of decision trees
    return uptop_code  #the list of code of up to top
    '''
    import tushare as ts
    import numpy as np
    from sklearn.ensemble import GradientBoostingClassifier
    import time
    start=time.clock()
    ####the follwing is to get gupiaolist
    gupiaolist_all=paqu_code_stock()
    index_list0=np.random.uniform(0,len(gupiaolist_all),(1,num_gupiao)).reshape(-1,).tolist()
    index_list=[int(ele) for ele in index_list0]
    gupiaolist=[gupiaolist_all[j] for j in index_list]
    ############################################ 
    traindata,trainlabel,testdata,testlabel=extend_share_data(gupiaolist,numtraindata,numtestdata,fromSQL)
    GBDT=GradientBoostingClassifier(n_estimators=num_trees,learning_rate=numSteps,max_depth=Mdepth)
    print ' shape(traindata),shape(trainlabel) : ' , shape(traindata),shape(trainlabel)
    GBDT=GBDT.fit(traindata,trainlabel)
    predictlabel=GBDT.predict(testdata)
    predict_trainlabel=GBDT.predict(traindata)
    print 'shape(predictlabel),shape(predict_trainlabel):   ',shape(predictlabel),shape(predict_trainlabel)
    newdata,newdata_code=new_share_data(gupiaolist)   # the gupiaolist's gupiao has some invaild 
    predict_newday=GBDT.predict(newdata)
    uptop_code=[]
    for i in range(len(predict_newday)):
        if predict_newday[i]==1:
            print str(newdata_code[i])+' will up to top'
            uptop_code.append(newdata_code[i])
    uptop_code=list(set(uptop_code))
    print 'len(newdata),len(uptop_code) :  ',len(newdata),len(uptop_code)
    print 'len(traindata), len(testdata) ',len(traindata), len(testdata) 
    print " shape(mat(predict_trainlabel)),shape(mat(trainlabel)) : ",shape(mat(predict_trainlabel)),shape(mat(trainlabel)) 
    cor_train= str(correct_rate(mat(predict_trainlabel),mat(trainlabel)))
    cor_test=  str(correct_rate(mat(predictlabel),mat(testlabel)))
    rec_train= str(recall_rate(mat(predict_trainlabel),mat(trainlabel)))
    rec_test=  str(recall_rate(mat(predictlabel),mat(testlabel)))
    ##########these will be write to uptop_code.txt  ################# 
    uptop_code_txt=[ele+'\n' for ele in uptop_code]
    rate_txt=['the correct rate of traindata: '+cor_train+'\n','the correct rate of testdata:  '+cor_test+'\n','the recall rate of traindata: '+rec_train+'\n','the recall rate of testdata:  '+rec_test+'\n']
    arguments=[num_trees,numSteps,Mdepth]
    argu_str=[str(ele)+'\t' for ele in arguments]
    ##########these will be write to uptop_code.txt   #####################
    for ele in rate_txt:
        print ele
    with open('uptop_code.txt','w') as f:
        f.writelines(uptop_code_txt)
        f.writelines(rate_txt)
        f.writelines(argu_str)
    end=time.clock()
    print('the running time :   '+str(end-start)+' seconds')
    return uptop_code



