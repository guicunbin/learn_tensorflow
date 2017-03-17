import re
import fire
import time




def get_list_from_file(input_file):
    with open(input_file,'r') as fr:
        li=fr.readlines()
    return li




def write_list_to_file(output_file,li):
    with open(output_file,'w') as fw:
        for row in li:
            fw.writelines(row)



def the_str1_in_list(str1,str_list):
    '''
    check every str of the str_list has or not has str1
    if has   return    True
    else     return    False
    '''
    #print 'str1:  ',str1
    #print "str_list:  ",str_list
    for s1 in str_list:
        # if len(re.findall(str1,s1))>0: 
        # here is wrong because of "(" should be write to "\("
        if str1 in s1: 
            return True
        else:
            str1_li=re.split("\s{0,5}\({0,1}\){0,1}",str1)
            #print "******str1_li******",str1_li
            new_str1_li=[str_i for str_i in str1_li if len(str_i)>0]
            pattern=''
            #print "*****new_str1_li***",new_str1_li
            for i in range(len(new_str1_li)-1):
                pattern=pattern+new_str1_li[i]+'\s{1,10}'
            pattern=pattern+'\('+new_str1_li[-1]+'\)'
            #print "******pattern:  \n",pattern
            pattern=re.compile(pattern)
            ## ' on user_pay (shop_id)' can match " on          user_pay      (shop_id)" 
            if len(re.findall(pattern,s1))>0:
                return True
    return False





def main_1(input_file,output_file):
    '''
    main_1 use fr.readlines() , so need list to store it,and new list to store replace one,
    '''
    t1=time.time()
    row_li=get_list_from_file(input_file)
    new_row_li=[];   i=0;
    ## pattern:    "create    index   index100"
    pattern  =re.compile("create {1,5}index {1,5}index\d{0,4}",re.IGNORECASE)
    ## pattern_1:  "on    feature_user_pay    (shop_id)"
    pattern_1=re.compile("on {1,100}\w{1,50} {1,100}\(\w{1,20}\)")
    for row in row_li:
        new_row=re.sub(pattern,'create index index'+str(i),row)    
        ## this has replaced
        s1_li=re.findall(pattern_1,new_row)
        if len(s1_li)>0:
            #print s1_li
            s1=''.join(s1_li)
            #print s1
            ## get  str like "on  feature_user_pay   (shop_id)"
            if the_str1_in_list(s1,new_row_li):
                print '##############   '+s1+"    already   exists !!!!!    will  delete   it !!!!  " 
                new_row='\n'
            else:
                i=i+1;
        new_row_li.append(new_row)
    write_list_to_file(output_file,new_row_li)
    t2=time.time()
    print 'main_1 run_time: '+str(t2-t1)+' seconds'




#def main_2(input_file,output_file):
#    '''
#    main2 use fr.readline and replace in time, but the output_file must be diffierent from input_file
#    '''
#    if input_file==output_file:
#        print " this main_2 need diffierent files to output"
#    else:
#        t1=time.time()
#        pattern=re.compile("create index index\d{0,4}",re.IGNORECASE)
#        with open(input_file,'r') as fr:
#            with open(output_file,'w') as fw:
#                row=True;
#                i=0;
#                while row:
#                    row=fr.readline()
#                    new_row=re.sub(pattern,'create index index'+str(i),row)    
#                    fw.writelines(new_row)
#                    if new_row != row:
#                        i=i+1;
#        t2=time.time()
#        print 'main_2 run_time: '+str(t2-t1)+' seconds'




def main(input_file,output_file,main_num):
    if main_num==1:
        main_1(input_file,output_file)
    elif main_num==2:
        main_2(input_file,output_file)
    else:
        print "main_num must be 1 or 2"




if __name__=="__main__":
    fire.Fire(main)


