#coding:utf-8
######
# 首先：要知道RNN数据的输入格式:[n_samples,n_timesteps,n_features]
# **********************************************************
# 10-18     10-19     10-20     10-21 ......... 10-31      *      11-01
# feature1  feature1  feature1  feature1        feature1   *
# feature2  feature2  feature2  feature2        feature2   *====> label_pred   =??=label
# feature3  feature3  feature3  feature3        feature3   *
# feature4  feature4  feature4  feature4        feature4   *
# feature5  feature5  feature5  feature5        feature5   *
# label     label     label     label           label      *
# **********************************************************
#
# **********************************************************
# 10-19     10-21     10-22     10-23 ......... 11-01      *      11-02
# feature1  feature1  feature1  feature1        feature1   *
# feature2  feature2  feature2  feature2        feature2   *====> label_pred   =??=label
# feature3  feature3  feature3  feature3        feature3   *
# feature4  feature4  feature4  feature4        feature4   *
# feature5  feature5  feature5  feature5        feature5   *
# label     label     label     label           label_pred *
# **********************************************************
import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow.contrib import rnn
from sqlalchemy import create_engine
import random


engine_global=create_engine('mysql://root:0@localhost/'+"tianchi_2017_03_v3")
# Parameters
learning_rate   = 0.001 
training_iters  = 100000
batch_size      = 28
display_step    = 400
# Network Parameters
n_input   = 11  # MNIST data input (img shape: 28*28)
n_steps   = 7   # timesteps
n_hidden  = 128 # hidden layer num of features
n_classes = 1   # MNIST total classes (0-9 digits)


def get_data_from_mysql(table_train,db='tianchi_2017_03_v3'):
    sql1='select * from '+table_train
    print('Load data...')
    engine=create_engine('mysql://root:0@localhost/'+db)
    df_train=pd.read_sql(sql1,engine)
    return df_train



def eval_of_results(labels,preds):
    print labels[0:10]
    print preds[0:10]
    print "\n\n"
    labels=np.array(labels).reshape(-1,)
    preds =np.array(preds).reshape(-1,)
    value=float(sum(abs((labels-preds)/(labels+preds)))*1.0/len(preds))
    return value





def get_batch_train_data(df_train,has_batched=0,batch_size=batch_size,n_steps=n_steps):
    ''' 
    return: two list:
        first is feature_data  [batch_size,n_steps,n_features]
        last is labels         [batch_size]
    '''
    if batch_size+n_steps>len(df_train):
        raise Exception('batch_size is too large ')
    df_train.set_index(pd.DatetimeIndex(df_train.pay_day),inplace=True)
    x_train=df_train.drop(['shop_id','pay_day'],axis=1)
    y_train=df_train['label']
    x=[];y=[];
    start=(has_batched*batch_size)%len(df_train)
    end  =(start+batch_size)%len(df_train)
    if start <end and end+n_steps<len(df_train) :
        ## start < end < len(df_train) 
        pass 
    else:
        ## example:    end=150%140=10,
        ##           start=126%140=126
        ## end < start < len(df_train)
        start=0;  end=start+batch_size;
    #print 'start,end: ',start,end
    for i in range(start,end):
        x0=x_train.values[i:i+n_steps].tolist()
        y0=y_train[i+n_steps]
        x.append(x0)
        y.append(y0)
    index_Li=range(len(x))
    random.shuffle(index_Li)
    x=[x[k] for k in index_Li]
    y=[y[k] for k in index_Li]
    return x,y
    



def get_test_data(test_table,n_steps=n_steps):
    ''' 
    return: two list:
        first is feature_data  [batch_size,n_steps,n_features]
        last is labels         [batch_size]
    '''
    df_test=get_data_from_mysql(test_table)
    if n_steps<len(df_test):
        df_test.set_index(pd.DatetimeIndex(df_test.pay_day),inplace=True)
        x_test=df_test.drop(['shop_id','pay_day'],axis=1)
        y_test=df_test['label']
        x=[];y=[];
        for i in range(len(df_test)-n_steps):
            x0=x_test.values[i:i+n_steps].tolist()
            y0=y_test[i+n_steps]
            x.append(x0)
            y.append(y0)
        return x,y
    else:
        raise Exception("please ensure n_steps<len(df_test)")
    




