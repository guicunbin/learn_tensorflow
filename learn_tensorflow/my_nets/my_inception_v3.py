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
#checkpoint_exclude_scopes="InceptionV3/Logits,InceptionV3/AuxLogits"
checkpoint_exclude_scopes=None    #表示直接从ckpt中回复
checkpoint_path="/home/gui/work2017/data/inception_v3_ckpt/inception_v3.ckpt"
is_train=True #this is the args of train 
batch_length=100    #this is the args of train 
batch_number=25
epoch_length=10   #this is the args of train 
#workpath=sys.path[0]
workpath    ='/home/gui/back20170125/python3'
start_jpg=workpath+'/start.jpg'
paths_test=[workpath+'/image/car/car_test/Images/',
           workpath+'/image/minibus/minibus_test/Images/',
           workpath+'/image/taxi/taxi_test/Images/' ]
paths_train=[workpath+'/image/car/car_train/Images/',
            workpath+'/image/minibus/minibus_train/Images/',
            workpath+'/image/taxi/taxi_train/Images/']
train_dir='/home/gui/work2017/data'
#trainable_scopes="InceptionV3/Logits,InceptionV3/AuxLogits"  # 先训练这几个层，其他的层保持ckpt的参数不变
trainable_scopes="all"  #表示训练所有层


##############################  inception_v3 ##################################

trunc_normal = lambda stddev: tf.truncated_normal_initializer(0.0, stddev)


