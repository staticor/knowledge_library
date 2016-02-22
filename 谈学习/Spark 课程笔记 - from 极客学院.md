 Spark 课程笔记 - from 极客学院

# spark开发环境


Intellij (Windows, Mac)
	 - 创建一个Scala项目
SBT
Scala
引Jar包


# spark 计算模型

* spark的程序示例

下面小例简述了spark程序流的操作过程: 

```
// from input, make RDD
val file = sc.textFile("hdfs:// ... ")

// Transformation
val errors = file.filter(line => line.contains("ERROR"))

// Action
errors.count()
```

> 核心: 数据结构RDD + 算法


* RDD 

RDD属性包括

	- partition
	- compute 
	- dependencies  (一个RDD 经 map, filter, groupby, 各RDD间的依赖关系)
	- partitioner  (默认hash或范围分区算法)
	- preferredLocations (HDFS 一个可选的属性)

	
RDD的两类基础用法

	- Transformation
	延迟计算

1. map(func)   对数据集每个元素都使用func, 返回新的RDD
2. filter(func) 对数据集每个元素都使用func, 返回一个包含使func为true的元素 构成的RDD.
3. reducebyKey(func)
	
	- Action
	
	触发spark-submit 输出数据

1. reduce(func)    传入两个参数, 返回一个值, 满足交换律, 结合律的操作
2. collect
3. count()    返回个数
4. first()    返回第一个元素
5. take(n)    返回前n个


