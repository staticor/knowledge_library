#!/usr/bin/python
# -*- coding:utf-8 -*-
# @Usage: python
#

from __future__ import print_function
import sys
import os
import time
import pandas


def computeAUC(filename, print_file=sys.stdout):
    '''
    Calculate AUC. input: filename.

    filename format: pyid -- label -- score.
    '''
    print("", file=print_file)
    print("=" * 80, file=print_file)
    print(time.ctime() + " AUC : " + filename, file=print_file)
    posnum = 0
    negnum = 0
    pospair = 0.0
    posdict = {}
    negdict = {}

    with open(filename, 'r') as fin:
        for line in fin.readlines():
            line = line.rstrip().split('\t')
            if len(line) < 3:
                continue

            pyid, label, score = line[:3]

            if int(label) > 0:
                posnum += 1
                posdict.setdefault(score, [])
                posdict[score].append(int(label))
            else:
                negnum += 1
                negdict.setdefault(score, [])
                negdict[score].append(int(label))

        for posscore in posdict.keys():
            for negscore in negdict.keys():
                if float(posscore) > float(negscore):
                    poslen = len(posdict[posscore])
                    neglen = len(negdict[negscore])
                    tmpnum = poslen * neglen
                    pospair += tmpnum
                if float(posscore) == float(negscore):
                    poslen = len(posdict[posscore])
                    neglen = len(negdict[negscore])
                    tmpnum = poslen * neglen
                    pospair += tmpnum * 0.5

    # print "posnum : ", posnum, "negnum : ", negnum
    # print "M * N = ", posnum * negnum
    # print "pospair : ", pospair
    AUC = float(pospair) / (posnum * negnum + 1)
    print("AUC : ", AUC, file=print_file)


def split_data(filename, print_file=sys.stdout):
    datasets = {}
    if 'imp_user.sort' in filename:
        tag = 'imp'
    elif 'adv_user.sort' in filename:
        tag = 'adv'
    elif 'union_user.sort' in filename:
        tag = 'union'
    else:
        print('>>>>>>>>>>>>>>>>>>>>file format valid. ', file=print_file)
        return

    print("", file=print_file)
    print("=" * 80, file=print_file)
    print(time.ctime(), file=print_file)
    with open(filename) as f:
        for line in f.readlines():
            elements = line.rstrip().split("\t")
            if len(elements) < 4:
                continue
            model, pyid, label, score = elements[:4]

            tail_line = '\t'.join(elements[1:]) + '\n'

            if model not in datasets:
                datasets[model] = set()

            # if tail_line not in datasets[model]:
            datasets[model].add(tail_line)

    names = ['pyid', 'label', 'score']
    for k in datasets:
        print("=" * 20 + "\t" * 2 + tag + "\t" + k +
              "\t" * 2 + "=" * 20, file=print_file)
        file_2_evaluate = 'splitted_' + tag + '_' + k
        with open(file_2_evaluate, 'w') as fw:
            fw.writelines(datasets[k])

        nrows = len(datasets[k])
        df = pandas.read_csv(
            file_2_evaluate, sep='\t', header=None, names=names)
        result = df.sort(['score'], ascending=False)

        i = 1000

        while i < nrows:
            occurrences = sum(result['label'][:i])
            print(
                '\t'.join([str(occurrences), str(i), str(float(occurrences) / i)]), file=print_file)
            i *= 2
        occurrences = sum(result['label'])
        print(
            '\t'.join([str(occurrences), str(nrows), str(float(occurrences) / nrows)]), file=print_file)
        computeAUC(file_2_evaluate, print_file=print_file)
        print("", file=print_file)
        print("=" * 80, file=print_file)
        print(time.ctime(), file=print_file)


if __name__ == '__main__':

    file_list = [f for f in os.listdir('.') if f.startswith(
        'labeled') and f.endswith('.sort')]

    print(file_list, file=sys.stdout)

    current_time = time.strftime('%Y%m%d%H%M', time.localtime())
    if len(sys.argv) > 1:
        tagname = sys.argv[1]
    else:
        tagname = "output_"

    current_time = tagname + current_time
    print(current_time, file=sys.stdout)

    for fname in file_list:
        if 'imp_user.sort' in fname:
            tag = 'imp'
        elif 'adv_user.sort' in fname:
            tag = 'adv'
        elif 'union_user.sort' in fname:
            tag = 'union'
        else:
            tag = 'other'

        split_data(fname, file(current_time + "_" + tag + ".result", 'a'))
