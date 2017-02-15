#coding:utf-8

from numpy import *
import time
from  svmutil  import *
from MySQLdb import *
import pandas
import tushare as ts

def loadSimpData():
    datMat = matrix([[ 1. ,  2.1],
        [ 2. ,  1.1],
        [ 1.3,  1. ],
        [ 1. ,  1. ],
        [ 2. ,  1. ]])
    classLabels = [1.0, 1.0, -1.0, -1.0, 1.0]
    return datMat,classLabels




def loadDataSet(fileName):                                  
    #general function to parse tab -delimited floats
    numFeat = len(open(fileName).readline().split('\t'))    
    #get number of fields 
    dataMat = []; labelMat = []
    fr = open(fileName)
    for line in fr.readlines():
        lineArr =[]
        curLine = line.strip().split('\t')
        for i in range(numFeat-1):
            lineArr.append(float(curLine[i]))
        dataMat.append(lineArr)
        labelMat.append(float(curLine[-1]))
    return dataMat,labelMat




def stumpClassify(dataMatrix,dimen,threshVal,threshIneq):
    #just classify the data
    ''' the only one layer of decision tree'''
    retArray = ones((shape(dataMatrix)[0],1))
    if threshIneq == 'lt':
        retArray[dataMatrix[:,dimen] <= threshVal] = -1.0
    else:
        retArray[dataMatrix[:,dimen] > threshVal] = -1.0
    return retArray
    



def buildStump(dataArr,classLabels,D,numSteps):
    dataMatrix = mat(dataArr); labelMat = mat(classLabels).T
    m,n = shape(dataMatrix)
    bestStump = {}; bestClasEst = mat(zeros((m,1)))
    minError = inf                              
    #init error sum, to +infinity
    for i in range(n):                          
        #loop over all dimensions (the number of features is the same as th number of dimensions)
        rangeMin = dataMatrix[:,i].min(); rangeMax = dataMatrix[:,i].max();  
        #get the max and min of this column
        stepSize = (rangeMax-rangeMin)/numSteps     
        #the stepsize
        for j in range(-1,int(numSteps)+1):         
            #loop over all range in current dimension
            for inequal in ['lt', 'gt']:            
                #go over less than and greater than
                threshVal = (rangeMin + float(j) * stepSize)
                predictedVals = stumpClassify(dataMatrix,i,threshVal,inequal)
                #call stump classify with i, j, lessThan
                errArr = mat(ones((m,1)))
                errArr[predictedVals == labelMat.T] = 0 
                #errArr[ the index of correct predicting]=0
                weightedError =mat(D).T*mat(errArr)     
                #calc total error multiplied by D # the result will be a value instead of matrix
                if weightedError < minError:
                    minError = weightedError
                    bestClasEst = predictedVals.copy()
                    bestStump['dim'] = i
                    bestStump['thresh'] = threshVal
                    bestStump['ineq'] = inequal
    return bestStump,minError,mat(bestClasEst)          
    #bestClaEst is a predict label of only one decision tree




