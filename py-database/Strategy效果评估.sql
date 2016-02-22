

-- 华晨租车 策略效果查询

SELECT a.name, DAY, imp, click, reach,  tj AS '二跳', ic AS '曝转',cc AS '点转' , cost AS '消耗', a.pyid_categories
FROM (
    SELECT strategy_id AS id, DAY, sum(imp) AS imp, sum(click) AS click, sum(reach) AS reach,  sum(two_jump) AS tj
            , SUM(imp_conversion) AS ic, sum(click_conversion) AS cc , sum(adv_cost) AS cost
    FROM report.rpt_effect_day
    WHERE advertiser_id IN  (8080 ) AND DAY > ADDDATE(SYSDATE(), INTERVAL - 4 DAY)
    GROUP BY strategy_id, DAY
)red, optimus.strategy a
WHERE a.id = red.id   AND (a.name LIKE '%转化%' OR a.name LIKE '%qq%' )
ORDER BY a.pyid_categories, a.name, DAY




-- 优向科技 2楼盘效果评估
SELECT DAY,a.name, bid, imp, click, reach,  tj AS '二跳' ,ic AS '曝转'
            , cc AS '点转'
            ,  concat('$      ', ROUND(cost,2), '  元')  AS '消耗'
            , concat('$      ', ROUND(cost/click,2), '  元') AS 'cpc'
            , concat(ROUND(click/imp*100,2), '%') AS 'ctr'
            , (CASE WHEN DAY > '2015-10-31' THEN 'November' ELSE 'October' END) AS MONTH , a.pyid_categories

FROM (
    SELECT strategy_id AS id, DAY, sum(imp) AS imp, sum(bid) as bid, sum(click) AS click, sum(reach) AS reach,  sum(two_jump) AS tj
            , SUM(imp_conversion) AS ic, sum(click_conversion) AS cc , sum(adv_cost) AS cost
    FROM report.rpt_effect_day
    WHERE advertiser_id IN  (11634,11320) AND DAY > '2015-11-16'
    GROUP BY strategy_id, DAY
    Having SUM(adv_cost) > 10
)red, optimus.strategy a
WHERE a.id = red.id   AND (a.name LIKE '%%') AND a.active = 1
ORDER BY a.pyid_categories, a.name, DAY

