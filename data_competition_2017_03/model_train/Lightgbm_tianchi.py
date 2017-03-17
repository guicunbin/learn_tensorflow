##### coding: utf-8
import pandas as pd
import lightgbm as lgb
from sqlalchemy import create_engine
import copy
import numpy as np
import os
import time
from sklearn.ensemble import GradientBoostingRegressor
from sklearn import preprocessing
from sklearn.metrics import mean_absolute_error
from sklearn.externals import joblib
from sklearn.linear_model import LinearRegression
##### some train params 
need_load=False
is_use_weights=False  
IS_Regressor=False
engine_global=create_engine('mysql://root:0@localhost/'+"tianchi_2017_03_v3")
use_lgb=True
is_search=False
use_stack=False


def self_eval(preds,train_data):
    try:
        labels=train_data.get_label()
    except:
        labels=np.array(train_data["label"])
    #for i in range(len(preds)):
    #    if abs((abs(labels[i])-preds[i])/(abs(labels[i])+preds[i]))>0.70:
    #        print "label,pred:  ",labels[i],preds[i]
    value=sum(abs(labels-preds)/(labels+preds))*1.0/np.shape(preds)[0]
    return "error",value,False


def eval_of_results(labels,preds):
    print labels[0:10]
    print preds[0:10]
    labels=np.array(labels).reshape(-1,)
    preds =np.array(preds).reshape(-1,)
    value=float(sum(abs((labels-preds)/(labels+preds)))*1.0/len(preds))
    return value



def create_weights(df_train,use_column='label'):
    '''
    for binary classfier 
    labels= 0 and 1
    '''
    row_num=df_train.shape[0]
    weights=np.ones(shape=(row_num,),dtype=np.float)
    labels=np.array(df_train[use_column]) ##labels.shape=(row_num,)
    count_1=labels[labels==1].shape[0]
    count_0=labels[labels==0].shape[0]
    rate_0=1.0
    rate_1=count_1*1.0/count_0

    for i in range(row_num):
        if labels[i]==1:
            weights[i]=rate_1
    return weights


def change_to_category(df,columns_li):
    for col in columns_li:
        df[col]=df[col].astype("category")
    return df




def create_Dataset(df_train,df_valid,df_test,use_weights=is_use_weights,use_lgb=use_lgb):
    y_train = df_train['label']
    X_train = df_train.drop(['label','shop_id','pay_day'],axis=1)
    y_valid = df_valid['label']
    X_valid = df_valid.drop(['label','shop_id','pay_day'],axis=1)
    X_test  = df_test.drop(['shop_id','pay_day'],axis=1)
    #### define category 
    cate_columns=["city_name",
                  "cate_1_name",
                  "cate_2_name",
                  "weekday_0_to_6",
                  "weather_1",
                  "weather_2",
                  "weather_3"]
    X_train=change_to_category(X_train,cate_columns)
    X_valid=change_to_category(X_valid,cate_columns)
    X_test =change_to_category(X_test, cate_columns)
    ##################
    if use_weights:
        weights_train=create_weights(df_train,use_column='label')
        weights_valid=create_weights(df_valid,use_column='label')
    else:
        weights_train=None
        weights_valid=None
    user_valid=np.column_stack((np.mat(df_valid['shop_id']).T,np.mat(df_valid["pay_day"]).T))
    user_test =np.column_stack((np.mat(df_test['shop_id']).T,np.mat(df_test["pay_day"]).T))
    if not use_lgb:
        return X_train,  y_train, X_test,user_test,X_valid,y_valid,user_valid 
    else:
        lgb_train = lgb.Dataset(X_train, y_train,
                            weight=weights_train)
        lgb_eval = lgb.Dataset(X_valid, y_valid,weight=weights_valid, reference=lgb_train)
        return lgb_train,lgb_eval,X_train,y_train,X_test,user_test,X_valid,y_valid,user_valid 





def cmp_and_instead(prior_df,last_df,cmp_column='userid',just_append=True):
    if cmp_column==0:
        cmp_column='userid'
    if last_df.shape[1]!=prior_df.shape[1]:
        raise Exception('please check the df.shape')
    if just_append:
        result_df=prior_df.append(last_df)
    else:
        result_df=prior_df.append(last_df) 
        result_df=result_df.drop_duplicates(subset=cmp_column,keep='first') 
    return result_df





