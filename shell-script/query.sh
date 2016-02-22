#!/bin/sh
# @Author: Jinyong.Yang
# @Date:   2015-11-12 10:48:41
# @Last Modified by:   Jinyong.Yang
# @Last Modified time: 2015-11-12 10:56:08


# used for query: companyid and adv_name
#
advertiser_id=$1

function run_Mysql()
{
 /usr/bin/mysql \
    --default-character-set=utf8 \
    -h 192.168.156.120 \
    -u data -p'PIN239!@#$%^&8' \
    -D optimus \
    -e"
    SELECT company_id, NAME FROM optimus.advertiser a
    WHERE id = ${advertiser_id}
" > query.data
}

run_Mysql;


compid=`cat query.data |awk  'BEGIN{FS=OFS="\t"}  NR == 2 {print $1}'`
tagname=`cat query.data |awk  'BEGIN{FS=OFS="\t"}  NR == 2 {print $2}'`

echo $compid
echo $tagname

echo " you are best. ! "
