import time
import tushare as ts
from numpy  import * 
import pandas as pd

def range_to_01(datamat):
    for i in range(shape(datamat)[1]):
        range_value=max(datamat[:,i])-min(datamat[:,i])
        datamat[:,i]=datamat[:,i]*1.0/(range_value+1)  ### +1 can avoid the divide by zero 
    return datamat



def recall_rate(predictmat,labelmat):
    '''argument:two  matrix;  shape=(1,m)    one is the predict label ,the other is the true label  
       return : recall_rate   :  tp/(tp+fn)
    '''
    if shape(predictmat)[0]==shape(labelmat)[0] and shape(predictmat)[0]==1 and shape(predictmat)[1]>1 :
        tp_fn=shape(labelmat[labelmat==1])[1]
        m=shape(labelmat)[1]
        tp=0
        for i in range(m):
            if predictmat[0,i]==labelmat[0,i] and predictmat[0,i]==1:
                tp=tp+1
        try:
            recall_rate=tp*1.0/tp_fn
            return recall_rate
        except:
            return ' bad predicting '
    else:
        print "please check the shape=??==(1,m) "



def correct_rate(predictmat,labelmat):
    '''argument:two  matrix;  shape=(1,m)    one is the predict label ,the other is the true label  
       return : correct_rate   :  tp/(tp+fp)
    '''
    if shape(predictmat)[0]==shape(labelmat)[0] and shape(predictmat)[0]==1 and shape(predictmat)[1]>1 :
        tp_fp=shape(predictmat[predictmat==1])[1]
        m=shape(labelmat)[1]
        tp=0
        for i in range(m):
            if predictmat[0,i]==labelmat[0,i] and predictmat[0,i]==1:
                tp=tp+1
        try: 
            correct_rate=tp*1.0/tp_fp
            return correct_rate
        except:
            return ' bad predicting '
    else:
        print "please check the shape=??==(1,m) "




def AdaBoost_train_datacastle(iternum,numSteps,isselect=True):
    import numpy as np
    from sklearn.ensemble import AdaBoostClassifier
    import time
    from sklearn.tree import DecisionTreeClassifier
    start=time.clock()
    if isselect:
        traindata,trainlabel,testdata,testlabel,X_test,user_test_mat=select_feature()
    else:
        traindata,trainlabel,testdata,testlabel=get_has_61_features_data()
    bdt = AdaBoostClassifier(DecisionTreeClassifier(max_depth=1), n_estimators=iternum,learning_rate=numSteps)
    bdt=bdt.fit(array(traindata),array(trainlabel).ravel()) ### the label need the ravel()  to flattened array 
    predictlabel=bdt.predict(testdata)
    ####
    predict_test_proba=bdt.predict_proba(testdata)
    predict_test_label=bdt.predict(testdata)
    proba_mat=column_stack((mat(predict_test_proba)[:,1],testlabel))
    predict_trainlabel=bdt.predict(traindata)
    print 'type(predict_test_proba),shape(predict_test_proba) : ',type(predict_test_proba),shape(predict_test_proba)
    df_proba=pd.DataFrame(proba_mat,columns=['predict_proba1','real_label'])
    df_proba.to_csv('datacastle_test_ada.csv',index=False)
    ####
    predict_trainlabel=bdt.predict(traindata)
    print 'shape(mat(predictlabel)),shape(mat(testlabel)) ',shape(mat(predictlabel)),shape(mat(testlabel)) 
    print 'the correct rate of traindata: '+str(correct_rate(mat(predict_trainlabel),mat(trainlabel)))
    print 'the correct rate of testdata:  '+str(correct_rate(mat(predictlabel),mat(testlabel)))
    print 'the recall rate of traindata: '+str(recall_rate(mat(predict_trainlabel),mat(trainlabel)))
    print 'the recall rate of testdata:  '+str(recall_rate(mat(predictlabel),mat(testlabel)))
    end=time.clock()
    print('the running time :   '+str(end-start)+' seconds')



