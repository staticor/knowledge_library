# spark 入门doc

这是一篇@staticor读书|学习的LearnNote.

其中代码Sample多来自于两个本书:  <Learn Spark>  <Scala for the Impatient>

## 初识

* 安装
    安装步骤比较简单, 下载和解压. 根据是否需要hadoop集成, 选择适合的.


> Download and Unpck

> Visit http://spark.apache.org/downloads.html, select the package type of “Pre-built for Hadoop 2.4 and later,” and click “Direct Download.” This will download a compressed TAR file, or tarball, called spark-1.2.0-bin-hadoop2.4.tgz.

```shell
cd SPARK_DOWNLOAD_PATH
tar -xf spark-1.2.bin-hadoop2.4.tgz
cd spark-1.2.bin-hadoop2.4
ls
```

* 初识

在解压目录中, 有些文件值得一提:

    - README.md

        spark上手指引文档, 建议一看.

    - bin

        Spark 相关的诸多可执行文件 (如Spark-Shell).

    - core, streaming, python, ....

        spark核心组件部分

    - examples

        可用来学习SparkAPI的有用案例.

        当然, 如果是有经验的开发者, 可以直接从这里开始.

        [quickstart](http://spark.apache.org/docs/latest/quick-start.html)

* Python Shell & Scala Shell

默认情况, 是执行的Scala 环境的

`./bin/spark-shell`

这是因为**论scala与spark的亲昵关系, 非同一般**.

笔者更喜欢Python, 故要执行:

`./bin/pyspark`

如果你听说过IPYTHON, 也可以这样:

`IPYTHON=1 ./bin/pyspark`


显示效果为:

![](http://img-storage.qiniudn.com/15-11-6/24856260.jpg)


shell环境由于简单, 不考虑hdfs环境参数, 因此适合新手的入门工具.  SparkContext均使用默认构造.

SparkContext available as sc.


## RDD


在Spark中, 最小的计算单元为分区, 而若干分区组成的RDD( resilient distributed datasets)才是我们处理的逻辑单位-- 弹性分布数据集.

下面以pyspark为例为看一些RDD简单操作:

```

In [1]: myrdd = sc.parallelize(range(1500))

In [2]: dir(myrdd)

In [3]: newrdd = myrdd.map(lambda x: min(x, 15))

In [4]: newrdd.take(50)

```

RDD一般来说可由内存, 外部存储文件来创造; 或者是由已有的RDD通过转换(transform)得到. 常用的内部创造方式有

    * sc.parallelize, 指定数据对象, 还可以指定分区的个数.

        `rdd = sc.parallelize([1,2,3,4,5])`

    * sc.textFile

        `lines = sc.textFile("README.md")`

带着函数式编程的理念, 可以通过`dir`方法来查看一个普通rdd对象应有的操作. 例如:
    - rdd的属性方法

        id, name, partitions


    - 单rdd操作

        * setName()  给rdd对象起个标识名
        * sortBy() 排序
        * take()  取rdd部分对象, 有时也可以使用top(), first() 进行快速查看.
        * map()   变换函数  常常通过lambda函数, 变换得到其它rdd
        * sum()   求和, 其它统计函数: min, max, mean
        * stdev() 标准差, 方差为 variance()
        * sample() 抽样操作, 返回原rdd的一个"子集", 可指定是否有放回.
        * count()  计数, rdd的容量.
        * filter() 过滤函数, 同样传入true-false判断函数.


    - 多rdd操作
        一般而言, 是通过两个rdd的集合操作迭代更新成一个新的rdd.
        常用的rdd运算自然就能想到, 并交差.

        * union  取两个rdd的并集
        * intersection 交集
        * subtract 两个rdd减法运算

RDD的分区(partition)是其重要属性, 以后提到的RDD间依赖关系就要取决于父子间的分区对应关系.



## Spark Core

Shell的方式能让我们快速Glance.  但也要对一些重要的事情有所掌握.


* SparkContext (sc)

    SparkContext 用于表示面向集群的spark接口对象.

```
    In [29]: sc
    Out[29]: <pyspark.context.SparkContext at 0x104c89610>

```

Context能当成是一个rdd出生的平台 -- 缘于此, sc.textFile()就是在此平台上基于某个文件生成一个简单rdd的过程.


> 以count()为例来理解 driver programs的内在

> 在集群上运行 **count()** 时, 不同的机器会分别处理文件的不同行. (因为Shell相当于local mode, 所以是单一机器). 每个执行的节点被称为 **executors**(执行者).

![](http://img-storage.qiniudn.com/15-11-7/17617131.jpg)

> 接着, Spark的API将会传递要执行的函数.


## ShortCases

下面来用列举一些简单的例子:
IPython
```
In [30]: lines = sc.textFile("README.md")
In [31]: pythonLines = lines.filter(lambda line: "python" in line.lower())
In [32]: pythonLines.first()
```

```scala
scala>  var lines = sc.textFile("README.md")
scala>  var pythonLines = lines.filter(line => line.contains("Python"))
scala>  pythonLines.first()
```

以上在filter里参数就是lambda型的匿名函数. 若要指名操作, 则須事先定义:

> python

```python
def has_python(line):
    return "Python" in line
```

## Standalone Applications

如果自己做好SparkContext的初始化工作, 那么接下来的事情(Java, Scala, Python 这些API的使用)在Shell交互还是standalone程序中的操作是一样的.


* Java的Maven管理

```
groupId = org.apache.spark
artifactId = spark-core_2.10
version = 1.2.0
```


* Python script

在Python下, 须准备Python脚本, 用`./bin/spark-submit`来完成python脚本文件的提交.

```
bin/spark-submit my_script.py
```



### SparkContext的初始化

```python
from pyspark import SparkConf, SparkContext

conf = SparkConf().setMaster("local").setAppName("Hello World")
sc = SparkContext(conf=conf)
```

初始化要准备的几个参数:


* cluter URL

    local相当于在本地执行的一个线程, 没有做集群的连接. 一般情况是要指定Spark与集群的连接.

* app Name

    Hello World 用于识别集群管理器上运行的诸多application.




-------------------------------------------------------------------------------


#  know more about RDD

Spark 的基础处理数据对象 -- RDD, 后面能够看到Spark的工作就是围绕着若干RDD: 创建新的RDD, RDD间的转换, RDD产出结果.

尽管前面稍稍地提到了一些RDD的方法, 但还是希望这一章能再准确系统的介绍RDD.


## 分区

> Each RDD is split into multiple partitions, which may be computed on different nodes of the cluster.

## create

创建RDD的两种方法

* 读取外部文件
    sc.textFile(path, 默认分区个数)
    sc.hadoopFile()
* 从内存中(临时)
    sc.parallelize
* RDD 变换      ex: rdd.filter rdd.map





## actions & transformations

Actions 是用来计算现有的RDD, 生成一个具体的结果. Transformation 则是用来完成RDD的迭代-- 从一个现有的RDD通过函数式编程得到新的RDD.






> actions list:

* first()
    返回RDD的第一个元素. 提示: Spark处理RDD时只须提取第一个节点是的第一个元素, 无须使用textFiles读取全部的数据再操作.

* persist
    持久化. RDD经过actions之后, 将数据先存起来, 为将来使用作准备.
例如之前的 经过filter得到的 pythonLines
    提示: cache() 类似于 persist().

```
pythonLines.persist   # pythonLines.cache()

pythonLines.count()

pythonLines.first()
```

> transforms list:

* map()
    类似于Python中map.    mped = lines.map(lambda x: str(x).lower())

* distinct()
    元素去重

* filter()
    类似于Python中filter. flred = lines.filter(lambda x: "error" in x)

* flatMap
    map进行一对一的, 用flatMap得到一对多的.

* reduceByKey()
    用于 key-value型的 RDD, 根据相同key的对象用reduceByKey 指定的方法来聚合.

* repartition()
    从分区

## RDD - example

找出包含单词最多的行. 也是一个简单的map-reduce的实现
```python
textFile.map(lambda line: len(line.split())).reduce(lambda a,b : a if (a>b) else b)
```

```scala
textFile.map(line => line.split(" ").size).reduce( (a,b) => if(a>b) a else b)
```


Hadoop常见的MapReduce, Spark实现:

```scala
val wordCounts = textFile.flatMap(line => line.split(" ")).map(word => (word, 1)).reduceByKey((a, b) => a + b)
```

```python
wordCounts = textFile.flatMap(lambda line: line.split()).map(lambda word: (word, 1)).reduceByKey( lambda a, b: a + b)
```



## 第一个spark应用

来尝试用python api (pyspark)编写一个独立应用.


wordCount

```

import sys
from operator import add

from pyspark import SparkContext


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print >> sys.stderr, "Usage: wordcount <file>"
        exit(-1)
    sc = SparkContext(appName="PythonWordCount")
    lines = sc.textFile(sys.argv[1], 1)
    counts = lines.flatMap(lambda x: x.split(' ')) \
                  .map(lambda x: (x, 1)) \
                  .reduceByKey(add)
    output = counts.collect()
    for (word, count) in output:
        print "%s: %i" % (word, count)

    sc.stop()
```