def RNN(x, weights, biases):
    # Prepare data shape to match `rnn` function requirements
    # Current data input shape: (batch_size, n_steps, n_input)
    # Required shape: 'n_steps' tensors list of shape (batch_size, n_input)
    # Permuting batch_size and n_steps
    x = tf.transpose(x, [1, 0, 2])
    # Reshaping to (n_steps*batch_size, n_input)
    x = tf.reshape(x, [-1, n_input])
    # Split to get a list of 'n_steps' tensors of shape (batch_size, n_input)
    x = tf.split(x, n_steps, 0)
    # Define a lstm cell with tensorflow
    lstm_cell = rnn.BasicLSTMCell(n_hidden, forget_bias=1.0)
    # Get lstm cell output
    outputs, states = rnn.static_rnn(lstm_cell, x, dtype=tf.float32)
    # Linear activation, using rnn inner loop last output
    return tf.matmul(outputs[-1], weights['out']) + biases['out']





def pred_the_test_data(sess,pred,x,test_data):
    '''
    args:
        sess:       tf.Session()
        pred:       predict op      use x placeholder
        x   :       x placeholder   [None,   n_steps,n_features]
        test_data:  test data       [n_samples,n_steps,n_features]
    return:
        y_ :  a list of predict value [n_samples]
    '''
    ## because the test_data label is unknown 
    y_=[]
    for i in range(len(test_data)):
        #print "\n\n\nbefore using y_ test_data[i]: ",test_data[i]
        #print 'len(y_):  ',len(y_)
        for j in range(1,len(y_)+1):
            test_data[i][-j][-1]=y_[-j]
    #print "\nafter using y_ test_data[i]: ",test_data[i]
        y_temp=float(sess.run(pred,feed_dict={x:[test_data[i]]}))
        y_.append(y_temp)
    return y_





def train_the_train_data(sess,x,y,df_train,cost,optimizer):
    '''
    args:
        sess        :       tf.Session()
        x           :       placeholder [None,n_steps,n_features]
        y           :       placeholder [None]
        df_train    :       train data  will be split to batch_x and batch_y
        cost        :       obj  funtion    use x and y two placeholder
        optimizer   :       backprop  op    minimize(cost)
    return:
       sess 
    '''
    step = 1
    while step * batch_size < training_iters:
        batch_x, batch_y = get_batch_train_data(df_train,has_batched=step-1)
        # Run optimization op (backprop)
        sess.run(optimizer, feed_dict={x: batch_x, y: batch_y})
        if step % display_step == 0:
            # Calculate batch loss
            loss = sess.run(cost, feed_dict={x: batch_x, y: batch_y})
            print("Iter " + str(step*batch_size) + ", Minibatch Loss= " + \
                  "{:.6f}".format(loss)) 
        step += 1
    print("Optimization Finished!")
    return sess





if __name__=='__main__':
    # tf Graph input
    x = tf.placeholder("float", [None, n_steps, n_input])
    # for mninst 28x28;表示28 steps ,每一步要考虑28个特征 
    #y = tf.placeholder("float", [None, n_classes])
    y = tf.placeholder("float", [None])
    # Define weights
    weights = {
        'out': tf.Variable(tf.random_normal([n_hidden, n_classes]))
    }
    biases = {
        'out': tf.Variable(tf.random_normal([n_classes]))
    }
    pred = RNN(x, weights, biases)
    # Define loss and optimizer
    cost=tf.reduce_mean(tf.abs(tf.subtract(y,pred)/tf.add(y,pred)))
    #optimizer=tf.train.GradientDescentOptimizer(learning_rate=learning_rate).minimize(cost)
    optimizer=tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost)
    # Initializing the variables
    init = tf.global_variables_initializer()
    # Launch the graph
    with tf.Session() as sess:
        sess.run(init)
        test_pred=[]
        test_cost=[]
        for i in range(1,10  ):
            print "this is shop_id= "+str(i)
            try:
                df_train       =get_data_from_mysql('gui_train_set_10_shop_id_'+str(i)+'_train')
                test_data,test_label =get_test_data('gui_train_set_10_shop_id_'+str(i)+'_valid')
            except:
                print " this shop_id table not exists "
                continue
            ## train
            sess=train_the_train_data(sess,x,y,df_train,cost,optimizer)
            ## predict
            y_=pred_the_test_data(sess,pred,x,test_data)
            test_loss=eval_of_results(test_label,y_)
            print "test loss:  ",test_loss
            test_pred.append(y_)
            test_cost.append(test_loss)
    test_loss_merge=0
    num_pred_total =0
    for i in range(len(test_cost)):
        num_pred_total+=len(test_pred[i])
        test_loss_merge+=test_cost[i]*len(test_pred[i])
    test_loss_merge=test_loss_merge/num_pred_total
    print "test_loss_merge:  ",test_loss_merge
