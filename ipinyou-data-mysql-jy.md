 这是@jinyong随心整理的自己mysql reference,
                        可能是常用的\\冷言冷语的mysql片段.


# CLI 还是GUI

    喜欢折腾的可以去看这个命令行工具 http://mycli.net

    我个人为了省事使用了Sequel Pro.


# advertiser

```mysql
    -- 查看当前广告主的投放Mode
    SELECT advertiser_id, GROUP_CONCAT(DISTINCT MODE) AS adv_mode
    FROM (
        SELECT DISTINCT ra.advertiser_id,
    (CASE   WHEN rs.ad_unit_types = 'Video' THEN '视频'
            WHEN rs.ad_unit_types = 'Banner,Video' THEN   '视频'
            WHEN rs.advertising_mode = 'Mobile' THEN  '移动'
            WHEN rs.advertising_mode = 'Desktop' THEN  'PC'
                     ELSE NULL END) AS MODE
    FROM checklist_starred ra, reportdb.ad_order ro, reportdb.campaign rc, reportdb.strategy rs
    WHERE ra.advertiser_id = ro.advertiser_id AND ro.id = rc.order_id AND rc.id = rs.campaign_id  AND rc.active = 1 AND
          rs.advertising_mode IN ('Desktop', 'Mobile')
    ) result
    GROUP BY result.advertiser_id

```


# detect pdb or rtb?

双11前后, 遇到一些统计场景涉及到判断某个策略是否PDB项目.


PDB项目的特征:

PDB项目的sql logic:

    * s.script_code like '%pdb%'
    * platform != 'optimus'

哪一个是更准确的?  存疑.

`GROUP_CONCAT`用法

> This function returns a string result with the concatenated non-NULL values from a group. It returns NULL if there are no non-NULL values.

简而言之, 用来将GROUPED对象的TUPLE转为字符串拼接, 并忽略NULL VALUE. (用comma连接)

`INSTR`用法
字符串处理函数, 用于作子串的位置查询.  INSTR(str,substr).


# 如果可以, 不要delete from table...


无意中在[segmentfault](http://segmentfault.com/q/1010000003938997)中看到的一段文字:

> 不要删除数据

> Oren Eini（又名 Ayende Rahien）建议开发者尽量避免数据库的软删除操作，读者可能因此认为硬删除是合理的选择。作为对 Ayende 文章的回应，Udi Dahan 强烈建议完全避免数据删除。

> 所谓软删除主张在表中增加一个 IsDeleted 列以保持数据完整。如果某一行设置了IsDeleted标志列，那么这一行就被认为是已删除的。Ayende 觉得这种方法“简单、容易理解、容易实现、容易沟通”，但“往往是错的”。问题在于：

> 删除一行或一个实体几乎总不是简单的事件。它不仅影响模型中的数据，还会影响模型的外观。所以我们才要有外键去确保不会出现“订单行”没有对应的父“订单”的情况。而这个例子只能算是最简单的情况。……

> 当采用软删除的时候，不管我们是否情愿，都很容易出现数据受损，比如谁都不在意的一个小调整，就可能使“客户”的“最新订单”指向一条已经软删除的订单。

> 如果开发者接到的要求就是从数据库中删除数据，要是不建议用软删除，那就只能硬删除了。为了保证数据一致性，开发者除了删除直接有关的数据行，还应该级联地删除相关数据。可Udi
Dahan提醒读者注意，真实的世界并不是级联的：

> 假设市场部决定从商品目录中删除一样商品，那是不是说所有包含了该商品的旧订单都要一并消失？再级联下去，这些订单对应的所有发票是不是也该删除？这么一步步删下去，我们公司的损益报表是不是应该重做了？

> 没天理了。

> 问题似乎出在对“删除”这词的解读上。Dahan 给出了这样的例子：

> 我说的“删除”其实是指这产品“停售”了。我们以后不再卖这种产品，清掉库存以后不再进货。以后顾客搜索商品或者翻阅目录的时候不会再看见这种商品，但管仓库的人暂时还得继续管理它们。“删除”是个贪方便的说法。

> 他接着举了一些站在用户角度的正确解读：

> 订单不是被删除的，是被“取消”的。订单取消得太晚，还会产生花费。
员工不是被删除的，是被“解雇”的（也可能是退休了）。还有相应的补偿金要处理。
职位不是被删除的，是被“填补”的（或者招聘申请被撤回）。
在上面这些例子中，我们的着眼点应该放在用户希望完成的任务上，而非发生在某个
实体身上的技术动作。几乎在所有的情况下，需要考虑的实体总不止一个。

> 为了代替 IsDeleted 标志，Dahan 建议用一个代表相关数据状态的字段：有效、停用、取消、弃置等等。用户可以借助这样一个状态字段回顾过去的数据，作为决策的依据。

> 删除数据除了破坏数据一致性，还有其它负面的后果。Dahan建议把所有数据都留在数据库里：“别删除。就是别删除。”







## optimus



    所谓optimus, 我一直理解视为擎天柱(变3变4之后基本是如此的称呼).

    下面有一些小Tricky.



### 给定StrategyId生成优驰Url

```sql
  SELECT concat('http://inconsole.ipinyou.com/advertiser/', a.id,'/order/', o.id, '/campaign/', c.id, '/strategy/' ) AS url
 FROM strategy s , campaign c , ad_order o , advertiser a
 WHERE s.campaign_id = c.id AND c.order_id = o.id AND a.id = o.advertiser_id AND s.id =

```