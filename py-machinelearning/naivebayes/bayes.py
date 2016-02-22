#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Jinyong.Yang
# @Date:   2015-11-12 01:23:19
# @Last Modified by:   Jinyong.Yang
# @Last Modified time: 2015-11-13 13:36:24


from numpy import *
from collections import Counter


def loadDataset():
    postingList = [
        ['my', 'dog', 'has', 'flea', 'problems', 'help', 'please'],
        ['maybe', 'not', 'take', 'him', 'to', 'dog', 'park', 'stupid'],
        ['my', 'dalmation', 'is', 'so', 'cute', 'I', 'love', 'him'],
        ['stop', 'posting', 'stupid', 'worthless', 'garbage'],
        ['mr', 'licks', 'ate', 'my', 'steak', 'how', 'to', 'stop', 'him'],
        ['quit', 'buying', 'worthless', 'dog', 'food', 'stupid'],
    ]

    # 0: normal, 1: insulting
    classVec = [0, 1, 0, 1, 0, 1]

    return postingList, classVec


def creatVocabList(dataset):
    '''
    get all words in doc (one word once)
    '''
    vocabSet = set([])
    for doc in dataset:
        vocabSet = vocabSet | set(doc)

    return list(vocabSet)


def setOfWords2Vec(vocablist, inputSet):
    returnVec = [0] * len(vocablist)
    for word in inputSet:
        if word in vocablist:
            returnVec[vocablist.index(word)] = 1
        else:
            # new word
            print("the word %s is not in my Vocabulary!" % word)

    return returnVec


def trainNB0(trainMatrix, trainCategory):
    numTrainDocs = len(trainMatrix)
    numWords = len(trainMatrix[0])
    pAbusive = sum(trainCategory) / float(numTrainDocs)
    p0Num = zeros(numWords)
    p1Num = zeros(numWords)
    p0Denom = 0.0
    p1Denom = 0.0

    for i in range(numTrainDocs):
        if trainCategory[i] == 1:
            # "postive" sample
            p1Num += trainMatrix[i]
            p1Denom += sum(trainMatrix[i])
        else:

            p0Num += trainMatrix[i]
            p0Denom += sum(trainMatrix[i])

    p1Vect = p1Num / p1Denom
    p0Vect = p0Num / p0Denom
    return p0Vect, p1Vect, pAbusive


# Naive Bayes Classfier

def classifyNB(vec2Classify, p0Vec, p1Vec, pClass1):
    p1 = sum(vec2Classify * p1Vec) + log(pClass1)
    p0 = sum(vec2Classify * p0Vec) + log(1.0 - pClass1)
    if p1 > p0:
        return 1
    else:
        return 0


def testingNB():
    listOPosts, listClasses = loadDataset()
    myVocabList = creatVocabList(listOPosts)
    trainMat = []
    for postDoc in listOPosts:
        trainMat.append(setOfWords2Vec(myVocabList, postDoc))
    p0V, p1V, pAb = trainNB0(array(trainMat), array(listClasses))

    testEntry = ['love', 'my', 'dalmation']
    thisDoc = array(setOfWords2Vec(myVocabList, testEntry))
    print(testEntry, 'classified as: ', classifyNB(thisDoc, p0V, p1V, pAb))
    testEntry = ['stupid', 'garbage']

    thisDoc = array(setOfWords2Vec(myVocabList, testEntry))
    print(testEntry, 'classified as: ', classifyNB(thisDoc, p0V, p1V, pAb))


def bagOfWords2VecMN(vocalList, inputSet):
    returnVec = [0] * len(vocalList)
    for word in inputSet:
        if word in vocalList:
            returnVec[vocalList.index(word)] += 1
    return returnVec


def textParse(bigString):
    '''
    use to split long string into tokens.
    '''
    import re
    listOfTokens = re.split(r'\W*', bigString)
    return [tok.lower() for tok in listOfTokens if len(tok) >= 3]


def spamTest():
    import random
    docList = []
    classList = []
    fullText = []
    wordList = textParse(open('./spam.md').read())
    docList.append(wordList)
    fullText.extend(wordList)
    classList.append(1)
    wordList = textParse(open('./ham.md').read())
    docList.append(wordList)
    fullText.extend(wordList)
    classList.append(0)
    vocabList = creatVocabList(docList)
    trainingSet = range(50)
    testSet = []
    for i in range(10):
        randIndex = int(random.uniform(0, len(trainingSet)))
        testSet.append(trainingSet[randIndex])
        del trainingSet[randIndex]
    trainMat = []
    trainClasses = []
    for docIndex in trainingSet:
        trainMat.append(setOfWords2Vec(vocabList, docList[docIndex]))
        trainClasses.append(classList[docIndex])
    p0V, p1V, pSpam = trainNB0(array(trainMat), array(trainClasses))
    errorCount = 0
    for docIndex in testSet:
        wordVector = setOfWords2Vec(vocabList, docList[docIndex])
        if classifyNB(array(wordVector), p0V, p1V, pSpam) != classList[docIndex]:
            errorCount += 1
    print('the error rate is : ', float(errorCount)/len(testSet))




if __name__ == '__main__':
    postingList, classVec = loadDataset()
    # make a word into a vector.

    vocabList = creatVocabList(postingList)
    trainMat = []

    for postin in postingList:
        trainMat.append(setOfWords2Vec(vocabList, postin))

    p0V, p1V, pAb = trainNB0(trainMat, classVec)

    print(pAb)

    # any doc probability of abusive
    print(p0V)

    testingNB()
