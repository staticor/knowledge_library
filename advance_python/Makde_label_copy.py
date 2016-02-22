#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: jinyongyang
# @Date:   2015-10-30 13:16:48
# @Last Modified by:   jinyongyang
# @Last Modified time: 2015-12-09 19:50:12
# @Usage:   根据 已经转化的人群对

import re

# cache 准备好的转化人群 -> memo
#

conv_users = set()

with open('conv.user', 'r') as f:

    for line in f.readlines():
        line = line.strip().split('\t')
        if len(line) < 1:
            continue
        conv_users.add(line[0])


def labeling(fromfile, tofile):
    '''
    fromfile:  existed data.
    tofile:    data to write in local.
    '''
    with open(tofile, 'w') as fd:
        with open(fromfile, 'r') as f:
            for line in f.readlines():
                line = re.split(r'[\s\t]+', line.strip())

                if len(line) < 2:
                    continue
                pyid, score = line[0], float(line[1])
                if pyid in conv_users:
                    print >> fd, pyid + "\t1\t" + str(score)
                else:
                    print >> fd, pyid + "\t0\t" + str(score)

# labeling('imp.user', 'test_from_imp_user')