def Randomforest_train_datacastle(n_trees,Mdepth,msplit,isselect=True):
    import numpy as np
    from sklearn.ensemble import RandomForestClassifier 
    import time
    from sklearn.tree import DecisionTreeClassifier
    start=time.clock()
    if isselect:
        traindata,trainlabel,testdata,testlabel,x_test,user_test_mat=select_feature()
    else:
        traindata,trainlabel,testdata,testlabel=get_has_61_features_data()
    print " traindata,trainlabel,testdata,testlabel :---type---\n",type(traindata),type(trainlabel),type(testdata),type(testlabel)
    print " traindata,trainlabel,testdata,testlabel :---shape---\n",shape(traindata),shape(trainlabel),shape(testdata),shape(testlabel)
    forest =RandomForestClassifier(n_estimators=n_trees,max_depth=Mdepth,min_samples_split=msplit,verbose=1)
    forest=forest.fit(array(traindata),array(trainlabel).ravel()) ### the label need the ravel()  to flattened array 
    predictlabel=forest.predict(testdata)
    predict_trainlabel=forest.predict(traindata)
    print 'type(predictlabel) ',type(predictlabel) 
    print 'shape(mat(predictlabel)),shape(mat(testlabel)) ',shape(mat(predictlabel)),shape(mat(testlabel)) 
    print 'the correct rate of traindata: '+str(correct_rate(mat(predict_trainlabel),mat(trainlabel)))
    print 'the correct rate of testdata:  '+str(correct_rate(mat(predictlabel),mat(testlabel)))
    print 'the recall rate of traindata: '+str(recall_rate(mat(predict_trainlabel),mat(trainlabel)))
    print 'the recall rate of testdata:  '+str(recall_rate(mat(predictlabel),mat(testlabel)))
    end=time.clock()
    print('the running time :   '+str(end-start)+' seconds')



def get_1_1_data():
    from sqlalchemy import  create_engine
    import pandas as pd
    import random
    engine=create_engine('mysql://root:0@localhost/datacastle')
    mat_data=mat(pd.read_sql('select * from data_80000',engine))
    list_data=mat_data.tolist()
    random.shuffle(list_data)
    #this func has no return 
    mat_data=mat(list_data)
    datamat=delete(mat_data,[0,1],1)
#    for i in range(shape(datamat)[0]):
#        if datamat[i,-1]==0:
#            datamat[i,-1]=-1
    traindata=range_to_01(datamat[:60000,:-1])
    trainlabel=datamat[:60000,-1]
    testdata=range_to_01(datamat[60000:,:-1])
    testlabel=datamat[60000:,-1]
    ####mat to list######
    traindata=traindata.tolist()
    testdata=testdata.tolist()
    trainlabel=array(trainlabel).reshape(-1,).tolist()
    testlabel=array(testlabel).reshape(-1,).tolist()
    return traindata,trainlabel,testdata,testlabel



def get_has_61_features_data():
    from sqlalchemy import create_engine 
    import pandas as pd
    import random
    engine=create_engine('mysql://root:0@localhost/datacastle')
    train_data=mat(pd.read_sql('select * from data_train_7_1_has_user_35000',engine))
    test_data= mat(pd.read_sql('select * from data_train_7_1_has_user_10000',engine))
    ######shuffle############
    test_data_list =test_data.tolist()
    train_data_list=train_data.tolist()
    random.shuffle(test_data_list)
    random.shuffle(train_data_list)
    test_data_mat= mat(test_data_list)
    train_data_mat=mat(train_data_list)
    ######shuffle############
    traindata=train_data_mat[:,2:-1]
    testdata= test_data_mat[:,2:-1]
    trainlabel=train_data_mat[:,-1]
    testlabel=test_data_mat[:,-1]
    ####mat to list######
    traindata=traindata.tolist()
    testdata=testdata.tolist()
    trainlabel=array(trainlabel).reshape(-1,).tolist()
    testlabel=array(testlabel).reshape(-1,).tolist()
    return traindata,trainlabel,testdata,testlabel



def get_has_6_features_traindata():
    from sqlalchemy import create_engine 
    import pandas as pd
    import random
    engine=create_engine('mysql://root:0@localhost/datacastle')
    real_train_data=mat(pd.read_sql('select * from data_has_24_features_60000',engine))
    ##shuffle
    real_train_data_list=real_train_data.tolist()
    random.shuffle(real_train_data_list)
    real_train_data_mat=mat(real_train_data_list)
    ##shuffle
    traindata=real_train_data_mat[:,1:-1]
    trainlabel=real_train_data_mat[:,-1]
    ####################### 
    #####get test data##
    real_test_data=mat(pd.read_sql('select * from data_has_24_features_10000',engine))
    ##shuffle
    real_test_data_list=real_test_data.tolist()
    random.shuffle(real_test_data_list)
    real_test_data_mat=mat(real_test_data_list)
    testdata=real_test_data_mat[:,1:-1]
    ##shuffle
    testlabel=real_test_data_mat[:,-1]
    ####mat to list######
    traindata=traindata.tolist()
    testdata=testdata.tolist()
    trainlabel=array(trainlabel).reshape(-1,).tolist()
    testlabel=array(testlabel).reshape(-1,).tolist()
    return traindata,trainlabel,testdata,testlabel





