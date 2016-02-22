# -*- coding: utf-8 -*-
'''
Created on May , 2015
@author: stevey
'''

# 爬虫练习 url : http://www.taiwan-rc.com.cn/news/
#
import sys
import requests, json, re, string


url = "http://mss-oa.taikanglife.com/ybxq/ybxq_list.html"

r = requests.get(url)


d = json.loads(str(r.content), encoding='utf8')


print(d)