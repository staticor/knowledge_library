#!/bin/sh
# @Author: jinyongyang
# @Date:   2015-12-09 14:52:03
# @Last Modified by:   jinyongyang
# @Last Modified time: 2015-12-11 13:21:42



#####################         Args List      ###############################

# tag
#                                 offline_modifier

# num                             预测时间窗口
# companyid                       预测Target:    advertiser_companyId
# end_date                        预测时间Bond:
# predict_pyids
#                                 模型预测的人群路径 <hdfs>
#                                 description_placeholder  ---- pyid ---- score
############################################################################


export LANG=en_US.UTF-8


base_dir=$(dirname $0);
cd $base_dir


log(){
        echo "`date +%Y%m%d-%H:%M:%S` : $@" >> ${RUNLOG}
        #在运行日志里记录时间以及错误代码，格式：年月日-时：分：秒  ： 错误代码
}





num=3
end_date=$(date -d "2015/12/08 +0days" +%Y/%m/%d)
companyid=2527   # 2527  : 小融金融
predict_pyids="/user/yujia.miao/lookalike/USERMODEL/offline/pv_ALL/2015/12/06"  # 小融 明亮  100W * 7  Using PV
tagname="xiaorong_pv"
echo $tag, $num, $end_date, $companyid, $predict_pyids

mkdir $base_dir/$tagname
RUNLOG=$base_dir/$tagname/running.log


total=$num
start_date=$(date -d "${end_date} -${num}days" +%Y/%m/%d)
str_date=$end_date
str_date_list=$(date -d "${end_date} +0days" +%Y%m%d)
yyyy=${end_date:0:4}
mm=${end_date:5:2}
dd=${end_date:8:2}
function get_time_seq(){
while [ $num -gt 1 ]
do
    num=`expr $num - 1`
    dec_num=`expr $total - $num`
    v_date=`date "-d -$dec_num day $end_date" +%Y/%m/%d`
    str_date=$str_date","$v_date
    str_date_list="$str_date_list $(date -d "${v_date} +0days" +%Y%m%d)"
done
echo "str_date : $str_date"

}
get_time_seq


CheckInModule(){
        if [ $? != 0 ];then
                echo "程序运行出错. Module 报警模块: < $1 >" | mutt -s "stuck in ${FILENAME}"  "$LOGNAME@ipinyou.com"
                exit -1
        fi
}


#####################       Generate Data MySQL   #############################
###############################################################################


num=3

start_time=$(date -d "${end_date} -${num} days" +%Y-%m-%d)" 00:00:00"
end_time=$(date -d "${end_date} -0 days" +%Y-%m-%d)" 00:00:00"



echo $start_time, $end_time

function sql_conversion_click_log()
{
/usr/bin/mysql \
        --default-character-set=utf8 \
        -h 192.168.156.120 \
        -u data -p'PIN239!@#$%^&8' \
        -D report \
        -e "SELECT DISTINCT pyid from conversion_click_log where request_time>'$start_time' and request_time<'$end_time'
            and advertiser_company_id='$companyid'" | grep -v "pyid" > all_conv.users
}

sql_conversion_click_log
CheckInModule "生成转化mysql"
echo "`date +%Y%m%d-%H:%M:%S`", "---- ----all_conv.users has ", `wc -l all_conv.users`, "lines" >>${RUNLOG}

############################################################################











#####################         Path Config      #############################
############################################################################
input_imp=/user/root/flume/express/{$str_date}/*/imp*
input_adv=/user/root/flume/express/{$str_date}/*/adv*
input_cvt=/user/root/flume/express/{$str_date}/*/cvt*

output_imp=/user/$LOGNAME/localmodel/offline_evaluation/${tagname}/${end_date}/imp
output_adv=/user/$LOGNAME/localmodel/offline_evaluation/${tagname}/${end_date}/adv
# output_union=/user/$LOGNAME/localmodel/offline_evaluation/${tagname}/${end_date}/union



############################################################################



#####################       Generate Data PigLatin   #########################
###############################################################################


function pig_imp_adv(){

echo input_imp=${input_imp}
echo input_adv=${input_adv}
echo companyid =${companyid}
echo output_imp=${output_imp}
echo output_adv=${output_adv}
# echo output_union=${output_union}
echo predict_pyids=${predict_pyids}



hadoop fs -test -e $output_imp
if [ $? -eq 0 ]; then
    hadoop fs -rm -r $output_imp
fi

hadoop fs -test -e $output_adv
if [ $? -eq 0 ]; then
    hadoop fs -rm -r $output_adv
fi

# hadoop fs -test -e $output_union
# if [ $? -eq 0 ]; then
#     hadoop fs -rm -r $output_union
# fi


    pig -D mapreduce.job.queuename=mapreudce.normal \
        -f ./Prepare_Data.pig \
        -param input_imp=${input_imp} \
        -param input_adv=${input_adv} \
        -param companyid=${companyid} \
        -param predict_pyids=$predict_pyids/part* \
        -param output_imp=${output_imp} \
        -param output_adv=${output_adv}
        # -param output_union=${output_union}


}

pig_imp_adv

CheckInModule "imp_adv生成pig"

############################################################################




# hget data from hdfs, to local path.

hadoop fs -cat $output_imp/part* | sort -k4nr >  $base_dir/imp_user.log

hadoop fs -cat $output_adv/part* | sort -k4nr  > $base_dir/adv_user.log

hadoop fs -cat $predict_pyids/part* | sort -k4nr  > $base_dir/union_user.log

# Split Data



#####################        Make Label      ###############################
############################################################################
# Match with previous data:  all_conv.users

python ./Make_Label.py

# sort

cat labeled_adv_user | sort -k3nr > labeled_adv_user.sort
cat labeled_union_user | sort -k3nr > labeled_union_user.sort
cat labeled_imp_user | sort -k3nr > labeled_imp_user.sort

python ./Recall_and_AUC.py  $tagname
############################################################################



