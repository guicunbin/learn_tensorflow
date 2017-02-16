#coding:utf-8
import time
import sys
import numpy as np
from scipy.misc import imread,imresize 
import os
import tensorflow as tf
#from tensorflow.contrib.slim.python.slim.nets.inception_v3 import inception_v3,inception_v3_arg_scope
from tensorflow.python.ops import random_ops
slim=tf.contrib.slim

### ckpt 
checkpoint_exclude_scopes="InceptionResnetV2/Logits,InceptionResnetV2/AuxLogits"
#checkpoint_exclude_scopes=None    #表示直接从ckpt中回复
checkpoint_path="/home/gui/work2017/ckpt_data/inception_resnet_v2_ckpt/inception_resnet_v2_2016_08_30.ckpt"
is_train=True #this is the args of train 
batch_length=100    #this is the args of train 
batch_number=10
epoch_length=2    #this is the args of train 
#workpath=sys.path[0]
workpath    ='/home/gui/back20170125/python3'
start_jpg=workpath+'/start.jpg'
paths_test=[workpath+'/image/car/car_test/Images/',
           workpath+'/image/minibus/minibus_test/Images/',
           workpath+'/image/taxi/taxi_test/Images/' ]
paths_train=[workpath+'/image/car/car_train/Images/',
            workpath+'/image/minibus/minibus_train/Images/',
            workpath+'/image/taxi/taxi_train/Images/']
#trainable_scopes="InceptionResnetV2/Logits,InceptionResnetV2/AuxLogits"  # 先训练这几个层，其他的层保持ckpt的参数不变
trainable_scopes="all"  #表示训练所有层


##############################  inception_resnet_v2 ##################################

trunc_normal = lambda stddev: tf.truncated_normal_initializer(0.0, stddev)