def inception_v3_base(inputs,
                      final_endpoint='Mixed_7c',
                      min_depth=16,
                      depth_multiplier=1.0,
                      scope=None):
  """Inception model from http://arxiv.org/abs/1512.00567.
  Constructs an Inception v3 network from inputs to the given final endpoint.
  This method can construct the network up to the final inception block
  Mixed_7c.
  Note that the names of the layers in the paper do not correspond to the names
  of the endpoints registered by this function although they build the same
  network.
  Here is a mapping from the old_names to the new names:
  Old name          | New name
  =======================================
  conv0             | Conv2d_1a_3x3
  conv1             | Conv2d_2a_3x3
  conv2             | Conv2d_2b_3x3
  pool1             | MaxPool_3a_3x3
  conv3             | Conv2d_3b_1x1
  conv4             | Conv2d_4a_3x3
  pool2             | MaxPool_5a_3x3
  mixed_35x35x256a  | Mixed_5b
  mixed_35x35x288a  | Mixed_5c
  mixed_35x35x288b  | Mixed_5d
  mixed_17x17x768a  | Mixed_6a
  mixed_17x17x768b  | Mixed_6b
  mixed_17x17x768c  | Mixed_6c
  mixed_17x17x768d  | Mixed_6d
  mixed_17x17x768e  | Mixed_6e
  mixed_8x8x1280a   | Mixed_7a
  mixed_8x8x2048a   | Mixed_7b
  mixed_8x8x2048b   | Mixed_7c
  Args:
    inputs: a tensor of size [batch_size, height, width, channels].
    final_endpoint: specifies the endpoint to construct the network up to. It
      can be one of ['Conv2d_1a_3x3', 'Conv2d_2a_3x3', 'Conv2d_2b_3x3',
      'MaxPool_3a_3x3', 'Conv2d_3b_1x1', 'Conv2d_4a_3x3', 'MaxPool_5a_3x3',
      'Mixed_5b', 'Mixed_5c', 'Mixed_5d', 'Mixed_6a', 'Mixed_6b', 'Mixed_6c',
      'Mixed_6d', 'Mixed_6e', 'Mixed_7a', 'Mixed_7b', 'Mixed_7c'].
    min_depth: Minimum depth value (number of channels) for all convolution ops.
      Enforced when depth_multiplier < 1, and not an active constraint when
      depth_multiplier >= 1.
    depth_multiplier: Float multiplier for the depth (number of channels)
      for all convolution ops. The value must be greater than zero. Typical
      usage will be to set this value in (0, 1) to reduce the number of
      parameters or computation cost of the model.
    scope: Optional variable_scope.
  Returns:
    tensor_out: output tensor corresponding to the final_endpoint.
    end_points: a set of activations for external use, for example summaries or
                losses.
  Raises:
    ValueError: if final_endpoint is not set to one of the predefined values,
                or depth_multiplier <= 0
  """
  # end_points will collect relevant activations for external use, for example
  # summaries or losses.
  end_points = {}
  if depth_multiplier <= 0:
    raise ValueError('depth_multiplier is not greater than zero.')
  depth = lambda d: max(int(d * depth_multiplier), min_depth)
  with tf.variable_scope(scope, 'InceptionV3', [inputs]):
    with slim.arg_scope([slim.conv2d, slim.max_pool2d, slim.avg_pool2d],
                        stride=1, padding='VALID'):
      # 299 x 299 x 3
      end_point = 'Conv2d_1a_3x3'         
      # 下面这个卷积会产生: InceptionV3/Conv2d_1a_3x3/weights                      # can be trained
      #                     InceptionV3/Conv2d_1a_3x3/BatchNorm/beta               # can be trained
      #                     InceptionV3/Conv2d_1a_3x3/BatchNorm/moving_mean        # not trainable_variables
      #                     InceptionV3/Conv2d_1a_3x3/BatchNorm/moving_variance    # not trainable_variables
      net = slim.conv2d(inputs, depth(32), [3, 3], stride=2, scope=end_point, normalizer_fn=slim.batch_norm)   # 299/2=149  
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # 149 x 149 x 32
      end_point = 'Conv2d_2a_3x3'
      # 下面这个卷积会产生: InceptionV3/Conv2d_2a_3x3/weights                      # can be trained
      #                     InceptionV3/Conv2d_2a_3x3/BatchNorm/beta               # can be trained
      #                     InceptionV3/Conv2d_2a_3x3/BatchNorm/moving_mean        # not trainable_variables
      #                     InceptionV3/Conv2d_2a_3x3/BatchNorm/moving_variance    # not trainable_variables
      net = slim.conv2d(net, depth(32), [3, 3], scope=end_point,normalizer_fn=slim.batch_norm)
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # 147 x 147 x 32
      end_point = 'Conv2d_2b_3x3'
      net = slim.conv2d(net, depth(64), [3, 3], padding='SAME', scope=end_point, normalizer_fn=slim.batch_norm)
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # 147 x 147 x 64
      end_point = 'MaxPool_3a_3x3'
      net = slim.max_pool2d(net, [3, 3], stride=2, scope=end_point)
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # 73 x 73 x 64
      end_point = 'Conv2d_3b_1x1'
      net = slim.conv2d(net, depth(80), [1, 1], scope=end_point, normalizer_fn=slim.batch_norm)
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # 73 x 73 x 80.
      end_point = 'Conv2d_4a_3x3'
      net = slim.conv2d(net, depth(192), [3, 3], scope=end_point, normalizer_fn=slim.batch_norm)
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # 71 x 71 x 192.
      end_point = 'MaxPool_5a_3x3'
      net = slim.max_pool2d(net, [3, 3], stride=2, scope=end_point)
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # 35 x 35 x 192.
    # Inception blocks
    with slim.arg_scope([slim.conv2d, slim.max_pool2d, slim.avg_pool2d],
                        stride=1, padding='SAME'):
      # mixed: 35 x 35 x 256.
      end_point = 'Mixed_5b'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(64), [1, 1], scope='Conv2d_0a_1x1', normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(48), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(64), [5, 5],
                                 scope='Conv2d_0b_5x5',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(64), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(96), [3, 3],
                                 scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(96), [3, 3],
                                 scope='Conv2d_0c_3x3',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(branch_3, depth(32), [1, 1],
                                 scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_1: 35 x 35 x 288.
      end_point = 'Mixed_5c'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(64), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(48), [1, 1], scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(64), [5, 5],
                                 scope='Conv_1_0c_5x5',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(64), [1, 1],
                                 scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(96), [3, 3],
                                 scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(96), [3, 3],
                                 scope='Conv2d_0c_3x3',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(branch_3, depth(64), [1, 1],
                                 scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_2: 35 x 35 x 288.
      end_point = 'Mixed_5d'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(64), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(48), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(64), [5, 5],
                                 scope='Conv2d_0b_5x5',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(64), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(96), [3, 3],
                                 scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(96), [3, 3],
                                 scope='Conv2d_0c_3x3',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(branch_3, depth(64), [1, 1],
                                 scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_3: 17 x 17 x 768.
      end_point = 'Mixed_6a'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(384), [3, 3], stride=2,
                                 padding='VALID', scope='Conv2d_1a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(64), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(96), [3, 3],
                                 scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(96), [3, 3], stride=2,
                                 padding='VALID', scope='Conv2d_1a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.max_pool2d(net, [3, 3], stride=2, padding='VALID',
                                     scope='MaxPool_1a_3x3')
        net = tf.concat(3, [branch_0, branch_1, branch_2])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed4: 17 x 17 x 768.
      end_point = 'Mixed_6b'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(192), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(128), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(128), [1, 7],
                                 scope='Conv2d_0b_1x7',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(192), [7, 1],
                                 scope='Conv2d_0c_7x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(128), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(128), [7, 1],
                                 scope='Conv2d_0b_7x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(128), [1, 7],
                                 scope='Conv2d_0c_1x7',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(128), [7, 1],
                                 scope='Conv2d_0d_7x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(192), [1, 7],
                                 scope='Conv2d_0e_1x7',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(branch_3, depth(192), [1, 1],
                                 scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_5: 17 x 17 x 768.
      end_point = 'Mixed_6c'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(192), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(160), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(160), [1, 7],
                                 scope='Conv2d_0b_1x7',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(192), [7, 1],
                                 scope='Conv2d_0c_7x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(160), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(160), [7, 1],
                                 scope='Conv2d_0b_7x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(160), [1, 7],
                                 scope='Conv2d_0c_1x7',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(160), [7, 1],
                                 scope='Conv2d_0d_7x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(192), [1, 7],
                                 scope='Conv2d_0e_1x7',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(branch_3, depth(192), [1, 1],
                                 scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_6: 17 x 17 x 768.
      end_point = 'Mixed_6d'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(192), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(160), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(160), [1, 7],
                                 scope='Conv2d_0b_1x7',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(192), [7, 1],
                                 scope='Conv2d_0c_7x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(160), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(160), [7, 1],
                                 scope='Conv2d_0b_7x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(160), [1, 7],
                                 scope='Conv2d_0c_1x7',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(160), [7, 1],
                                 scope='Conv2d_0d_7x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(192), [1, 7],
                                 scope='Conv2d_0e_1x7',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(branch_3, depth(192), [1, 1],
                                 scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_7: 17 x 17 x 768.
      end_point = 'Mixed_6e'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(192), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(192), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(192), [1, 7],
                                 scope='Conv2d_0b_1x7',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(192), [7, 1],
                                 scope='Conv2d_0c_7x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(192), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(192), [7, 1],
                                 scope='Conv2d_0b_7x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(192), [1, 7],
                                 scope='Conv2d_0c_1x7',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(192), [7, 1],
                                 scope='Conv2d_0d_7x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(branch_2, depth(192), [1, 7],
                                 scope='Conv2d_0e_1x7',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(branch_3, depth(192), [1, 1],
                                 scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_8: 8 x 8 x 1280.
      end_point = 'Mixed_7a'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(192), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_0 = slim.conv2d(branch_0, depth(320), [3, 3], stride=2,
                                 padding='VALID', scope='Conv2d_1a_3x3',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(192), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(192), [1, 7],
                                 scope='Conv2d_0b_1x7',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(192), [7, 1],
                                 scope='Conv2d_0c_7x1',normalizer_fn=slim.batch_norm)
          branch_1 = slim.conv2d(branch_1, depth(192), [3, 3], stride=2,
                                 padding='VALID', scope='Conv2d_1a_3x3',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.max_pool2d(net, [3, 3], stride=2, padding='VALID',
                                     scope='MaxPool_1a_3x3')
        net = tf.concat(3, [branch_0, branch_1, branch_2])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_9: 8 x 8 x 2048.
      end_point = 'Mixed_7b'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(320), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(384), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = tf.concat(3, [
              slim.conv2d(branch_1, depth(384), [1, 3], scope='Conv2d_0b_1x3',normalizer_fn=slim.batch_norm),
              slim.conv2d(branch_1, depth(384), [3, 1], scope='Conv2d_0b_3x1',normalizer_fn=slim.batch_norm)])
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(448), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(
              branch_2, depth(384), [3, 3], scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
          branch_2 = tf.concat(3, [
              slim.conv2d(branch_2, depth(384), [1, 3], scope='Conv2d_0c_1x3',normalizer_fn=slim.batch_norm),
              slim.conv2d(branch_2, depth(384), [3, 1], scope='Conv2d_0d_3x1',normalizer_fn=slim.batch_norm)])
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(
              branch_3, depth(192), [1, 1], scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
      # mixed_10: 8 x 8 x 2048.
      end_point = 'Mixed_7c'
      with tf.variable_scope(end_point):
        with tf.variable_scope('Branch_0'):
          branch_0 = slim.conv2d(net, depth(320), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
        with tf.variable_scope('Branch_1'):
          branch_1 = slim.conv2d(net, depth(384), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_1 = tf.concat(3, [
              slim.conv2d(branch_1, depth(384), [1, 3], scope='Conv2d_0b_1x3',normalizer_fn=slim.batch_norm),
              slim.conv2d(branch_1, depth(384), [3, 1], scope='Conv2d_0c_3x1',normalizer_fn=slim.batch_norm)])
        with tf.variable_scope('Branch_2'):
          branch_2 = slim.conv2d(net, depth(448), [1, 1], scope='Conv2d_0a_1x1',normalizer_fn=slim.batch_norm)
          branch_2 = slim.conv2d(
              branch_2, depth(384), [3, 3], scope='Conv2d_0b_3x3',normalizer_fn=slim.batch_norm)
          branch_2 = tf.concat(3, [
              slim.conv2d(branch_2, depth(384), [1, 3], scope='Conv2d_0c_1x3',normalizer_fn=slim.batch_norm),
              slim.conv2d(branch_2, depth(384), [3, 1], scope='Conv2d_0d_3x1',normalizer_fn=slim.batch_norm)])
        with tf.variable_scope('Branch_3'):
          branch_3 = slim.avg_pool2d(net, [3, 3], scope='AvgPool_0a_3x3')
          branch_3 = slim.conv2d(
              branch_3, depth(192), [1, 1], scope='Conv2d_0b_1x1',normalizer_fn=slim.batch_norm)
        net = tf.concat(3, [branch_0, branch_1, branch_2, branch_3])
      end_points[end_point] = net
      if end_point == final_endpoint: return net, end_points
    raise ValueError('Unknown final endpoint %s' % final_endpoint)




def inception_v3(inputs,
                 num_classes=1000,
                 is_training=True,
                 dropout_keep_prob=0.8,
                 min_depth=16,
                 depth_multiplier=1.0,
                 prediction_fn=slim.softmax,
                 spatial_squeeze=True,
                 reuse=None,
                 scope='InceptionV3'):
  """Inception model from http://arxiv.org/abs/1512.00567.
  "Rethinking the Inception Architecture for Computer Vision"
  Christian Szegedy, Vincent Vanhoucke, Sergey Ioffe, Jonathon Shlens,
  Zbigniew Wojna.
  With the default arguments this method constructs the exact model defined in
  the paper. However, one can experiment with variations of the inception_v3
  network by changing arguments dropout_keep_prob, min_depth and
  depth_multiplier.
  The default image size used to train this network is 299x299.
  Args:
    inputs: a tensor of size [batch_size, height, width, channels].
    num_classes: number of predicted classes.
    is_training: whether is training or not.
    dropout_keep_prob: the percentage of activation values that are retained.
    min_depth: Minimum depth value (number of channels) for all convolution ops.
      Enforced when depth_multiplier < 1, and not an active constraint when
      depth_multiplier >= 1.
    depth_multiplier: Float multiplier for the depth (number of channels)
      for all convolution ops. The value must be greater than zero. Typical
      usage will be to set this value in (0, 1) to reduce the number of
      parameters or computation cost of the model.
    prediction_fn: a function to get predictions out of logits.
    spatial_squeeze: if True, logits is of shape is [B, C], if false logits is
        of shape [B, 1, 1, C], where B is batch_size and C is number of classes.
    reuse: whether or not the network and its variables should be reused. To be
      able to reuse 'scope' must be given.
    scope: Optional variable_scope.
  Returns:
    logits: the pre-softmax activations, a tensor of size
      [batch_size, num_classes]
    end_points: a dictionary from components of the network to the corresponding
      activation.
  Raises:
    ValueError: if 'depth_multiplier' is less than or equal to zero.
  """
  if depth_multiplier <= 0:
    raise ValueError('depth_multiplier is not greater than zero.')
  depth = lambda d: max(int(d * depth_multiplier), min_depth)
  with tf.variable_scope(scope, 'InceptionV3', [inputs, num_classes],
                         reuse=reuse) as scope:
    with slim.arg_scope([slim.batch_norm, slim.dropout],
                        is_training=is_training):
      net, end_points = inception_v3_base(
          inputs, scope=scope, min_depth=min_depth,
          depth_multiplier=depth_multiplier)
      # Auxiliary Head logits
      with slim.arg_scope([slim.conv2d, slim.max_pool2d, slim.avg_pool2d],
                          stride=1, padding='SAME'):
        aux_logits = end_points['Mixed_6e']
        with tf.variable_scope('AuxLogits'):
          aux_logits = slim.avg_pool2d(
              aux_logits, [5, 5], stride=3, padding='VALID',
              scope='AvgPool_1a_5x5')
          aux_logits = slim.conv2d(aux_logits, depth(128), [1, 1],weights_initializer=trunc_normal(0.01),
                                    activation_fn=None,#tf.nn.relu,
                                   scope='Conv2d_1b_1x1',normalizer_fn=slim.batch_norm)
          # Shape of feature map before the final layer.
          kernel_size = _reduced_kernel_size_for_small_input(
              aux_logits, [5, 5])
          aux_logits = slim.conv2d(
              aux_logits, depth(768), kernel_size,
              weights_initializer=trunc_normal(0.01),
              padding='VALID', scope='Conv2d_2a_{}x{}'.format(*kernel_size),normalizer_fn=slim.batch_norm)
          aux_logits = slim.conv2d(
              aux_logits, num_classes, [1, 1], activation_fn=None,#tf.nn.relu,
               weights_initializer=trunc_normal(0.01),
              scope='Conv2d_2b_1x1',normalizer_fn=slim.batch_norm)
          if spatial_squeeze:
            aux_logits = tf.squeeze(aux_logits, [1, 2], name='SpatialSqueeze')
          end_points['AuxLogits'] = aux_logits
      # Final pooling and prediction
      with tf.variable_scope('Logits'):
        kernel_size = _reduced_kernel_size_for_small_input(net, [8, 8])
        net = slim.avg_pool2d(net, kernel_size, padding='VALID',
                              scope='AvgPool_1a_{}x{}'.format(*kernel_size))
        # 1 x 1 x 2048
        net = slim.dropout(net, keep_prob=dropout_keep_prob, scope='Dropout_1b')
        end_points['PreLogits'] = net
        # 2048
        logits = slim.conv2d(net, num_classes, [1, 1], activation_fn=None,#tf.nn.relu,
                             weights_initializer=trunc_normal(0.01),
                             scope='Conv2d_1c_1x1',normalizer_fn=slim.batch_norm)
        if spatial_squeeze:
          logits = tf.squeeze(logits, [1, 2], name='SpatialSqueeze')
        # 1000
      end_points['Logits'] = logits
      end_points['Predictions'] = prediction_fn(logits, scope='Predictions')
  return logits, end_points
inception_v3.default_image_size = 299




def _reduced_kernel_size_for_small_input(input_tensor, kernel_size):
  """Define kernel size which is automatically reduced for small input.
  If the shape of the input images is unknown at graph construction time this
  function assumes that the input images are is large enough.
  Args:
    input_tensor: input tensor of size [batch_size, height, width, channels].
    kernel_size: desired kernel size of length 2: [kernel_height, kernel_width]
  Returns:
    a tensor with the kernel size.
  TODO(jrru): Make this function work with unknown shapes. Theoretically, this
  can be done with the code below. Problems are two-fold: (1) If the shape was
  known, it will be lost. (2) inception.slim.ops._two_element_tuple cannot
  handle tensors that define the kernel size.
      shape = tf.shape(input_tensor)
      return = tf.stack([tf.minimum(shape[1], kernel_size[0]),
                        tf.minimum(shape[2], kernel_size[1])])
  """
  shape = input_tensor.get_shape().as_list()
  if shape[1] is None or shape[2] is None:
    kernel_size_out = kernel_size
  else:
    kernel_size_out = [min(shape[1], kernel_size[0]),
                       min(shape[2], kernel_size[1])]
  return kernel_size_out




def inception_v3_arg_scope(weight_decay=0.00004,
                           stddev=0.5,
                           batch_norm_var_collection='moving_vars'):
  """Defines the default InceptionV3 arg scope.
  Args:
    weight_decay: The weight decay to use for regularizing the model.
    stddev: The standard deviation of the trunctated normal weight initializer.
    batch_norm_var_collection: The name of the collection for the batch norm
      variables.
  Returns:
    An `arg_scope` to use for the inception v3 model.
  """
  batch_norm_params = {
      # Decay for the moving averages.
      'decay': 0.9997,
      # epsilon to prevent 0s in variance.
      'epsilon': 0.001,
      # collection containing update_ops.
      'updates_collections': tf.GraphKeys.UPDATE_OPS,
      # collection containing the moving mean and moving variance.
      'variables_collections': {
          'beta': None,
          'gamma': None,
          'moving_mean': [batch_norm_var_collection],
          'moving_variance': [batch_norm_var_collection],
      }
  }
  # Set weight_decay for weights in Conv and FC layers.
  with slim.arg_scope([slim.conv2d, slim.fully_connected],
                      weights_regularizer=slim.l2_regularizer(weight_decay)):
    with slim.arg_scope(
        [slim.conv2d],
        weights_initializer=tf.truncated_normal_initializer(stddev=stddev),
        activation_fn=tf.nn.relu,
        normalizer_fn=slim.batch_norm,
        normalizer_params=batch_norm_params) as sc:
      return sc




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



class my_inception_v3:
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
        self.logits, self.end_points = inception_v3(inputs=self.inputs,num_classes=3,is_training=True,dropout_keep_prob=0.8,reuse=None)
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
        self.var_biases=[var for var in self.var_li_restore if not self.is_inited(sess,var)]
        print ("var_biases: ",len(self.var_biases))
        self.var_li_init=self.var_li_init+self.var_biases
        sess.run(tf.variables_initializer(var_list=self.var_li_init,name='init'))         #variables_to_init
        print("check_var_not_inited:\n\n",len(sess.run(self.check_var_not_inited())))#check 这些是需要restore,但是没有restore成功的

    


def save_weights(weigths,sess):
    save=tf.train.Saver()
    save.save(sess,weigths)




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
    my_net = my_inception_v3(xs,checkpoint_path,sess,num_classes=3)
    ys=tf.placeholder(tf.float32,[None,3])
    prediction=my_net.probs
    loss = tf.reduce_mean(tf.reduce_sum(tf.square(ys-prediction), reduction_indices=[0]))
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