def adaBoostTrainDS(dataArr,classLabels,numIt=40,numSteps=2):
    '''this function is the main() of trainning
       dataArr: need array 
       classLabels :need list or array 
       return 
              weakClassArr :the  list of dicts of decision tree 
                aggClassEst :the predict result which is step by step to close to the true'''
    weakClassArr = []
    m = shape(dataArr)[0]
    D = mat(ones((m,1))/m)   
    #init D to all equal ,D is the weight of  samples not features
    aggClassEst = mat(zeros((m,1)))
    for i in range(numIt):
        print 'go in iter :--- '+str(i)
        bestStump,error,classEst = buildStump(dataArr,classLabels,D,numSteps)
        alpha = float(0.5*log((1.001-error)/max(error,1e-16)))
        #calc alpha, throw in max(error,eps) to account for error=0
        bestStump['alpha'] = alpha 
        # if the error==1, the alpha wil be nan
        weakClassArr.append(bestStump)                  
        #store Stump Params in Array
        expon =multiply(mat(-1*alpha*mat(classLabels)),mat(classEst)) 
        #exponent for D calc, getting messy 
        D =multiply(mat(D),mat(exp(expon)))  
        #here need multiply instead of dot  #Calc New D for next iteration
        D = D/D.sum()
        #calc training error of all classifiers, if this is 0 quit for loop early (use break)
        aggClassEst += alpha*mat(classEst)
        ####the following is the calculate the errorrate if the errorrate=0.0 then stop the iteration #######
        agg= mat(sign(aggClassEst))
        print ' shape(agg),shape(classLabels) ', shape(agg),shape(classLabels)
        print ' agg[:10],classLabels[:10] ', agg[:10],classLabels[:10]
        correctrate=correct_rate(agg,classLabels)
        print 'the '+str(i)+ " correct_rate:  ",correctrate
        if correctrate == 1.0: break
    return weakClassArr,sign(aggClassEst)
    # weakClassArr:the list of the dicts of decision tree     
    # aggClassEst:the list of each samples of the predict result which is step by step to close to the true  






def adaClassify(datToClass,classifierArr):
    '''arguments:
            datToClass:the list or array of data which is need to predict 
            classifierArr: list or array of dicts of decision tree 
       return:
            aggClassEst:the predict list of label which is 1 or -1;
       '''
    dataMatrix = mat(datToClass)#do stuff similar to last aggClassEst in adaBoostTrainDS
    m = shape(dataMatrix)[0]
    aggClassEst = mat(zeros((m,1)))
    print 'len(classifierArr), :　',len(classifierArr),'\n' 
    for i in range(len(classifierArr)):
    #print 'classifierArr[i]：　 ', classifierArr[i]
        classEst = stumpClassify(dataMatrix,classifierArr[i]['dim'],\
                                 classifierArr[i]['thresh'],\
                                 classifierArr[i]['ineq'])#call stump classify
        aggClassEst += classifierArr[i]['alpha']*mat(classEst) #this is addition predicting of  each decision tree 
    return sign(aggClassEst)





def recall_rate(predictmat,labelmat,classlabel=1):  #compute the recall rate of classlabel which may be 0,1,2
    '''argument:two  matrix;  np.shape=(1,m)    one is the predict label ,the other is the true label  
       return : recall_rate   :  tp/(tp+fn)
    '''
    if np.shape(predictmat)[0]==np.shape(labelmat)[0] and np.shape(predictmat)[0]==1 and np.shape(predictmat)[1]>=1 :
        tp_fn=np.shape(labelmat[labelmat==classlabel])[1]
        m=np.shape(labelmat)[1]
        tp=0
        for i in range(m):
            if predictmat[0,i]==labelmat[0,i] and predictmat[0,i]==classlabel:
                tp=tp+1
        try:
            recall_rate=tp*1.0/tp_fn
            return recall_rate
        except:
            return 0.0 #tp=tp_fn=0
    else:
        print "please check the np.shape=??==(1,m) "






def correct_rate(predictmat,labelmat,classlabel=1):  #compute the correct rate of classlabel which may be 0,1,2
    '''argument:two  matrix;  np.shape=(1,m)    one is the predict label ,the other is the true label  
       return : correct_rate   :  tp/(tp+fp)
    '''
    if np.shape(predictmat)[0]==np.shape(labelmat)[0] and np.shape(predictmat)[0]==1 and np.shape(predictmat)[1]>=1 :
        tp_fp=np.shape(predictmat[predictmat==classlabel])[1]
        m=np.shape(labelmat)[1]
        tp=0
        for i in range(m):
            if predictmat[0,i]==labelmat[0,i] and predictmat[0,i]==classlabel:
                tp=tp+1
        try: 
            correct_rate=tp*1.0/tp_fp
            return correct_rate
        except:
            return 0.0 #tp=tp_fp=0
    else:
        print "please check the np.shape=??==(1,m) "




