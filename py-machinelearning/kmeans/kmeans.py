#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Jinyong.Yang
# @Date:   2015-11-15 00:45:56
# @Last Modified by:   Jinyong.Yang
# @Last Modified time: 2015-11-15 01:00:47


from numpy import *

def loadDataSet(fileName):
    dataMat = []
    with open(fileName) as fr:
        for line in fr.readlines():
            curLine = line.strip().split("\t")
            fitLine = map(float, curLine)
            dataMat.append(fitLine)
    return dataMat

def distEclud(va, vb):
    return sqrt(sum(power(va - vb, 2)))


def randCent(dataSet, k):
    n = shape(dataSet)[1]
    centroids = mat(zeros((k, n)))
    for j in range(n):
        minJ = min(dataSet[:, j])
        rangeJ = float(max(dataSet[:, j]) - minJ)
        centroids[:, j] = minJ + rangeJ * random.rand(k, 1)
    return centroids

