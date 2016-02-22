#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Jinyong.Yang
# @Date:   2015-11-16 20:33:20
# @Last Modified by:   Jinyong.Yang
# @Last Modified time: 2015-11-16 21:19:10


import sys
import re
from matplotlib import pyplot as plt
from matplotlib import style
import matplotlib
from collections import OrderedDict

matplotlib.use('Agg')
style.use('ggplot')

if len(sys.argv) < 2:
    sys.exit(1)
else:
    filename = sys.argv[1]

data_to_plot = [0] * 24


def each_owner(hour, count, data_to_plot=data_to_plot):
    count = int(count)
    if ',' in hour:
        a, b = map(int, hour.split(','))
        data_to_plot[a] += count
        data_to_plot[b] += count
    elif '-' in hour:
        a, b = map(int, hour.split('-'))
        for i in range(a, b + 1):
            data_to_plot[i] += count
    elif '*' == hour:
        for i in range(24):
            data_to_plot[i] += count

    else:
        try:
            a = int(hour)
            data_to_plot[a] += count
        except Exception as ex:
            print(ex)

    # return data_to_plot


def plot(title, data, savename):
    plt.title(title)
    plt.figure(figsize=(10, 8))
    plt.subplot(111)
    plt.xkcd()
    plt.plot(data_to_plot)
    plt.xticks(range(24))
    plt.savefig(savename)

last_owner = ""
if __name__ == '__main__':
    data_to_plot = [0] * 24
    with open(filename, 'r') as f:
        for idx, line in enumerate(f.readlines()):
            print(line)
            if idx == 0 or '/' in line:
                continue

            hour, count, owner = re.split(r'\s+', line.rstrip())[:3]

            if owner != last_owner and last_owner != '':
                print(idx, last_owner, '@'.join( map(str, data_to_plot)), )
                plot(last_owner, data_to_plot, last_owner.split(".")[0]+'.jpg')
                data_to_plot = [0] * 24

            else:
                each_owner(hour, count, data_to_plot)
                # parse hour
            last_owner = owner
    # plot