####################################     the following is the gupiao predict        #########################################




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
        while (j in uptop_index) or (j in del_index): 
            # need two condition to ensure the del_index don't have the same element 
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
    '''
    arg:
        gupiaolist:   a stock list to merge larger traindata
        numtraindata: the max number of the traindata
        numtestdata:  the max number of the testdata 
        fromSQL:      is or not from mysql
    return:
        4 list
        traindata1,trainlabel1,testdata1,testlabel1
    '''
    from sqlalchemy import create_engine
    import pandas as pd
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
        numtraindata=int(len(data)*0.9)
        numtestdata=len(data)-numtraindata
    ##### the list to shuffle #####
    print 'label[0:100]:  ',label[0:100]
    traindata1=data[0:numtraindata]
    trainlabel1=label[0:numtraindata]
    testdata1=data[numtraindata:numtestdata+numtraindata]
    testlabel1=label[numtraindata:numtestdata+numtraindata]
    return traindata1,trainlabel1,testdata1,testlabel1 





def stock_data_2_sql():
    from sqlalchemy import create_engine
    import tushare as ts 
    import pandas as pd    
    gupiaolist=get_stock_code_list()
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




####### this func will be a little difference from the above  adaboost_train_test_gupiao()  #####


def adaboost_train_test_gupiao_fromSQL(num_gupiao=4000,iternum=100,numtraindata=1000000,numtestdata=100000,numSteps=40,fromSQL=True):
    '''
    return weakClassArr # the list of dicts of decision trees
    return uptop_code  #the list of code of up to top
    '''
    import tushare as ts
    import numpy as np
    start=time.clock()
    ####the follwing is to get gupiaolist
    gupiaolist_all=get_stock_code_list()
    index_list0=np.random.uniform(0,len(gupiaolist_all),(1,num_gupiao)).reshape(-1,).tolist()
    index_list=[int(ele) for ele in index_list0]
    gupiaolist=[gupiaolist_all[j] for j in index_list]
    ############################################ 
    traindata,trainlabel,testdata,testlabel=extend_share_data(gupiaolist,numtraindata,numtestdata,fromSQL)
    weakClassArr,aggClassEst=adaBoostTrainDS(mat(traindata),mat(trainlabel).T,iternum,numSteps)
    predictlabel=adaClassify(mat(testdata),weakClassArr)
    predict_trainlabel=adaClassify(mat(traindata),weakClassArr)
    print 'shape(predictlabel),shape(predict_trainlabel):   ',shape(predictlabel),shape(predict_trainlabel)
    newdata,newdata_code=new_share_data(gupiaolist)   # the gupiaolist's gupiao has some invaild 
    predict_newday=adaClassify(newdata,weakClassArr)
    uptop_code=[]
    for i in range(len(predict_newday)):
        if predict_newday[i]==1:
            print str(newdata_code[i])+' will up to top'
            uptop_code.append(newdata_code[i])
    uptop_code=list(set(uptop_code))
    print 'len(newdata),len(uptop_code) :  ',len(newdata),len(uptop_code)
    print 'len(traindata), len(testdata) ',len(traindata), len(testdata) 
    print 'the correct rate of traindata: '+str(correct_rate(mat(predict_trainlabel).T,mat(trainlabel).T))
    print 'the correct rate of testdata:  '+str(correct_rate(mat(predictlabel).T,mat(testlabel).T))
    print 'the recall rate of traindata: '+str(recall_rate(mat(predict_trainlabel).T,mat(trainlabel).T))
    print 'the recall rate of testdata:  '+str(recall_rate(mat(predictlabel).T,mat(testlabel).T))
    end=time.clock()
    print('the running time :   '+str(end-start)+' seconds')
    return weakClassArr,uptop_code


