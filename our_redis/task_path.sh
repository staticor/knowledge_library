#! /bin/sh
# Script Name : task_path.sh "/data/jiewei.wang/jd/shuaixi/laorenshouji_pyid" "1" "old phone" "cnt:2144743"
# Description : 获得路径下cookie，进行定向。 自动获取max_code+1的编码
#       Usage :
#     Example : task_main.sh path companyId name discribe
#      Author : jingbo.han
#      Create : 2013-07-29
#     Modifie : pyid必须放在path的第一列
#
#---------------------------------------------------------------------------

#-------------------------------------------------------------------
# 该程序只允许一个进程调用
#-------------------------------------------------------------------
shell_name=`echo $0 | awk '{print $1}'`
echo `ps aux | grep $shell_name | grep -v grep`

num_p=`ps aux | grep $shell_name | grep -v grep | wc -l`
echo $shell_name  $num_p

if [ $num_p -ge 3 ]
then
  echo "Exist multiple processes, exit"

  exit -1
else
  echo "Only one process, continue"
fi


#-------------------------------------------------------------------
# initialize globle variable
#-------------------------------------------------------------------
if [ "${#@}" != 4 ];then
        echo "Error : $(basename $0) 请输入4个参数：path companyId name discribe"
        exit -1
fi

path=$1
company=$2
name=$3
discribe=$4


ROOTDIR=/hadoop/datatoredis
HDFS_ROOT="/tmp/cookie_target"
classfy_online=/production/people_classfy/active
LOGDIR="${ROOTDIR}/runlog"
FILENAME=$(basename $0)
mkdir -p ${LOGDIR}
RUNLOG="${LOGDIR}/${FILENAME}.runlog"

table=`mysql --default-character-set=utf8 -h 192.168.144.239 -u data -p'PIN239!@#$%^&8' -D optimus -e "SELECT max(unique_code+1) FROM advertiser_audience_classify where unique_code<600000;"`
redis_code=`echo $table | awk '{print $2;}'`
echo $redis_code

#新code进行预清理
sh $ROOTDIR/task_delete.sh $redis_code "0"

curday=`date +%Y-%m-%d_%H%M%S`
preday=`date -d "-1 day" +%Y%m%d`

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
                exit -1
        fi
}

BeginRunning
#---------------------------------------------------------------
# 获得pyid 进行入库
#---------------------------------------------------------------
log " running : $path $company $redis_code cookie_path.pig"

redis_pyid=$HDFS_ROOT/$curday
#hadoop fs -mkdir -p $redis_pyid
#hadoop fs -rmr $redis_pyid

p_redis_code=$redis_code
echo $p_redis_code
echo $dayPath

/usr/bin/pig -D mapred.job.queue.name=mapreduce.normal -f ${ROOTDIR}/cookie_path.pig \
        -param path=$path \
	-param redis_pyid=$redis_pyid  \
	-param redis_code=$p_redis_code
email "cookie_path.pig , error"

#判断pyid输入是否正常 pyid为\t分割取第一列
flag=`hadoop fs -text $redis_pyid/p* | awk 'BEGIN{FS=OFS="\t"}NR==10{split($1,a," ");print length(a);}'`
echo $flag
if [ $flag != "1" ];then
        echo "error : ${path} 第一列pyid异常"
        exit -1
fi

#---------------------------------------------------------------
# 入redis目录
#---------------------------------------------------------------
DATA_PATH=/hadoop/datatoredis/new
mkdir ${DATA_PATH}/$redis_code

log "running : into redis hdfs"
hadoop fs -cat $redis_pyid/part* > ${DATA_PATH}/$redis_code/$curday
cnt=`cat ${DATA_PATH}/$redis_code/$curday | wc -l`
if [ $cnt == 0 ];then
	echo "${DATA_PATH}/$redis_code/$curday" is no data
	exit -1
fi

#discribe="${discribe} 入库数量:${cnt}"
discribe="入库数量:${cnt}"
name="${name}  入库数量:${cnt}"


#将入库pyid放到新版本入库指定hadoop目录
hadoop fs -mkdir -p ${classfy_online}/$redis_code
hadoop fs -put ${DATA_PATH}/$redis_code/$curday ${classfy_online}/$redis_code/$curday
if [ $? == 0 ];then
	echo "......放入redis目录......成功"
	mysql --default-character-set=utf8 -h 192.168.144.239 -u data -p'PIN239!@#$%^&8' -D optimus -e "INSERT INTO advertiser_audience_classify VALUES ('null', 1, SYSDATE(), SYSDATE(), '$company', '$name', '$redis_code', 1, 0, '$discribe', 0, NULL)"
	email "......插入mysql数据库......失败"
	echo "......插入mysql数据库......成功"
fi
	SYSDATE=`date +%Y%m%d-%H:%M:%S`
#	java -cp /data/production/ToolCommon/sendmailudf:/data/production/ToolCommon/sendmailudf/* com.ipinyou.sendmail.Send "人群定向自动化入库：$name $redis_code , success..." "$SYSDATE , companyId:$company , name:$name , redis_code:$redis_code , $discribe" zhao.lin@ipinyou.com,jingbo.han@ipinyou.com,yingnan.ma@ipinyou.com,ping.chen@ipinyou.com,ts@ipinyou.com,jinliang.song@ipinyou.com,yangchun.sheng@ipinyou.com,xinle.li@ipinyou.com,yongyan.li@ipinyou.com

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

