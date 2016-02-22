
# 我不喜欢爬虫的原因

我非常喜欢原创一些事情 - 因为我痛恨于只知道窃取别人的东西再经过"微创新"便是自己作品的做法.

所以一直以来我不喜欢去做爬虫方面的研究.



以 python + requests + beautifulSoup 为例

# 最简单的<爬虫代码>


```python3
    import requests
    r = requests.get('http://www.zhihu.com')
    print r.content
```

有兴趣的还是看看requests的API, 非常知名的一个项目.


# 高级爬虫1 requests + BeautifulSoup

通常来说 作为一只爬虫, 你要知道目标页的有用信息出现的特征, 从而做到像拿着手术刀的医生一样找到, 摄取.

示例网页如: http://www.111cn.net/phper/python/64923.htm, 目标为文章的标题.

```python3
    from bs4 import BeautifulSoup as bs
    url = 'http://www.111cn.net/phper/python/64923.htm'
    r = requests.get(url)
    soup = bs(r.content)
    print(soup.find('h1').string)
```

