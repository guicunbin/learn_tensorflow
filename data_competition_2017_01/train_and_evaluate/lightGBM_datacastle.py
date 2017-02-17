##### coding: utf-8
import json
import lightgbm as lgb
import pandas as pd
from sqlalchemy import create_engine
import copy
import numpy as np
import os
import time
##### some train params 
need_load=False
read_data_from_sql_has_shuffle=True
is_use_weights=True  




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




def split_df_data(df_train_and_valid,split_rate=0.8):
    print('split train_data and valid_data')
    row_num=df_train_and_valid.shape[0]
    split_num=int(row_num*split_rate*1.0) 
    df_train=df_train_and_valid.iloc[:split_num,:]
    df_valid=df_train_and_valid.iloc[split_num:,:]
    return df_train,df_valid




def create_Dataset(df_train,df_valid,df_test,use_weights=is_use_weights):
    y_train = df_train['label']
    X_train = df_train.drop(['label','user_id'],axis=1)
    y_valid = df_valid['label']
    X_valid = df_valid.drop(['label','user_id'],axis=1)
    columns_li=list(X_train.columns.astype(str))
    if use_weights:
        weights_train=create_weights(df_train,use_column='label')
        weights_valid=create_weights(df_valid,use_column='label')
    else:
        weights_train=None
        weights_valid=None
    lgb_train = lgb.Dataset(X_train, y_train,
                            weight=weights_train,
                            feature_name=columns_li,
                            categorical_feature=['sex','job','education','marry','hukou'])
    lgb_eval = lgb.Dataset(X_valid, y_valid,weight=weights_valid, reference=lgb_train)
    user_valid=np.mat(df_valid['user_id']).T
    X_test   = df_test.drop('user_id',axis=1)
    user_test= np.mat(df_test['user_id']).T
    return lgb_train,lgb_eval,X_test,user_test,X_valid,y_valid,user_valid 




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
    ## the folowing is the slower efficent way
    #    columns_li=list(prior_df.columns.astype(str))
    #    prior_mat=np.mat(prior_df)
    #    last_mat =np.mat(last_df)
    #    row_num_of_last =np.shape(last_mat)[0]
    #    row_num_of_prior=np.shape(prior_mat)[0]
    #    for i in range(row_num_of_last):
    #        for j in range(row_num_of_prior):
    #            if last_mat[i,cmp_column]==prior_mat[j,cmp_column]:
    #                last_mat[i]=prior_mat[j]
    #    result_df=pd.DataFrame(last_mat,columns=columns_li)





def get_train_and_test_from_mysql(table_train,table_test,create_shuffle=False,db='datacastle1'):
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
        



def train_and_pred(df_train_and_valid,df_test,model_num,params):
    ##### create dataset for lightgbm
    df_train,df_valid    = split_df_data(df_train_and_valid)
    lgb_train,  lgb_eval,  X_test,  user_test,  X_valid,y_valid,  user_valid  =create_Dataset(df_train,df_valid,df_test) 
    ## some  specify filename
    result_file='train_valid_result_'+str(model_num)+'.txt' 
    model_file ='model_'+str(model_num)+'.txt'
    valid_csv  ='datacastle/valid_'+str(model_num)+'.csv'
    test_csv   ='datacastle/test_'+str(model_num)+'.csv'
    with open(result_file,'a') as fa:
        now_time=time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
        fa.writelines('\n\n\n'+str(now_time)+'\n')
        fa.writelines('learning_rate: '+str(params['learning_rate'])+'\n')
    ##### train
    print('Start training the model_num = '+str(model_num)+'...')
    if need_load==True:
        init_lgb = lgb.Booster(model_file=model_file) #####init model
    else:
        init_lgb=None
    gbm = lgb.train(params=params,
                    train_set=lgb_train,
                    init_model=init_lgb,
                    num_boost_round=80000 ,
                    #learning_rates=lambda iter: params['learning_rate'] * (0.999999** iter),
                    valid_sets=lgb_eval,
                    early_stopping_rounds=2000,
                    verbose_eval=1)
    ##### save model to file
    print('Save model...')
    gbm.save_model(model_file)
    ##### predict
    print('Start predicting...')
    y_pred_valid=np.mat(gbm.predict(X_valid,num_iteration=gbm.best_iteration)).T
    y_pred_test =np.mat(gbm.predict(X_test, num_iteration=gbm.best_iteration)).T
    ##### to csv 
    valid_df=pd.DataFrame(np.column_stack((user_valid,y_pred_valid,np.mat(y_valid).T)),columns=['userid','probability','label'])
    test_df= pd.DataFrame(np.column_stack((user_test,y_pred_test)),  columns=['userid','probability'])
    valid_df.to_csv(valid_csv,index=False)
    test_df.to_csv(test_csv,index=False)
    ###### dump model to json (and save to file)
    #print('Dump model to JSON...')
    #model_json = gbm.dump_model()
    #with open('model.json', 'w+') as f:
    #    json.dump(model_json, f, indent=4)
    ###### sort the importance_li
    name_li=gbm.feature_name()
    importance_li=list(gbm.feature_importance())
    old_importance_li=copy.deepcopy(importance_li)
    importance_li.sort(reverse=True)
    new_name_li=[]
    for i in range(len(name_li)):
        j=old_importance_li.index(importance_li[i])
        new_name_li.append(name_li[j])
    ##### write reault to train_valid_result.txt 
    with open(result_file,'a') as fa:
        fa.writelines(str(params)+'\n')
        fa.writelines('train:  '+str(gbm.eval_train())+'\n'+'valid:  '+str(gbm.eval_valid()))
    os.system('python result.py '+valid_csv+' >> '+result_file)
    ##### write feature_importance to txt
    print('Calculate feature importances...')
    with open('feature_name_importance.txt','a') as fa:
        fa.writelines('\n\n\n\n\n\n ##########  new model###############\n\n ')
        now_time=time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
        fa.writelines(str(now_time)+'\n')
        for i in range(len(name_li)):
            st=str(new_name_li[i])+' : '+str(importance_li[i])+'\n'
            fa.writelines(st)
    return valid_df,test_df





