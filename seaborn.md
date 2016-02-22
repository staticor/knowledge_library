
seaborn, 2015年时无意之中邂逅.
在blog中还写了篇[学习Notes](http://staticor.io/post/2015-06-10seaborn-distribution-plot?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)


如果你不知道matplotlib是什么? Google it. 或者当作是:

> Python数据制图的良品.

[Github](https://github.com/mwaskom/seaborn)

[MainPage](http://stanford.edu/~mwaskom/software/seaborn/)


# 单样本分布图


## 散点图 x - plot

下面先来看几个matplotlib画的示例图.


plt.plot:

    ![](http://i13.tietuku.com/59cd661720032656s.png)

plt.scatter:

    ![](http://i13.tietuku.com/41cd536fd1b8c7e1s.png)


##  分组图 x-group - plot



# 进阶内容 -- 环境 set

在matplotlib中可使用style来简单的一句式来配置matplotlib产生的图形主题.

```python
import matplotlib.pyplot as plt
from matplotlib import style
style.use('ggplot')
```
## set_style  主题 Theme 设置

* darkgrid
* whitegrid
* dark
* white
* ticks

## despine  用于坐标轴box四框的控制


## axes_style  临时主题

```
with sns.axes_style("darkgrid"):
    plt.subplot(211)
    sinplot()
plt.subplot(212)
sinplot(-1)
```

通过axes_style()可查看配置表(json \\ dict - file)
```

d = sns.axes_style()

from pprint import pprint

pprint(d)

sns.set_style("darkgrid", {"axes.facecolor": ".9"})
sinplot()
```


## set_context  设置图形中的元素

* set_context("paper")
* set_context("talk")
* set_context("poster")
* set_context("notebook")