def range_to_01(datamat):
    for i in range(shape(datamat)[1]):
        range_value=max(datamat[:,i])-min(datamat[:,i])
        datamat[:,i]=datamat[:,i]*1.0/range_value
    return datamat



def adaBoost_train_datacastle(iternum,numSteps):
    from sqlalchemy import  create_engine
    import pandas as pd
    import random
    import numpy as np
    start=time.clock()
    engine=create_engine('mysql://root:0@localhost/datacastle')
    mat_data=mat(pd.read_sql('select * from data_80000',engine))
    list_data=mat_data.tolist()
    random.shuffle(list_data)    #this func has no return 
    mat_data=mat(list_data)
    datamat=np.delete(mat_data,[0,1],1)
    for i in range(shape(datamat)[0]):
        if datamat[i,-1]==0:
            datamat[i,-1]=-1
    traindata=range_to_01(datamat[:70000,:-1])
    trainlabel=datamat[:70000,-1]
    testdata=range_to_01(datamat[70000:,:-1])
    testlabel=datamat[70000:,-1]
    weakClassArr,aggClassEst=adaBoostTrainDS(mat(traindata),mat(trainlabel),iternum,numSteps)
    predictlabel=adaClassify(mat(testdata),weakClassArr)
    predict_trainlabel=adaClassify(mat(traindata),weakClassArr)
    print 'the correct rate of traindata: '+str(correct_rate(mat(predict_trainlabel).T,mat(trainlabel).T))
    print 'the correct rate of testdata:  '+str(correct_rate(mat(predictlabel).T,mat(testlabel).T))
    print 'the recall rate of traindata: '+str(recall_rate(mat(predict_trainlabel).T,mat(trainlabel).T))
    print 'the recall rate of testdata:  '+str(recall_rate(mat(predictlabel).T,mat(testlabel).T))
    end=time.clock()
    print('the running time :   '+str(end-start)+' seconds')



    

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
            
        



def sql2data(regular=1):
    con=connect(user='root',passwd='0',db='ccf')
    sql1='select * from train00'
    data=pandas.read_sql(sql1,con)
    dataArrli=array(data).tolist()
    random.shuffle(dataArrli)     #this funcation has no return 
    dataArr=array(dataArrli)
    datali=ndarray.tolist(dataArr[:,0:4])
    if regular==1:
        datamat=mat(datali)        
        for i in range(shape(datamat)[0]):
            dp=float(datamat[i]*datamat[i].T)**0.5
            datamat[i]=datamat[i]/dp
        datali=array(datamat).tolist()
    labelli=ndarray.tolist(dataArr[:,-1])
    print(len(datali))
    print(len(labelli))
    return datali,labelli




def adaBoostTrain_test_sqldata(numIt=40,numSteps=5,regular=1):
    start=time.clock()
    datali,labelli=sql2data(regular)
    data=mat(datali)
    label=mat(labelli).T
    traindata=data[:100000,:]
    trainlabel=label[:100000]
    print shape(trainlabel)
    testdata=data[100000:,:]
    testlabel=label[100000:]
    correct_rate_test=0.0
    correct_rate_train=0.0
    for i in range(5):
        weakClassArr,aggClassEst=adaBoostTrainDS(traindata,trainlabel,numIt,numSteps)
        predictlabel_of_test=adaClassify(testdata,weakClassArr)
        predictlabel_of_train=adaClassify(traindata,weakClassArr)
        correct_rate_train=correct_rate(mat(predictlabel_of_train).T,mat(trainlabel))+correct_rate_train
        correct_rate_test=correct_rate(mat(predictlabel_of_test).T,mat(testlabel))+correct_rate_test
    print 'the average accuacy of traindata :  '+str(correct_rate_train/5.0)
    print 'the average accuracy of testdata :  '+str(correct_rate_test/5.0)
    end =time.clock()
    print 'the running time is : '+str(end-start)+' seconds ' 



    

