#coding:utf-8
import re
import sys
print("var_name_txt_of_the_ckpt_file default is (ckpt_filename)_var_name.txt")
if len(sys.argv)!=2:
    print("usage: python "+sys.argv[0]+" ckpt_file")
    sys.exit()
var_path=sys.argv[1]
new_var_path=sys.argv[1].split(".")[0]+"_var_name.txt"
#var_path="/home/gui/data/checkpoints/inception_v3.ckpt"
#new_var_path="/home/gui/work2017/ckpt/inception_v3_ckpt_arguments.txt"
new_var_li=[]
with open(var_path,'r') as fr:
    for i in range(2000):
        var_name=fr.readline()   
        #如果用readlines会将文件的全部内容读进内存，这个算法效率太低
        pattern="(biases){0,1}(beta){0,1}(moving_mean){0,1}(moving_variance){0,1}(weights){0,1}"   
        # 以其中任意一个字符串作为分割点
        var_li_i=re.split(pattern,var_name)
        var_li_i=[ele for ele in var_li_i if ele is not None]
        #print var_li_i
        if len(var_li_i)>=2:   
            # 应该会至少分出两个及以上的字符串
            try:
                assert "global_step" not in var_li_i[0]   
                # 一旦出现global_step,说明到此为止
            except:
                break
            var_li_i_0=list(var_li_i[0])
            try:
                var_li_i_0.pop(0)
                # pop 的返回值是 出去的那个字符
            except:
                continue
            var_li_i_0="".join(var_li_i_0) 
            #把list  ->   string
            #print(var_li_i_0)                
            #print 会减慢执行速度，slow the speed of execute
            var_need=var_li_i_0+var_li_i[1]+"\n"
            new_var_li.append(var_need)
with open(new_var_path,"w") as fw:
    for i in range(len(new_var_li)):
        fw.writelines(new_var_li[i])