def get_has_realtest_12000():
    from sqlalchemy import  create_engine
    import pandas as pd
    import random
    engine=create_engine('mysql://root:0@localhost/datacastle')
    mat_data=mat(pd.read_sql('select * from data_test_12000',engine))
    list_data=mat_data.tolist()
    random.shuffle(list_data)
    #this func has no return 
    mat_data=mat(list_data)
    user_id_list=array(mat_data[:,0]).reshape(-1,).tolist()
    user_id_list=[int(id) for id in user_id_list]
    user_id_mat=mat(user_id_list).T
    datamat=mat_data[:,1:]
    testdata=datamat.tolist()
    return testdata,user_id_mat



def get_has_realtest_2000():
    from sqlalchemy import  create_engine
    import pandas as pd
    import random
    engine=create_engine('mysql://root:0@localhost/datacastle')
    test_data=mat(pd.read_sql('select * from data_test_2000_6',engine))
    train_data=mat(pd.read_sql('select * from data_unique80000_6',engine)) 
    test_data_list=test_data.tolist()
    train_data_list=train_data.tolist()
    random.shuffle(train_data_list)
    random.shuffle(test_data_list)
    train_data=mat(train_data_list)
    #####
    user_test_mat=mat(test_data_list)[:,0]
    test_data=mat(test_data_list)[:,1:].tolist()
    traindata=train_data[:,2:-1].tolist()
    trainlabel=array(train_data[:,-1]).reshape(-1,).tolist()
    return traindata,trainlabel,test_data,user_test_mat



def GBDT_test_2000_datacastle(iternum,numSteps,Mdepth,min_split=10):
    from sklearn.ensemble import GradientBoostingClassifier
    import time
    import pandas as pd
    start=time.clock()
    x1,y1,x_test,user_test_mat=get_has_realtest_2000()
    print 'shape(x1),shape(y1),shape(x_test):  ',shape(x1),shape(y1),shape(x_test)
    traindata=x1;  trainlabel=y1
    testdata=x_test
    print "shape(traindata),shape(trainlabel) : ",shape(traindata), shape(trainlabel)
    print "shape(testdata) : ",shape(testdata) 
    GBDT = GradientBoostingClassifier(n_estimators=iternum,learning_rate=numSteps,max_depth=Mdepth,min_samples_split=min_split,verbose=1)
    GBDT=GBDT.fit(array(traindata),array(trainlabel)) ### the label need the ravel()  to flattened array 
    ############
    predict_test_proba=GBDT.predict_proba(testdata)
    predict_test_label=GBDT.predict(testdata)
    proba_mat=column_stack((user_test_mat,mat(predict_test_proba)[:,1]))
    predict_trainlabel=GBDT.predict(traindata)
    print 'type(predict_test_proba),shape(predict_test_proba) : ',type(predict_test_proba),shape(predict_test_proba)
    df_proba=pd.DataFrame(proba_mat,columns=['userid','probability'])
    df_proba.to_csv('datacastle_test_2000.csv',index=False)
   #######################################
    predict_trainlabel=GBDT.predict(traindata)
    cor_train=correct_rate(mat(predict_trainlabel),mat(trainlabel))
    rec_train=recall_rate(mat(predict_trainlabel),mat(trainlabel))
    print 'shape(mat(predict_trainlabel)),shape(mat(trainlabel)) ',shape(mat(predict_trainlabel)),shape(mat(trainlabel)) 
    print 'the correct_rate of traindata: '+str(cor_train)
    print 'the recall rate of traindata : '+str(rec_train)
    end=time.clock()
    print('the running time :   '+str(end-start)+' seconds')



