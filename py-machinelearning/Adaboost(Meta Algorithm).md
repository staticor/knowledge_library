
Meta Algorithms

----

如果有多种不同的分类器, 可以将他们组成到一起, 得到一种集成方法或者称之为元算法.


# bootstrap

自举法, 也称作bagging.

数据集D, 但手上有S个分类器, 若把D均分S份会太少. 换一思路, 把D"复制"多份.

若D的样本量为1000, 则每次从中有放回的抽取1000个形成新的数据集, D'.
如此操作S次就得到了S个和原来数据集"长得差不多"的. 将各自分类器加以应用, 以比较效果:

即每次选择分类器投票结果中最多的作为最终分类.

更多的bagging:

    * 随机森林 [random forest](www.stat.berkeley.edu/~breiman/RandomForests/cc_home.html)


# boosting

boosting 的分类结果来自于所有分类器的加权结果, 而非某一情况下的唯一的分类器.

boosting 的版本有很多: Adaboost, Logitboost

# Adaboost

adapt bossting 缩写, 自适应boosting

## steps

收集数据
准备数据(简单的弱分类器)
分析, 清洗
训练算法 - Adaboost 大多用于训练, 分类器多次在同一数据集上训练弱分类器
测试算法
使用算法


> 弱分类器, 效果比随机猜测好一点.  而强分类器则是一种错误率降低不少的分类器.


## weight

Adaboost 为每个分类器都分配了权重值 alpha, alpha来自于 每个弱分类器的错误率进行计算而来:
记 error为分类错误率

* alpha = .5 *  log( (1 - error)/error )

