Naïve Bayes
-------


    Naïve Bayes(下简称NB)可作为ML新人先去掌握(或者说了解)的model, 之于其简单, 之于其直观.


core:

    use probability distribution for classification

    利用概率分布进行分类

classification:

    tell me which class does the instance belong to ?

background:
    Pros: works with a small of data, handles multiple classes
    Cons: sensitive to how the input is prepared
    with: Nominal Values


knowledgebase:

![](http://i12.tietuku.com/d06173caf1a59d6ds.png)

a classifer is simple, goes:

If (x, y) have distribution with p as its density Distribution, we can make the p() function as a tool to distinguish two classes:

> If p1(x, y) > p2(x, y), then the class is 1.

> If p2(x, y) > p1(x, y), then the class is 2.


conditional probability:

![](http://i13.tietuku.com/9dea23c911812836s.png)

    p(x, y|c)



Instance:

    * Document classification

    * Detect Spam Mails



Apply:

> 我曾经见过有人使用NB从他喜欢及不喜欢的女性社交网络Profile中学习相应的分类器, 然后利用该分类器测试他是否会喜欢一个陌生女人.




