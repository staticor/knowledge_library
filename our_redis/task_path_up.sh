#! /bin/sh
# Script Name : task_path_up.sh "/data/jiewei.wang/jd/shuaixi/laorenshouji_pyid" "1" "old phone" "cnt:2144743" 
# Description : 获得路径下cookie，进行定向。 自动获取max_code+1的编码
#       Usage :
#     Example : 
#      Author : jingbo.han
#      Create : 2013-07-29
#     Modifie : pyid必须放在path的第一列
#
#---------------------------------------------------------------------------

export LANG="en_US.UTF-8"  #本地crontab 在执行shell时没有引入用户环境变量,所以加上该代码

#-------------------------------------------------------------------
# initialize globle variable
#------------------------------------------------------------------- 
if [ "${#@}" != 5 ];then
        echo "Error : $(basename $0) 请输入5个参数：path redis_code companyId name discribe"
        exit
fi

path=$1
redis_code=$2
company=$3
name=$4
discribe=$5


ROOTDIR=/hadoop/datatoredis
HDFS_ROOT="/tmp/cookie_target"
classfy_online=/production/people_classfy/active
LOGDIR="${ROOTDIR}/runlog"
FILENAME=$(basename $0)
mkdir -p ${LOGDIR}
RUNLOG="${LOGDIR}/${FILENAME}.runlog"

echo $redis_code

curday=`date +%Y-%m-%d_%H%M%S`
preday=`date -d "-1 day" +%Y%m%d`

#判断更新的code是否存在
table=`mysql --default-character-set=utf8 -h 192.168.144.239 -u data -p'PIN239!@#$%^&8' -D optimus -e "SELECT unique_code FROM advertiser_audience_classify where unique_code='$redis_code' and removed=0"`
redis_code_check=`echo $table | awk '{print $2+0;}'`
echo $redis_code_check
if [ $redis_code_check == "0" ];then
        echo "error : ${redis_code} not exist" 
        exit
fi

#---------------------------------------------------------------
# initialize function
#---------------------------------------------------------------
log(){
        echo "`date +%Y%m%d-%H:%M:%S` :  $@" >> ${RUNLOG}
}

BeginRunning(){
        echo "`date +%Y%m%d-%H:%M:%S` : ====== BEG $preday =======================================" >> ${RUNLOG}
}

EndRunning(){
        echo "`date +%Y%m%d-%H:%M:%S` : ====== END ==================================================" >> ${RUNLOG}
        echo "`date +%Y%m%d-%H:%M:%S`" >> ${RUNLOG}
}
email(){
        return=$?
        error_desc=$1  #邮件错误内容描述
        flag=$2         #指令返回判断标志，$?为0正常、$?不为0异常
        if [ -z "$flag" ];then
                flag=0
        fi
        if [ $return != $flag ];then
#                /data/production/ToolCommon/sendmail.sh -m -t "$ROOTDIR ,$FILENAME, error" \
#                        -u "jingbo.han@ipinyou.com" \
#                        -c "`date +%Y%m%d-%H:%M:%S` :  running ${ROOTDIR}/$FILENAME $path $company $redis_code, $error_desc,failed"
                echo "running ${ROOTDIR}/$FILENAME  $path $company $redis_code,  $error_desc ,failed , exit ......" >> ${RUNLOG}
                exit
        fi
}

BeginRunning
#---------------------------------------------------------------
# 获得pyid 进行入库
#---------------------------------------------------------------
log " running : $path $company $redis_code cookie_path.pig"
	
redis_pyid=$HDFS_ROOT/$curday
p_redis_code=$redis_code
echo $p_redis_code
echo $dayPath

/usr/bin/pig -D mapred.job.queue.name=mapreduce.normal -f ${ROOTDIR}/cookie_path.pig \
        -param path=$path/$day \
	-param redis_pyid=$redis_pyid  \
	-param redis_code=$p_redis_code
email "${ROOTDIR}/cookie_path.pig , error"

#判断pyid输入是否正常 pyid为\t分割取第一列
flag=`hadoop fs -text $redis_pyid/p* | awk 'BEGIN{FS=OFS="\t"}NR==10{split($1,a," ");print length(a);}'`
echo $flag
if [ $flag != "1" ];then
        echo "error : ${path} 第一列pyid异常"
        exit
fi

#---------------------------------------------------------------
# 入redis
#---------------------------------------------------------------
DATA_PATH=/hadoop/datatoredis/new
mkdir ${DATA_PATH}/$redis_code

log "running : into redis"
echo "hadoop fs -cat $redis_pyid/part* > ${DATA_PATH}/$redis_code/$curday"
hadoop fs -cat $redis_pyid/part* > ${DATA_PATH}/$redis_code/$curday
cnt=`cat ${DATA_PATH}/$redis_code/$curday | wc -l`
if [ $cnt == 0 ];then
        echo "error : ${DATA_PATH}/$redis_code/$curday" is no data 
        exit
fi

all_cnt=`cat ${DATA_PATH}/$redis_code/* | sort | uniq | wc -l`
#discribe="${discribe} 入库数量:${cnt} 累计去重入库数量:${all_cnt}"
discribe="入库数量:${cnt} 累计去重入库数量:${all_cnt}"
name="${name} 入库数量:${cnt} 累计去重入库数量:${all_cnt}"

#将入库pyid放到新版本入库指定hadoop目录
hadoop fs -mkdir -p ${classfy_online}/$redis_code
hadoop fs -put ${DATA_PATH}/$redis_code/$curday ${classfy_online}/$redis_code/$curday
if [ $? == 0 ];then
	echo "......放入redis目录......成功"
	mysql --default-character-set=utf8 -h 192.168.144.239 -u data -p'PIN239!@#$%^&8' -D optimus -e "UPDATE advertiser_audience_classify set last_modified=SYSDATE(), remark='$discribe', name='$name' where unique_code='$redis_code'; UPDATE advertiser_audience_classify set remark='' where unique_code='0113' or unique_code='0114' or unique_code='0115';"
	echo "......插入mysql数据库......成功"
fi
	SYSDATE=`date +%Y%m%d-%H:%M:%S`
#	java -cp /data/production/ToolCommon/sendmailudf:/data/production/ToolCommon/sendmailudf/* com.ipinyou.sendmail.Send "人群定向自动化入库：$name $redis_code , success..." "$SYSDATE , companyId:$company , name:$name , redis_code:$redis_code , $discribe" zhao.lin@ipinyou.com,jingbo.han@ipinyou.com,yingnan.ma@ipinyou.com,ping.chen@ipinyou.com,jinliang.song@ipinyou.com,man.liu@ipinyou.com,yangchun.sheng@ipinyou.com,xinle.li@ipinyou.com,yongyan.li@ipinyou.com,hairenliao@gmail.com

#---------------------------------------------------------------
# 针对入库量<800万 自动入redis
#---------------------------------------------------------------
if [ $cnt -le 8000000 ];then
        sh $ROOTDIR/insert_redis.sh ${classfy_online}/$redis_code/$curday
        if [ $? == 0 ];then
                echo "......执行入redis......成功"
        fi
fi

EndRunning