def split_data(isselect):
    import random
    if isselect:
        x1,y1,x2,y2,x_test,user_test_mat=select_feature()
    else:
        x1,y1,x2,y2=get_has_6_features_traindata()
    ###shuffle the list again#####
    x_mat=vstack((mat(x1),mat(x2))) 
    y_mat=vstack((mat(y1).T,mat(y2).T))
    xy_mat=column_stack((x_mat,y_mat))
    xy_list=xy_mat.tolist()
    random.shuffle(xy_list)
    #########################
    xy=mat(xy_list)
    list_x=xy[:,:-1].tolist()
    list_y=array(xy[:,-1]).reshape(-1,).tolist()
    num=len(list_x)
    x1=list_x[:int(0.25*num)];     y1=list_y[:int(0.25*num)]
    x2=list_x[int(0.25*num):int(0.5*num)];y2=list_y[int(0.25*num):int(0.5*num)]
    x3=list_x[int(0.5*num):int(0.75*num)];y3=list_y[int(0.5*num):int(0.75*num)]
    x4=list_x[int(0.75*num):];     y4=list_y[int(0.75*num):]
    x=[x1,x2,x3,x4]
    y=[y1,y2,y3,y4]
    return x,y








def select_feature(get_from=1):
    from sklearn.feature_selection import SelectFromModel
    from sklearn.ensemble import ExtraTreesClassifier
    from sklearn.ensemble import RandomForestClassifier
    clf=ExtraTreesClassifier()
    #####
    if get_from==1:
        x1,y1,x2,y2=get_has_61_features_data()
    else:
        x1,y1,x2,y2=get_has_6_features_traindata()
    ####
    x_test,user_test_mat=get_has_realtest_12000()
    print 'shape(x_test)',shape(x_test) 
    print"shape(x1),shape(y1),shape(x2),shape(y2) ",shape(x1),shape(y1),shape(x2),shape(y2)
    clf=clf.fit(array(x1),array(y1))   ###.fit()  need y.shape==(n_samples,) ****  x.shape()==(n_samples,m_features)
    model=SelectFromModel(clf,threshold=0.01,prefit=True)
    x1_new=model.transform(x1)
    x2_new=model.transform(x2)
    x_test_new=model.transform(x_test)
    print"shape(x1_new),shape(y1),shape(x2_new),shape(y2) ",shape(x1_new),shape(y1),shape(x2_new),shape(y2)
    print"x1_new[0] : ",x1_new[0]
    return x1_new,y1,x2_new,y2,x_test_new,user_test_mat
    


    
def GBDT_test_12000_datacastle(iternum,numSteps,Mdepth,min_split=10,isselect=True):
    from sklearn.ensemble import GradientBoostingClassifier
    import time
    import pandas as pd
    start=time.clock()
    if isselect:
        x1,y1,x2,y2,x_test,user_test_mat=select_feature()
    else:
        x1,y1,x2,y2=get_has_61_features_data()
        x_test,user_test_mat=get_has_realtest_12000()
    print 'shape(x1),shape(y1),shape(x2),shape(y2),shape(x_test):  ',shape(x1),shape(y1),shape(x2),shape(y2),shape(x_test)
    try:
        x1=x1.tolist();x2=x2.tolist()
    except:
        x1=x1;x2=x2
    x1.extend(x2); y1.extend(y2)
    traindata=x1;  trainlabel=y1
    testdata=x_test
    print "shape(traindata),shape(trainlabel) : ",shape(traindata), shape(trainlabel)
    print "shape(testdata) : ",shape(testdata) 
    GBDT = GradientBoostingClassifier(n_estimators=iternum,learning_rate=numSteps,max_depth=Mdepth,min_samples_split=min_split,verbose=1)
    GBDT=GBDT.fit(array(traindata),array(trainlabel)) ### the label need the ravel()  to flattened array 
    ############
    predict_test_proba=GBDT.predict_proba(testdata)
    predict_test_label=GBDT.predict(testdata)
    proba_mat=column_stack((user_test_mat,mat(predict_test_proba)[:,1]))
    predict_trainlabel=GBDT.predict(traindata)
    print 'type(predict_test_proba),shape(predict_test_proba) : ',type(predict_test_proba),shape(predict_test_proba)
    df_proba=pd.DataFrame(proba_mat,columns=['userid','probability'])
    df_proba.to_csv('datacastle_test.csv',index=False)
   #######################################
    predict_trainlabel=GBDT.predict(traindata)
    cor_train=correct_rate(mat(predict_trainlabel),mat(trainlabel))
    rec_train=recall_rate(mat(predict_trainlabel),mat(trainlabel))
    print 'shape(mat(predict_trainlabel)),shape(mat(trainlabel)) ',shape(mat(predict_trainlabel)),shape(mat(trainlabel)) 
    print 'the correct_rate of traindata: '+str(cor_train)
    print 'the recall rate of traindata : '+str(rec_train)
    end=time.clock()
    print('the running time :   '+str(end-start)+' seconds')






