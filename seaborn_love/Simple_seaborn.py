# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""


import matplotlib.pyplot as plt
from matplotlib import style
style.use('ggplot')
import random, re
import sys

print(sys.version)

foo = """
*   7895
0   1418
00  268
01  255
02  1909
03  2027
04  2392
05  1739
06  2661
07  2387
07,17   152
08  1573
08-23   164
09  935
09-22   80
1   1554
10  2393
11  1327
12  1364
12,16   106
13  560
14  848
15  819
16  669
17  750
18  501
19  709
2   923
2,18    9
20  642
21  1289
22  263
23  998
3   1335
4   1399
5   904
6   1458
7   2365
8   657
9   565
"""

oneday = [0] * 24

try:
    for line in foo.split("\n"):
        if len(line) < 2:
            continue
        else:
            hours, jobs = re.split(r"[\s\t]+", line)[:2]
            if ',' in hours:
                h1, h2 = hours.split(",")
                oneday[int(h1)] += int(jobs)
                oneday[int(h2)] += int(jobs)
            elif '-' in hours:
                begin, end = map(int, hours.split("-"))
                for i in range(begin, end+1):
                    oneday[i] += int(jobs)
            elif '*' == hours:
                for i in range(24):
                    oneday[i] += int(jobs)
            else:
                oneday[int(hours)] += int(jobs)

except Exception:
    pass
plt.xticks(range(24))
plt.plot(oneday)

import seaborn as sns

sns.set(palette="Set2")


# sns.tsplot(foo)
plt.show()