def block35(net, scale=1.0, activation_fn=tf.nn.relu, scope=None, reuse=None):
  """Builds the 35x35 resnet block."""
  with tf.variable_scope(scope, 'Block35', [net], reuse=reuse):
    with tf.variable_scope('Branch_0'):
      tower_conv = slim.conv2d(net, 32, 1, scope='Conv2d_1x1',normalizer_fn=slim.batch_norm)
    with tf.variable_scope('Branch_1'):
      tower_conv1_0 = slim.conv2d(net, 32, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
      tower_conv1_1 = slim.conv2d(tower_conv1_0, 32, 3, scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
    with tf.variable_scope('Branch_2'):
      tower_conv2_0 = slim.conv2d(net, 32, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
      tower_conv2_1 = slim.conv2d(tower_conv2_0, 48, 3, scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
      tower_conv2_2 = slim.conv2d(tower_conv2_1, 64, 3, scope='Conv2d_0c_3x3',normalizer_fn=slim.batch_norm)
    mixed = tf.concat(axis=3, values=[tower_conv, tower_conv1_1, tower_conv2_2])
    up = slim.conv2d(mixed, net.get_shape()[3], 1, 
                     activation_fn=None, scope='Conv2d_1x1')
    net += scale * up
    if activation_fn:
      net = activation_fn(net)
  return net


def block17(net, scale=1.0, activation_fn=tf.nn.relu, scope=None, reuse=None):
  """Builds the 17x17 resnet block."""
  with tf.variable_scope(scope, 'Block17', [net], reuse=reuse):
    with tf.variable_scope('Branch_0'):
      tower_conv = slim.conv2d(net, 192, 1, scope='Conv2d_1x1',normalizer_fn=slim.batch_norm)
    with tf.variable_scope('Branch_1'):
      tower_conv1_0 = slim.conv2d(net, 128, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
      tower_conv1_1 = slim.conv2d(tower_conv1_0, 160, [1, 7],
                                  scope='Conv2d_0b_1x7',normalizer_fn=slim.batch_norm)
      tower_conv1_2 = slim.conv2d(tower_conv1_1, 192, [7, 1],
                                  scope='Conv2d_0c_7x1',normalizer_fn=slim.batch_norm)
    mixed = tf.concat(axis=3, values=[tower_conv, tower_conv1_2])
    up = slim.conv2d(mixed, net.get_shape()[3], 1, 
                     activation_fn=None, scope='Conv2d_1x1')
    net += scale * up
    if activation_fn:
      net = activation_fn(net)
  return net


def block8(net, scale=1.0, activation_fn=tf.nn.relu, scope=None, reuse=None):
  """Builds the 8x8 resnet block."""
  with tf.variable_scope(scope, 'Block8', [net], reuse=reuse):
    with tf.variable_scope('Branch_0'):
      tower_conv = slim.conv2d(net, 192, 1, scope='Conv2d_1x1',normalizer_fn=slim.batch_norm)
    with tf.variable_scope('Branch_1'):
      tower_conv1_0 = slim.conv2d(net, 192, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
      tower_conv1_1 = slim.conv2d(tower_conv1_0, 224, [1, 3],
                                  scope='Conv2d_0b_1x3',normalizer_fn=slim.batch_norm)
      tower_conv1_2 = slim.conv2d(tower_conv1_1, 256, [3, 1],
                                  scope='Conv2d_0c_3x1',normalizer_fn=slim.batch_norm)
    mixed = tf.concat(axis=3, values=[tower_conv, tower_conv1_2])
    up = slim.conv2d(mixed, net.get_shape()[3], 1, 
                     activation_fn=None, scope='Conv2d_1x1')
    net += scale * up
    if activation_fn:
      net = activation_fn(net)
  return net


def inception_resnet_v2(inputs, num_classes=1001, is_training=True,
                        dropout_keep_prob=0.8,
                        reuse=None,
                        scope='InceptionResnetV2'):
  """Creates the Inception Resnet V2 model.

  Args:
    inputs: a 4-D tensor of size [batch_size, height, width, 3].
    num_classes: number of predicted classes.
    is_training: whether is training or not.
    dropout_keep_prob: float, the fraction to keep before final layer.
    reuse: whether or not the network and its variables should be reused. To be
      able to reuse 'scope' must be given.
    scope: Optional variable_scope.

  Returns:
    logits: the logits outputs of the model.
    end_points: the set of end_points from the inception model.
  """
  end_points = {}

  with tf.variable_scope(scope, 'InceptionResnetV2', [inputs], reuse=reuse):
    #with slim.arg_scope([slim.batch_norm, slim.dropout],
    #                    is_training=is_training):
    #  with slim.arg_scope([slim.conv2d, slim.max_pool2d, slim.avg_pool2d],
    #                      stride=1, padding='SAME'):

        # 149 x 149 x 32
        net = slim.conv2d(inputs, 32, 3, stride=2, padding='VALID',
                          scope='Conv2d_1a_3x3',normalizer_fn=slim.batch_norm)
        end_points['Conv2d_1a_3x3'] = net
        # 147 x 147 x 32
        net = slim.conv2d(net, 32, 3, padding='VALID',
                          scope='Conv2d_2a_3x3',normalizer_fn=slim.batch_norm)
        end_points['Conv2d_2a_3x3'] = net
        # 147 x 147 x 64
        net = slim.conv2d(net, 64, 3, scope='Conv2d_2b_3x3',normalizer_fn=slim.batch_norm)
        end_points['Conv2d_2b_3x3'] = net
        # 73 x 73 x 64
        net = slim.max_pool2d(net, 3, stride=2, padding='VALID',
                              scope='MaxPool_3a_3x3')
        end_points['MaxPool_3a_3x3'] = net
        # 73 x 73 x 80
        net = slim.conv2d(net, 80, 1, padding='VALID',
                          scope='Conv2d_3b_1x1',normalizer_fn=slim.batch_norm)
        end_points['Conv2d_3b_1x1'] = net
        # 71 x 71 x 192
        net = slim.conv2d(net, 192, 3, padding='VALID',
                          scope='Conv2d_4a_3x3',normalizer_fn=slim.batch_norm)
        end_points['Conv2d_4a_3x3'] = net
        # 35 x 35 x 192
        net = slim.max_pool2d(net, 3, stride=2, padding='VALID',
                              scope='MaxPool_5a_3x3')
        end_points['MaxPool_5a_3x3'] = net

        # 35 x 35 x 320
        with tf.variable_scope('Mixed_5b'):
          with tf.variable_scope('Branch_0'):
            tower_conv = slim.conv2d(net, 96, 1, scope='Conv2d_1x1',normalizer_fn=slim.batch_norm)
          with tf.variable_scope('Branch_1'):
            tower_conv1_0 = slim.conv2d(net, 48, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
            tower_conv1_1 = slim.conv2d(tower_conv1_0, 64, 5,
                                        scope='Conv2d_0b_5x5',normalizer_fn=slim.batch_norm)
          with tf.variable_scope('Branch_2'):
            tower_conv2_0 = slim.conv2d(net, 64, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
            tower_conv2_1 = slim.conv2d(tower_conv2_0, 96, 3,
                                        scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
            tower_conv2_2 = slim.conv2d(tower_conv2_1, 96, 3,
                                        scope='Conv2d_0c_3x3',normalizer_fn=slim.batch_norm)
          with tf.variable_scope('Branch_3'):
            tower_pool = slim.avg_pool2d(net, 3, stride=1, padding='SAME',
                                         scope='AvgPool_0a_3x3')
            tower_pool_1 = slim.conv2d(tower_pool, 64, 1,
                                       scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
          net = tf.concat(axis=3, values=[tower_conv, tower_conv1_1,
                              tower_conv2_2, tower_pool_1])

        end_points['Mixed_5b'] = net
        net = slim.repeat(net, 10, block35, scale=0.17)

        # 17 x 17 x 1024
        with tf.variable_scope('Mixed_6a'):
          with tf.variable_scope('Branch_0'):
            tower_conv = slim.conv2d(net, 384, 3, stride=2, padding='VALID',
                                     scope='Conv2d_1a_3x3',normalizer_fn=slim.batch_norm)
          with tf.variable_scope('Branch_1'):
            tower_conv1_0 = slim.conv2d(net, 256, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
            tower_conv1_1 = slim.conv2d(tower_conv1_0, 256, 3,
                                        scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
            tower_conv1_2 = slim.conv2d(tower_conv1_1, 384, 3,
                                        stride=2, padding='VALID',
                                        scope='Conv2d_1a_3x3',normalizer_fn=slim.batch_norm)
          with tf.variable_scope('Branch_2'):
            tower_pool = slim.max_pool2d(net, 3, stride=2, padding='VALID',
                                         scope='MaxPool_1a_3x3')
          net = tf.concat(axis=3, values=[tower_conv, tower_conv1_2, tower_pool])

        end_points['Mixed_6a'] = net
        net = slim.repeat(net, 20, block17, scale=0.10)

        # Auxillary tower   # 辅助塔
        with tf.variable_scope('AuxLogits',initializer=trunc_normal(0.1)):
          aux = slim.avg_pool2d(net, 5, stride=3, padding='VALID',
                                scope='Conv2d_1a_3x3')
          aux = slim.conv2d(aux, 128, 1, scope='Conv2d_1b_1x1',normalizer_fn=slim.batch_norm)
          aux = slim.conv2d(aux, 768, aux.get_shape()[1:3],
                            padding='VALID', scope='Conv2d_2a_5x5',normalizer_fn=slim.batch_norm)
          aux = slim.flatten(aux)
          aux = slim.fully_connected(aux, num_classes, activation_fn=None,
                                     scope='Logits')
          end_points['AuxLogits'] = aux

        with tf.variable_scope('Mixed_7a'):
          with tf.variable_scope('Branch_0'):
            tower_conv = slim.conv2d(net, 256, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
            tower_conv_1 = slim.conv2d(tower_conv, 384, 3, stride=2,
                                       padding='VALID', scope='Conv2d_1a_3x3',normalizer_fn=slim.batch_norm)
          with tf.variable_scope('Branch_1'):
            tower_conv1 = slim.conv2d(net, 256, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
            tower_conv1_1 = slim.conv2d(tower_conv1, 288, 3, stride=2,
                                        padding='VALID', scope='Conv2d_1a_3x3',normalizer_fn=slim.batch_norm)
          with tf.variable_scope('Branch_2'):
            tower_conv2 = slim.conv2d(net, 256, 1, scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
            tower_conv2_1 = slim.conv2d(tower_conv2, 288, 3,
                                        scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
            tower_conv2_2 = slim.conv2d(tower_conv2_1, 320, 3, stride=2,
                                        padding='VALID', scope='Conv2d_1a_3x3',normalizer_fn=slim.batch_norm)
          with tf.variable_scope('Branch_3'):
            tower_pool = slim.max_pool2d(net, 3, stride=2, padding='VALID',
                                         scope='MaxPool_1a_3x3')
          net = tf.concat(axis=3, values=[tower_conv_1, tower_conv1_1,
                              tower_conv2_2, tower_pool])

        end_points['Mixed_7a'] = net

        net = slim.repeat(net, 9, block8, scale=0.20)
        net = block8(net, activation_fn=None)

        net = slim.conv2d(net, 1536, 1, scope='Conv2d_7b_1x1',normalizer_fn=slim.batch_norm)
        end_points['Conv2d_7b_1x1'] = net

        with tf.variable_scope('Logits',initializer=trunc_normal(0.1)):
          end_points['PrePool'] = net
          net = slim.avg_pool2d(net, net.get_shape()[1:3], padding='VALID',
                                scope='AvgPool_1a_8x8')
          net = slim.flatten(net)

          net = slim.dropout(net, dropout_keep_prob, is_training=is_training,
                             scope='Dropout')

          end_points['PreLogitsFlatten'] = net
          logits = slim.fully_connected(net, num_classes, activation_fn=None,
                                        scope='Logits')
          end_points['Logits'] = logits
          end_points['Predictions'] = tf.nn.softmax(logits, name='Predictions')

  return logits, end_points
inception_resnet_v2.default_image_size = 299


def inception_resnet_v2_arg_scope(weight_decay=0.00004,
                                  batch_norm_decay=0.9997,
                                  batch_norm_epsilon=0.001):
  """Yields the scope with the default parameters for inception_resnet_v2.

  Args:
    weight_decay: the weight decay for weights variables.
    batch_norm_decay: decay for the moving average of batch_norm momentums.
    batch_norm_epsilon: small float added to variance to avoid dividing by zero.

  Returns:
    a arg_scope with the parameters needed for inception_resnet_v2.
  """
  # Set weight_decay for weights in conv2d and fully_connected layers.
  with slim.arg_scope([slim.conv2d, slim.fully_connected],
                      weights_regularizer=slim.l2_regularizer(weight_decay),
                      biases_regularizer=slim.l2_regularizer(weight_decay)):

    batch_norm_params = {
        'decay': batch_norm_decay,
        'epsilon': batch_norm_epsilon,
    }
    # Set activation_fn and parameters for batch_norm.
    with slim.arg_scope([slim.conv2d], activation_fn=tf.nn.relu,
                        normalizer_fn=slim.batch_norm,
                        normalizer_params=batch_norm_params) as scope:
      return scope


##############################  inception_resnet_v2 ##################################



##############################  class  inception_resnet_v2 ##################################


class my_network:
    def __init__(self,inputs,weights=None,sess=None,num_classes=3):
        self.inputs = inputs
        self.num_classes=num_classes
        self.build_net_and_get_logits()   #搭建网络，之后才能加载权重，和初始化权重 
        #self.get_new_logits()
        self.probs = self.end_points["Predictions"]
        if weights is not None and sess is not None:
            #sess.run(tf.global_variables_initializer()) 
            if checkpoint_exclude_scopes:
                self.load_weights(sess,weights)#variables_to_restore
            else:
                self.load_weights_just_ckpt(sess,weights)
   
   
    def check_var_not_inited(self):
        check_tensor=tf.report_uninitialized_variables(var_list=tf.trainable_variables())  #check 该网络中是否有未初始化的变量
        return check_tensor



    def build_net_and_get_logits(self):
        #with slim.arg_scope(inception_v3_arg_scope()):   #表示 在这个参数体系下面使用inception_v3,后来发现这个参数体系有问题，与ckpt不对应
        #with slim.arg_scope(inception_resnet_v2_arg_scope()):  # also can't work
        self.logits, self.end_points = inception_resnet_v2(inputs=self.inputs,num_classes=3,is_training=True,dropout_keep_prob=0.8,reuse=None)
        print("[v.op.name for v in tf.trainable_variables()]: ",len([v.op.name for v in tf.trainable_variables()]))


    def is_inited(self,sess,var_object):
        '''
        return: True or False
        '''
        return sess.run(tf.is_variable_initialized(var_object))



    def load_weights_just_ckpt(self,sess,weigths):
        save=tf.train.Saver()
        save.restore(sess,weigths)



    def load_weights(self,sess,weigths):
        self.var_li_restore,self.var_li_init=get_var_restored_and_init()  # 这里面的var_li,var_li_init 并不是字符串，而是一个OP(操作)
        print ("var_li_restore:  ",len(self.var_li_restore))  #输出看看是什么
        print ("var_li_init:  ",len(self.var_li_init))
        #save=tf.train.Saver(var_list=self.var_li_restore)
        #save.restore(sess,weigths)
        self.restore_op=slim.assign_from_checkpoint_fn(model_path=weigths, var_list=self.var_li_restore,ignore_missing_vars=True)
        self.restore_op(sess)  #在sess里面执行一下这个restore_op
        #print ("tf.GraphKeys.GLOBAL_VARIABLES: ",tf.GraphKeys.GLOBAL_VARIABLES)                #输出 "variables"
        #self.var_biases=tf.get_collection(key=tf.GraphKeys.GLOBAL_VARIABLES, scope='biases')   #这个scope是根据re.match进行匹配的 
        self.var_li_restore_remain=[var for var in self.var_li_restore if not self.is_inited(sess,var)]
        print ("var_li_restore_remain: ",len(self.var_li_restore_remain))    
        # check the restore_op 执行的怎么样了，是不是成功地初始化了var_li_restore
        self.var_li_init=self.var_li_init+self.var_li_restore_remain
        sess.run(tf.variables_initializer(var_list=self.var_li_init,name='init'))         #variables_to_init
        print("check_var_not_inited:\n\n",len(sess.run(self.check_var_not_inited())))#check 这些是需要restore,但是没有restore成功的

    


def save_weights(weigths,sess):
    save=tf.train.Saver()
    save.save(sess,weigths)



##############################  class  inception_resnet_v2 ##################################


def get_batch_train_data(has_batched=0,batch_num=93):
    x_data=[];y_label=[]
    b1=int(40.0/93*batch_num);  b2=batch_num-2*b1;
    batch_li=[b1,b1,b2]
    print (batch_li)
    for i in range(len(paths_train)):
        files_list=os.listdir(paths_train[i])
        batch_len=batch_li[i]
        for j in range(has_batched*batch_len,(has_batched+1)*batch_len):
            j=j%len(files_list)   ## avoid the out index 
            if not os.path.isdir(files_list[j]):
                img = imread(paths_train[i]+'/'+files_list[j])    # load the  image 
	#	print img
                x0=img.tolist()
                #print ('np.shape(x0): ',np.np.shape(x0))
                x_data.append(x0)   
                y_label.append(i)  #the label of car is 0;  minibus is 1;  taxi is 2;
    num=len(x_data)
    index_li=range(num)
    np.random.shuffle(index_li)
    data=[];label=[]
    for j in index_li:
        data.append(x_data[j])
        label.append(y_label[j])
    label=label_binary(np.mat(label),[0,1,2])
    return np.array(data,np.float32),np.array(label)



def label_binary(label,classes=[0,1,2]):
    if np.shape(label)[0]==1 and np.shape(label)[1]>=1:
        label=np.array(label).reshape(-1,).tolist()
        #print(label)
        for i in range(len(label)):
            init_list=np.zeros_like(classes).tolist()
            #print(init_list)
            for j in classes:
                if label[i]==j:
                    init_list[j]=1
                    label[i]=init_list
    else:
        print ('please check the shape==??==(1,m)')
    return np.mat(label)



def get_all_test_data():
    test_data=[]
    test_label=[]
    for i in range(len(paths_test)):
        files_list=os.listdir(paths_test[i])
        for files in files_list:
            if not os.path.isdir(files):
                img = imread(paths_test[i]+'/'+files)     #load the  image 
                x0=img.tolist()
                test_data.append(x0)
                test_label.append(i)
    num=len(test_data)
    index_li=range(num)
    np.random.shuffle(index_li)
    data=[];label=[]
    for j in index_li:
        data.append(test_data[j])
        label.append(test_label[j])
    label=label_binary(np.mat(label),[0,1,2])
    return np.array(data,np.float32),np.array(label)



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



def AveP(predictmat,labelmat,classlabel=1):
    if np.shape(predictmat)[0]==np.shape(labelmat)[0] and np.shape(predictmat)[0]==1 and np.shape(predictmat)[1]>=1 :
        m1=np.shape(predictmat)[1]
        cor=[];rec=[]
        for i in range(m1):
            pre=predictmat[:,:i+1]
            label=labelmat[:,:i+1]
            #print np.shape(pre),np.shape(label)
            cor.append(correct_rate(pre,label,classlabel))
            rec.append(recall_rate(pre,label,classlabel))
        # print "cor,rec: ",cor,rec
        cor=[ele for ele in cor if ele is not None]
        rec=[ele for ele in rec if ele is not None]
        #print "cor,rec: ",cor,rec
        index_li=np.argsort(rec)
        new_rec=[rec[index] for index in index_li]
        new_cor=[cor[index] for index in index_li]
        #print 'new_cor,new_rec: ',new_cor,new_rec
        AP=0
        m2=len(new_cor) 
        for j  in range(m2):
            if j==0:
                ap=new_cor[j]*new_rec[j]
            else:
                ap=new_cor[j]*(new_rec[j]-new_rec[j-1])
           # print ap
            AP=AP+ap
        return AP
    else:
        print "please check the np.shape=??=(1,m)"




def Mean_AP(predictmat,labelmat,classlabels_li):
    num=len(classlabels_li)
    sum_AP=0
    for i in range(num):
        sum_AP+=AveP(predictmat,labelmat,classlabels_li[i])
    MAP=round(sum_AP/num,5)
    return MAP



def inception_v3_testBuildClassificationNetwork():
    batch_size = 5
    height, width = 224, 224
    num_classes = 3
    inputs = tf.random_uniform((batch_size, height, width, 3))
    logits, end_points = inception_v3(inputs, num_classes)
    prediction=tf.nn.softmax(logits)
    with tf.Session() as sess:
        sess.run(tf.global_variables_initializer())
        pred=sess.run(prediction)
        print(pred)





def train_test(istrain=is_train):
    start=time.time()
    if istrain==False:
        epoch_len=1
        batch_len=1
    else:
        epoch_len=epoch_length
        batch_len=batch_length
    sess = tf.Session()
    xs=tf.placeholder(tf.float32,[None,299,299,3])
    my_net = my_network(xs,checkpoint_path,sess,num_classes=3)
    ys=tf.placeholder(tf.float32,[None,3])
    prediction=my_net.probs
    loss = tf.reduce_mean(tf.reduce_sum(tf.square(ys-prediction), axis=[0]))
    if checkpoint_exclude_scopes:
        train_step = tf.train.GradientDescentOptimizer(learning_rate=0.01,
                                                    use_locking=True,                                             #使用锁定       
                                                    name='Grad').minimize(loss,var_list=get_variables_to_train()) #只训练指定变量
    else:
        train_step=tf.train.GradientDescentOptimizer(0.001).minimize(loss)
    #sess.run(tf.global_variables_initializer())
    test_data,test_label=get_all_test_data()
    print 'test_data has load '
    for epoch_i in range(epoch_len):
        # training
        if istrain:
            print ' go to the  epoch_i = '+str(epoch_i)
            print " one epoch will batch until batch_i = "+str(batch_len)
        for batch_i in range(batch_len):
            if istrain:
                t1=time.time()
                print 'this is batch_i= '+str(batch_i)
                x_data,y_data=get_batch_train_data(has_batched=batch_i,batch_num=batch_number)
                sess.run(train_step, feed_dict={xs: x_data, ys: y_data})
                print('loss: ',sess.run(loss, feed_dict={xs: x_data, ys: y_data}))
                print("prediction:  ",sess.run(prediction,feed_dict={xs:x_data}))
                print("ys:          ",sess.run(ys,        feed_dict={ys:y_data}))
                prob = sess.run(prediction, feed_dict={xs: x_data})
                #####compute train correct_rate ####
                pre=prob.tolist()
                pre=[pre_i.index(np.array(pre_i).max()) for pre_i in pre]
                y_true=y_data.tolist()
                y_true=[y_i.index(np.array(y_i).max()) for y_i in y_true]
                cor_train=[];rec_train=[]
                for i in range(3):
                    cor_train.append(correct_rate(np.mat(pre),np.mat(y_true),i))
                    rec_train.append(recall_rate(np.mat(pre),np.mat(y_true),i))
                print "cor_train= ",cor_train
                print "rec_train= ",rec_train
                t2=time.time()
                print (" run_time:  "+str(t2-t1)+" s")
            #####compute test correct_rate ###
            y_test=test_label.tolist()[0:250]
            pre_test=[]
            for k in range(len(test_data)//50):   # for example 279//50 ==5
                #prob_test=sess.run(my_net.probs,feed_dict={xs: test_data[k:(k+1),:,:,:]})   #这样做的后果就是每次测试都是用的ckpt的权重,没有更新
                prob_test=sess.run(prediction,feed_dict={xs: test_data[50*k:50*(k+1),:,:,:]})#这就可以了，因为prediction是用的已经训练好的权重
                pre_test =pre_test+prob_test.tolist()                                        #另外把 50 作为测试的批次是对的，否则会出错
            #pre_test = sess.run(prediction,feed_dict={xs:test_data})                        #但是测试的批次太大也会有问题：会导致内存不足
            print ("pre_test: ",np.array(pre_test))
            print ("y_test:   ",np.array(y_test))
            pre_test=[pre_i.index(np.array(pre_i).max()) for pre_i in pre_test]
            y_test  =[y_i.index(np.array(y_i).max()) for y_i in y_test]
            MAP     =Mean_AP(np.mat(pre_test),np.mat(y_test),[0,1,2])
            print 'MAP = ',MAP
            cor_test=[];rec_test=[]
            for i in range(3):
                cor_test.append(correct_rate(np.mat(pre_test),np.mat(y_test),i))
                rec_test.append(recall_rate(np.mat(pre_test),np.mat(y_test),i))
            cor_test=[round(ele,5) for ele in cor_test]
            rec_test=[round(ele,5) for ele in rec_test]
            print "cor_test= ",cor_test
            print "rec_test= ",rec_test
        print " has finished epoch_i = "+str(epoch_i)
        save_weights(checkpoint_path,sess)
        print " has save the checkpoint_path "
    end=time.time()
    run_time=end-start
    return cor_test,rec_test,round(MAP,4),round(run_time,4)




def get_var_restored_and_init(checkpoint_exclude_scopes=checkpoint_exclude_scopes):
    """Returns a function run by the chief worker to warm-start the training.
    Note that the init_fn is only run when initializing the model during the very
    first global step.
    Returns:
    An init function run by the supervisor.
    """
    exclusions = []
    if checkpoint_exclude_scopes:
        exclusions = [scope.strip() for scope in checkpoint_exclude_scopes.split(',')]
    variables_to_restore = []
    variable_to_init=[]
    for var in slim.get_model_variables():    #获取当前的slim网络的变量
        excluded = False  
        for exclusion in exclusions:   #exclusions=[InceptionV3/Logits,InceptionV3/AuxLogits]
            if var.op.name.startswith(exclusion):
                excluded = True       
                break            #只要var.op.name 是以上面列表中的任何一个开头，那么就会有exclude=True ,即表示：此var不能从ckpt中restore
        if not excluded:
            variables_to_restore.append(var)
        else: 
            variable_to_init.append(var)
    return variables_to_restore,variable_to_init
    



def get_variables_to_train(trainable_scopes=trainable_scopes):
  """Returns a list of variables to train.
  Returns:
    A list of variables to train by the optimizer.
  """
  if trainable_scopes =="all":
    print 'variables_to_train:   ',len(tf.trainable_variables())
    return tf.trainable_variables()
  else:
    scopes = [scope.strip() for scope in trainable_scopes.split(',')]
  variables_to_train = []
  for scope in scopes:
    variables = tf.get_collection(tf.GraphKeys.TRAINABLE_VARIABLES, scope)
    variables_to_train.extend(variables)
  print 'variables_to_train:   ',len(variables_to_train)
  return variables_to_train


if __name__=='__main__':
   cor_test,rec_test,MAP,run_time=train_test(istrain=is_train) 
