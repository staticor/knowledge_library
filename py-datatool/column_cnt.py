#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Jinyong.Yang
# @Date:   2015-11-12 19:46:20
# @Last Modified by:   Jinyong.Yang
# @Last Modified time: 2015-11-12 19:55:25
# @example: python column_cnt.py foobar.txt 2

import sys
from collections import Counter

if __name__ == '__main__':

    sep = "\t"

    if len(sys.argv) < 1:
        filename = 'foobar.dat'
    elif len(sys.argv) >= 1:
        filename = sys.argv[1]
        if len(sys.argv) >= 2:
            col_number = int(sys.argv[2])

    counter = Counter()

    with open(filename, 'r') as f:
        for line in f.readlines():
            line = line.rstrip().split(sep)
            if len(line) < 2:
                continue
            counter[line[col_number - 1]] += 1

    print(counter.most_common(20))