if __name__=='__main__':
    ##### specify your configurations as a dict
    params_0 = {
        'task': 'train',
        'boosting_type': 'gbdt',
    #   'boosting_type': 'dart',
        'objective': 'binary',
    #   'metric': {'l2', 'auc'},
    #   'metric': 'binary_logloss',
    #   'metric': 'fair'
        'metric': 'auc', 
        'drop_rate':0.1,
        'num_leaves': 10,
        'learning_rate': 0.01  ,
        'feature_fraction': 0.9,
        'bagging_fraction': 0.9,
        'bagging_freq': 5,
        'verbose': 1
    }
    ##### specify your configurations as a dict
    params_1 = {
        'task': 'train',
        'boosting_type': 'gbdt',
    #   'boosting_type': 'dart',
        'objective': 'binary',
    #   'metric': {'l2', 'auc'},
    #   'metric': 'binary_logloss',
    #   'metric': 'fair'
        'metric': 'auc', 
        'drop_rate':0.1,
        'num_leaves': 10,
        'learning_rate': 0.01  ,
        'feature_fraction': 0.9,
        'bagging_fraction': 0.9 ,
        'bagging_freq': 5,
        'verbose': 1
    }
    ##### specify your configurations as a dict
    params_2 = {
        'task': 'train',
        'boosting_type': 'gbdt',
    #   'boosting_type': 'dart',
        'objective': 'binary',
    #   'metric': {'l2', 'auc'},
    #   'metric': 'binary_logloss',
    #   'metric': 'fair'
        'metric': 'auc', 
        'drop_rate':0.1,
        'num_leaves': 10,
        'learning_rate': 0.01  ,
        'feature_fraction': 0.9,
        'bagging_fraction': 0.9,
        'bagging_freq': 5,
        'verbose': 1
    }
    ######### load and  create your dataset
    #df_train_and_valid,                df_test                =get_train_and_test_from_mysql('gui_train_has_shuffle',
    #                                                                                         'gui_test_set')
    #df_train_and_valid_not_have_bank,  df_test_not_have_bank  =get_train_and_test_from_mysql("gui_train_no_bank_has_shuffle",
    #                                                                                         'gui_test_set_not_have_bank_detail')
    #df_train_and_valid_inner_join_bank,df_test_inner_join_bank=get_train_and_test_from_mysql('gui_train_inner_bank_has_shuffle',
   
    df_train_and_valid_1,df_test_1 =get_train_and_test_from_mysql('dataset1_gui_train_set',
                                                                  'dataset1_gui_test_set')
    df_train_and_valid_2,df_test_2 =get_train_and_test_from_mysql("dataset2_gui_train_set",
                                                                  'dataset2_gui_test_set')
    df_train_and_valid_3,df_test_3 =get_train_and_test_from_mysql('dataset3_gui_train_set',
                                                                  'dataset3_gui_test_set')
    #######the following is the not worked 
    #df_train_and_valid_use_most_features,df_test_12000=get_train_and_test_from_mysql('gui_train_set_not_have_bank_detail_and_inner_join_all',
    #                                                                                 'gui_test_set_not_have_bank_detail_and_inner_join_all',
    #                                                                                  create_shuffle=False)
    #df_train_and_valid_use_few_features,df_test_2000  =get_train_and_test_from_mysql('gui_train_set_just_user_info_55000',
    #                                                                                 'gui_test_set_just_user_info_2000',
    #                                                                                  create_shuffle=False) 
    ########## train_and_pred
    valid_df_0,test_df_0=train_and_pred(df_train_and_valid_1,df_test_1,model_num=0,params=params_0)
    valid_df_1,test_df_1=train_and_pred(df_train_and_valid_2,df_test_2,model_num=1,params=params_1)
    valid_df_2,test_df_2=train_and_pred(df_train_and_valid_3,df_test_3,model_num=2,params=params_2) #the top prior 
    #valid_df_0,test_df_0=train_and_pred(df_train_and_valid_use_most_features,df_test_12000,model_num=0,params=params_0)
    #valid_df_1,test_df_1=train_and_pred(df_train_and_valid_use_few_features, df_test_2000, model_num=1,params=params_1)
    print('merge all df ...')
    #valid_df=cmp_and_instead(valid_df_0,valid_df_1,cmp_column='user_id',just_append=True)
    #test_df =cmp_and_instead(test_df_0, test_df_1, cmp_column='user_id',just_append=True)
    valid_df=cmp_and_instead(valid_df_2,cmp_and_instead(valid_df_1,valid_df_0,0,False),0,False)
    test_df =cmp_and_instead(test_df_2, cmp_and_instead(test_df_1, test_df_0, 0,False),0,False)
    valid_df.to_csv('datacastle/valid_merge.csv',index=False)
    test_df.to_csv('datacastle/test_merge.csv',index=False)
    with open('result_merge.txt','a') as fa:
        now_time=time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
        fa.writelines('\n\n\n'+str(now_time)+'\n')
    os.system('python result.py datacastle/valid_merge.csv >> result_merge.txt')



