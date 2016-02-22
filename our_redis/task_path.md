



# Input参数格式



task_path 用于数据入redis, 要求是第一次入库执行(或之前执行而失败)
输入参数包括: 入库数据的HDFS路径, 公司Id, 人群标识, 和描述信息.
由于新的规定要求, 在标识和描述不能出现非常直白的语言(要求具有对外的无法辨识性)

建议: 都使用 company_id 为区分 自己线下整理.

```
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
```

# 获取第一次人群编号 -- uniqe_code

人群表在239的optimus, 表名: advertiser_audience_classify

```
table=`mysql --default-character-set=utf8 -h 192.168.144.239 -u data -p'PIN239!@#$%^&8' -D optimus -e "SELECT max(unique_code+1) FROM advertiser_audience_classify where unique_code < 600000;"`
redis_code=`echo $table | awk '{print $2;}'`
echo $redis_code
```