def get_train_and_test_from_mysql(table_train,table_test,create_shuffle=False,db='tianchi_2017_03_v3'):
    sql1='select * from '+table_train
    sql2='select * from '+table_test
    print('Load data...')
    engine=create_engine('mysql://root:0@localhost/'+db)
    if create_shuffle:
        df_train=pd.read_sql(sql1,engine).sample(frac=1)
        df_train.to_sql(table_train+'_shuffle',engine,chunksize=10000,index=False) 
    else:
        df_train=pd.read_sql(sql1,engine)
    df_test=pd.read_sql(sql2,engine)
    return df_train,df_test
    



def get_train_and_valid_and_test_from_mysql(table_train,table_valid,table_test,db='tianchi_2017_03_v3'):
    sql1='select * from '+table_train
    sql2='select * from '+table_valid
    sql3='select * from '+table_test
    print('Load data...')
    engine=create_engine('mysql://root:0@localhost/'+db)
    df_train=pd.read_sql(sql1,engine)
    df_valid=pd.read_sql(sql2,engine)
    df_test=pd.read_sql(sql3,engine)
    return df_train,df_valid,df_test



def rule_of_deal_results(df_0,df_train,label_name):
    for i in range(len(df_0.loc[:,label_name])):
        if df_0.loc[i,label_name]<0:
            j=df_0.loc[i,"shop_id"]
            #try:
            #    j_med=df_train[df_train["shop_id"].isin([j])]['label'].median()
            #except:
            j_med=df_0[df_0["shop_id"].isin([j])][label_name].median()
            df_0.loc[i,label_name]=j_med
    return df_0






def train_and_pred(df_train,df_valid,df_test,model_type,model_num,params,use_lgb=use_lgb,num_iterations=10000):
    ##### create dataset for gbdt
    if not use_lgb:
        X_train, y_train, X_test, user_test, X_valid,y_valid, user_valid  =create_Dataset(df_train,df_valid,df_test) 
    else:
        lgb_train,lgb_eval,X_train, y_train,X_test,user_test,X_valid, y_valid, user_valid  =create_Dataset(df_train,df_valid,df_test)
    ##### some  specify filename
    result_file='train_valid_result_'+str(model_num)+'.txt' 
    model_file ='model_'+str(model_num)+'.pkl'
    valid_csv  ='tianchi/valid_'+str(model_num)+'.csv'
    test_csv   ='tianchi/test_'+str(model_num)+'.csv'
    with open(result_file,'a') as fa:
        now_time=time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
        fa.writelines('\n\n\n'+str(now_time)+'\n')
        fa.writelines('learning_rate: '+str(params['learning_rate'])+'\n')
    ##### train
    print('Start training the model_num = '+str(model_num)+'...')
    if model_type=="gbdt":
        if use_lgb:
            #gbm=lgb.LGBMRegressor(**params)
            #gbm.fit(X_train,y_train)
            gbm=lgb.train(params=params,
                        train_set=lgb_train,
                        valid_sets=lgb_eval,
                        feval=self_eval,
                        num_boost_round=num_iterations,
                        early_stopping_rounds=2000)
        else:
            print "current params:   ",params
            gbm = GradientBoostingRegressor(**params)
            gbm.fit(X_train,y_train)
    elif model_type=="linear":
        #min_max_scaler = preprocessing.MinMaxScaler()
        #X_train= min_max_scaler.fit_transform(X_train)
        #X_test = min_max_scaler.transform(X_test)
        #X_valid= min_max_scaler.transform(X_valid)
        gbm= LinearRegression(normalize=True)
        gbm.fit(X_train,y_train)
    else:
        pass
    ##### save model to file
    print ("save model ...")
    joblib.dump(gbm,model_file)
    ##### predict
    print('Start predicting...')
    if use_lgb:
        y_pred_train=np.mat(gbm.predict(X_train,num_iteration=gbm.best_iteration)).T
        y_pred_valid=np.mat(gbm.predict(X_valid,num_iteration=gbm.best_iteration)).T
        y_pred_test =np.mat(gbm.predict(X_test ,num_iteration=gbm.best_iteration)).T
    else:
        y_pred_train=np.mat(gbm.predict(X_train)).T
        y_pred_valid=np.mat(gbm.predict(X_valid)).T
        y_pred_test =np.mat(gbm.predict(X_test )).T
    ##### combine to valid_df and test_df
    #y_pred_test =abs(y_pred_test)
    #y_pred_valid=abs(y_pred_valid)
    valid_df=pd.DataFrame(np.column_stack((user_valid,y_pred_valid,np.mat(y_valid).T)),columns=['shop_id','pay_day','label_valid','label'])
    test_df= pd.DataFrame(np.column_stack((user_test,y_pred_test)),columns=['shop_id','pay_day','label_test'])
    ###### add some rule to deal the valid_df and test_df 
    #valid_df=rule_of_deal_results(valid_df,df_train,"label_valid") 
    #test_df =rule_of_deal_results(test_df, df_train,"label_test" )
    ##### eval the valid_df 
    train_set_error=eval_of_results(y_train,y_pred_train)
    valid_set_error=eval_of_results(y_valid,y_pred_valid)
    ##### test_df and  valid_df  to csv and sql
    valid_df.to_csv(valid_csv,index=False)
    valid_df.to_sql("valid_results_"+str(model_num),engine_global,index=False,if_exists="replace",chunksize=10000)
    test_df.to_csv(test_csv,index=False) 
    test_df.to_sql("test_results_"+str(model_num),engine_global,index=False,if_exists="replace",chunksize=10000)
    ##### compute feature_importance
    if hasattr(gbm,"feature_importances_"):
        print("compute feature_importance ...")
        feature_importance=gbm.feature_importances_
        feature_names=list(X_train.columns.astype(str))
        sorted_idx = np.argsort(feature_importance)
    elif hasattr(gbm,"feature_importance"):
        print("compute feature_importance ...")
        ### "gain" is better than "split"
        feature_importance=gbm.feature_importance(importance_type="gain")
        feature_names=list(X_train.columns.astype(str))
        sorted_idx = np.argsort(feature_importance)
    else:
        pass
    ##### write feature_importance to txt
    with open('feature_name_importance.txt','a') as fa:
        fa.writelines('\n\n\n\n\n\n##################  new model ###################\n\n')
        now_time=time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
        params_str=[
                    "\nmax_depth    : "+str(params["max_depth"]),
                    "\nnum_leaves   : "+str(params["num_leaves"]),
                    "\nlearning_rate: "+str(params["learning_rate"])]
        if hasattr(gbm,"feature_importances_") or hasattr(gbm,"feature_importance"):
            print("write feature_importance ...")
            for i in sorted_idx:
                st=str(feature_names[i])+' : '+str(feature_importance[i])+'\n'
                fa.writelines(st)
        fa.writelines("\n\n")
        fa.writelines(str(now_time)+'\n\n')
        fa.writelines("\n\n####  train_set_error: "+str(train_set_error)+"\n")
        fa.writelines("####  valid_set_error: "+str(valid_set_error)+"\n")
        for pa in params_str:
            fa.writelines(pa)
    return train_set_error,valid_set_error,valid_df,test_df,gbm.best_iteration
   




