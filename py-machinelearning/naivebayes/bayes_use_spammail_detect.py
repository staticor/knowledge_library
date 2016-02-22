#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: Jinyong.Yang
# @Date:   2015-11-12 20:33:22
# @Last Modified by:   Jinyong.Yang
# @Last Modified time: 2015-11-12 20:37:07


import bayes, re


mySent = "This book is the best book on Python Programming about Machine Learning. I have ever laid eyes upon."

words = re.split(r"\W", mySent)

# optimize
words = [w.lower() for w in words if len(w) > 0]
print(words)