def change(datali,labelli): 
    '''
    change data and label to suitabel format of libsvm 
    argument: 
        datali: the list of data
        labelli: the list of label
    return :
        a list of data and label to suit the format of libsvm 
    '''
    li1=[]
    for i in range(len(datali)):
        li2=[]
        li2.append(str(labelli[i]))  #writelines need strings
        li2.append(' ')
        for j in range(len(datali[i])):
            li2.append(str(j+1))
            li2.append(':')
            li2.append(str(datali[i][j]))
            li2.append(' ')
        li2.append('\n')
        li1.append(li2)
    random.shuffle(li1)
    return li1






def gupiao_2_txt(num='000651',extendnum=10):
    traindata,trainlabel,testdata,testlabel=loadgupiao(num='000651',numtraindata=200,numtestdata=40)
    traindata=traindata
    trainlabel=array(trainlabel).reshape(-1,).tolist()
    testdata=testdata
    testlabel=array(testlabel).reshape(-1,).tolist()
    for i in range(extendnum):
        print 'add  iter : ' +str(i)
        traindata.extend(traindata)
        trainlabel.extend(trainlabel)
        print 'len(traindata):  ',len(traindata)
    li1=change(traindata,trainlabel)
    li2=change(testdata,testlabel)
    with open('train.txt','w') as f1:
        for i in range(len(li1)):
            f1.writelines(li1[i])
    with open('test.txt','w') as f2:
        for i in range(len(li2)):
            f2.writelines(li2[i])
    return 'train.txt','test.txt'


 

def sql2txt():
    datali,labelli=sql2data()
    li1=change(datali,labelli)
    with open('ccf_train000.txt','w') as fw:
        for i in range(len(li1)):
            fw.writelines(li1[i])
    return 'ccf_train000.txt'




def test_gupiao_libsvm(num='000651'):
    start=time.clock()
    file1,file2=gupiao_2_txt(num)
    y1,x1=svm_read_problem(file1)
    y2,x2=svm_read_problem(file2)
    model2=svm_train(y1,x1)
    pre,acc,vals=svm_predict(y2,x2,model2)
    print 'acc:   ', acc
    accuracy=acc[0]/100
    end=time.clock()
    print 'the predict accuracy is :  '+str(accuracy)
    print 'the running time is :   '+str(end-start)+' seconds ' 




def get_stock_code_list():
    '''
    return:
        a list of stock code 
    '''
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
   




def plotROC(predStrengths, classLabels):
    import matplotlib.pyplot as plt
    cur = (1.0,1.0) #cursor
    ySum = 0.0 #variable to calculate AUC
    numPosClas = sum(array(classLabels)==1.0)  ## the number of the positive samples
    yStep = 1/float(numPosClas); xStep = 1/float(len(classLabels)-numPosClas)#len(classlabels)-numPosclas : the number of negative samples
    sortedIndicies = predStrengths.argsort()#get sorted index, it's reverse
    fig = plt.figure()
    fig.clf()
    ax = plt.subplot(111)
    #loop through all the values, drawing a line segment at each point
    for index in sortedIndicies.tolist()[0]:
        if classLabels[index] == 1.0:
            delX = 0; delY = yStep;
        else:
            delX = xStep; delY = 0;
            ySum += cur[1]
        #draw line from cur to (cur[0]-delX,cur[1]-delY)
        ax.plot([cur[0],cur[0]-delX],[cur[1],cur[1]-delY], c='b')
        cur = (cur[0]-delX,cur[1]-delY)
    ax.plot([0,1],[0,1],'b--')
    plt.xlabel('False positive rate'); plt.ylabel('True positive rate')
    plt.title('ROC curve for AdaBoost horse colic detection system')
    ax.axis([0,1,0,1])
    plt.show()
    print "the Area Under the Curve is: ",ySum*xStep