def search_train_and_pred(df_train_0,df_valid_0,df_test_0,is_search=is_search,
        max_depth_min=15,max_depth_max=16,num_leaves_min=25,num_leaves_max=31):
    ######### search best params
    if is_search:
        min_error=0.1
        min_error_params=params_0.copy()
        for i in range(max_depth_min,max_depth_max):
            for j in range(num_leaves_min,num_leaves_max):
                params_0["max_depth"]=i
                params_0["num_leaves"]=j
                train_set_error,valid_set_error,valid_df,test_df,best_iteration=train_and_pred(df_train_0,
                                            df_valid_0,
                                             df_test_0,num_iterations=10000,model_type="gbdt",
                                           model_num=0,params=params_0)
                if valid_set_error < min_error and abs(train_set_error-valid_set_error)<500:
                    min_error=valid_set_error
                    min_error_params["max_depth"] =i
                    min_error_params["num_leaves"]=j
                print "min_error_params:  ",min_error_params
                print "min_error: ",min_error
        train_set_error,valid_set_error,valid_df,test_df,best_iteration=train_and_pred(df_train_0,
                                        df_valid_0,
                                         df_test_0,num_iterations=10000,model_type="gbdt",
                                       model_num=0,params=min_error_params)
        print "\n min_error:   ",valid_set_error
        ####### the following will change train_data to be large, but need use the best_iteration to avoid overfitting
        df_train_all,df_valid_0,df_test_0 = get_train_and_valid_and_test_from_mysql('gui_train_set_v8_2016_06_01_2016_10_31',
                                                                              'gui_train_set_v8_2016_10_25_2016_10_31',
                                                                              'gui_train_set_v8_2016_11_01_2016_11_14')
        train_set_error,valid_set_error,valid_df,test_df,best_iteration=train_and_pred(df_train_all,
                                        df_valid_0,
                                         df_test_0,num_iterations=best_iteration,model_type="gbdt",
                                       model_num=0,params=min_error_params)
    ###############################
    else:
        train_set_error,valid_set_error,valid_df,test_df,best_iteration=train_and_pred(df_train_0,
                                        df_valid_0,
                                         df_test_0,num_iterations=10000,model_type="gbdt",
                                       model_num=0,params=params_0)
        print "\n current_error:  ",valid_set_error
        df_train_all,df_valid_0,df_test_0 = get_train_and_valid_and_test_from_mysql('gui_train_set_v8_2016_06_01_2016_10_31',
                                                                              'gui_train_set_v8_2016_10_25_2016_10_31',
                                                                              'gui_train_set_v8_2016_11_01_2016_11_14')
        train_set_error,valid_set_error,valid_df,test_df,best_iteration=train_and_pred(df_train_all,
                                        df_valid_0,
                                         df_test_0,num_iterations=best_iteration,model_type="gbdt",
                                       model_num=0,params=params_0)






