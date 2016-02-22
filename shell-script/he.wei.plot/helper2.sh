#!/bin/sh
# @Author: Jinyong.Yang
# @Date:   2015-11-16 20:33:02
# @Last Modified by:   Jinyong.Yang
# @Last Modified time: 2015-11-16 21:08:34






function run_Mysql() {
/usr/bin/mysql \
       --default-character-set=utf8 \
        -h 192.168.144.237 \
        -u data -p'PIN239!@#$%^&8' \
        -D monitor \
        -e "
    select  scheduler_time_hour , count(id) as cnt, scheduler_owner as owner
    from  hdp_crontab_monitor_v2
    group by scheduler_time_hour, scheduler_owner
    order by owner        " > output.data
}

run_Mysql

python plot2.py output.data -dAgg
