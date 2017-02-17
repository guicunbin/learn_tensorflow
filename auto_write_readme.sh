paths=$HOME/work2017/my_git
readme_md=${paths}/README.md
if test -e $readme_md
then
    rm  $readme_md  
    touch $readme_md
fi
# 删掉旧的，创建新的
for i in $(ls ${paths}) 
#( ) 表示里面是命令
do
    f1=${paths}/$i
    if test -d $f1
    then
        echo "-------" >> $readme_md
        echo "-------" >> $readme_md
        echo "-------" >> $readme_md
        echo "#"$i >> $readme_md
        #一级标题
        echo ''
        for j in $(ls ${f1})
        do
            f2=$f1/$j
            if test -d $f2
            then
                echo "-------" >> $readme_md
                echo "###" $j >> $readme_md
                #二级标题
                for k in $(ls ${f2})
                do 
                    echo "#####"  $k >> $readme_md
                    #三级标题
                done
            else
                echo "##" $j >> $readme_md
                
            fi
        done
    fi
done