def weights_stack(df_train,df_valid,df_test,params_list,model_type_list=["gbdt","gbdt","gbdt"],weights_list=[0.4,0.3,0.3]):
    train_set_error,valid_set_error,valid_df,test_df,best_iteration=train_and_pred(df_train,df_valid,df_test,
                                                        num_iterations=10000,model_type=model_type_list[0],model_num=0,params=params_list[0])
    valid_df["label_valid"]=weights_list[0]*valid_df["label_valid"];
    test_df ["label_test"]  =weights_list[0]*test_df["label_test"];
    valid_set_error_li=[];
    valid_set_error_li.append(valid_set_error)
    for i in range(1,len(model_type_list)):
        train_set_error,valid_set_error,valid_df_i,test_df_i,best_iteration=train_and_pred(df_train,df_valid,df_test,
                                                        num_iterations=10000,model_type=model_type_list[i],model_num=i,params=params_list[i])
        valid_df["label_valid"]=valid_df["label_valid"]+weights_list[i]*valid_df_i['label_valid']
        test_df ["label_test"] =test_df ["label_test"] +weights_list[i]*test_df_i ['label_test']
        valid_set_error_li.append(valid_set_error_i)
    valid_df.to_sql("valid_results_0",engine_global,index=False,if_exists="replace",chunksize=10000)
    test_df.to_sql ("test_results_0", engine_global,index=False,if_exists="replace",chunksize=10000)
    valid_set_error=sum(abs((valid_df["label_valid"]-valid_df["label"])*1.0/(valid_df["label_valid"]+valid_df["label"])))/valid_df.shape[0]
    for i in range(len(weights_list)):
        print "valid_set_error_i:  ",valid_set_error_li[i]
    print " valid_set_error:   ",valid_set_error





if __name__=='__main__':
    ######### specify your configurations as a dict
    params_0 = {
        'task': 'train',
        'boosting_type': 'gbdt',
    #   'boosting_type': 'dart',
        'objective': 'regression_l1',
    #   'metric': {'l2', 'auc'},
    #   'metric': 'binary_logloss',
    #   'metric': 'fair'
    ########################
        'max_depth':4  ,     ## max_depth  : 1    2    3    4      5      6    ....           n
        'num_leaves':12  ,    ## num_leaves : 2   3-4  3-8  3-16   3-32   3-64  ....          3-2^n
        'num_trees':200 ,
        'learning_rate': 0.1,
    #########################
        'min_data_in_leaf':100,
        'drop_rate':0.1,
        'feature_fraction': 0.9,
        'bagging_fraction': 0.9,
        'bagging_freq': 5,
        'verbose': 0
    }
    params_1=params_0.copy()
    params_1['max_depth']=15
    params_1['num_leaves']=30
    params_2=params_0.copy()
    params_2['max_depth']=8
    params_2["num_leaves"]=8
    params_list=list((params_0,params_1,params_2))
    ######### load and  create your dataset
    df_train_0,df_valid_0,df_test_0 = get_train_and_valid_and_test_from_mysql('gui_train_set_10_1',
                                                                              'gui_train_set_10_2',
                                                                              'gui_test_set_10')
    ######### train_and_pred
    if use_stack:
        weights_stack(df_train_0,df_valid_0,df_test_0,params_list,["gbdt","gbdt","gbdt"],[0.30,0.37,0.33])
    else:
        search_train_and_pred(df_train_0,df_valid_0,df_test_0,is_search=is_search,
                            max_depth_min=4,max_depth_max=6,num_leaves_min=6,num_leaves_max=15)