def GBDT_train_datacastle(iternum,numSteps,Mdepth,min_split=10,isselect=True,get_from=1):
    from sklearn.ensemble import GradientBoostingClassifier
    import time
    start=time.clock()
    if isselect:
        traindata,trainlabel,testdata,testlabel,X_test,user_test_mat=select_feature(get_from)
    else:
        traindata,trainlabel,testdata,testlabel,X_test,user_test_mat=select_feature(get_from)
    print "shape(traindata) : ",shape(traindata) 
    print "shape(testdata) : ",shape(testdata) 
    GBDT = GradientBoostingClassifier(n_estimators=iternum,learning_rate=numSteps,max_depth=Mdepth,min_samples_split=min_split,verbose=1)
    GBDT=GBDT.fit(array(traindata),array(trainlabel)) ### the label need the ravel()  to flattened array 
    predictlabel=GBDT.predict(testdata)
    predict_trainlabel=GBDT.predict(traindata)
    #######
    predict_test_proba=GBDT.predict_proba(testdata)
    predict_test_label=GBDT.predict(testdata)
    proba_mat=column_stack((mat(predict_test_proba)[:,1],testlabel))
    predict_trainlabel=GBDT.predict(traindata)
    print 'type(predict_test_proba),shape(predict_test_proba) : ',type(predict_test_proba),shape(predict_test_proba)
    df_proba=pd.DataFrame(proba_mat,columns=['predict_proba1','real_label'])
    df_proba.to_csv('datacastle_train'+str(get_from)+'.csv',index=False)
    #############
    cor_test=correct_rate(mat(predictlabel),mat(testlabel))
    cor_train=correct_rate(mat(predict_trainlabel),mat(trainlabel))
    rec_test=recall_rate(mat(predictlabel),mat(testlabel))
    rec_train=recall_rate(mat(predict_trainlabel),mat(trainlabel))
    print 'shape(mat(predictlabel)),shape(mat(testlabel)) ',shape(mat(predictlabel)),shape(mat(testlabel)) 
    print 'the correct rate of traindata: '+str(cor_train)
    print 'the correct rate of testdata:  '+str(cor_test)
    print 'the recall rate of traindata: '+str(rec_train)
    print 'the recall rate of testdata:  '+str(rec_test)
    end=time.clock()
    print('the running time :   '+str(end-start)+' seconds')



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
        data0=ts.get_hist_data(gupiaolist[i])     ## the new day'data need to get from net  instead of sql
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


def select(tablename='data_45000'):
    from sklearn.ensemble import ExtraTreesClassifier
    from sklearn.feature_selection import SelectFromModel
    from sqlalchemy import create_engine
    import pandas as pd
    engine=create_engine('mysql://root:0@localhost/datacastle')
    sql='select * from '+tablename
    df=pd.read_sql(sql,engine)
    column_name=array(df.columns,dtype=str).tolist()
    clf=ExtraTreesClassifier()
    xy=mat(df)
    xy_1=array(xy[1]).reshape(-1,).tolist()
    x1=xy[:,2:-1].tolist()
    y1=array(xy[:,-1]).reshape(-1,).tolist()
    #####
    clf=clf.fit(x1,y1)   ###.fit()  need y.shape==(n_samples,) ****  x.shape()==(n_samples,m_features)
    model=SelectFromModel(clf,threshold=0.02,prefit=True)
    x1_new=model.transform(x1)
    x1_new_1=array(x1_new[1]).reshape(-1,).tolist()
    new_cols=[]
    for ele in x1_new_1:
        index=xy_1.index(ele)
        new_cols.append(column_name[index])
    print "shape(x1) ",shape(x1)
    print"shape(x1_new)  ",shape(x1_new)
    print"x1_new[0] : ",x1_new[0]
    return new_cols 
    



