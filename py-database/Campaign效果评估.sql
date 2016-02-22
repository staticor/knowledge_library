
--  华晨租车  计划层 统计
SELECT DAY,  click, reach,
        tj AS '二跳' -- ,ic AS '曝转'
        , imp
            , cc AS '点转' , cost AS '消耗', cost/click AS 'cpc', click/ imp AS 'ctr'
            , (CASE WHEN DAY > '2015-10-31' THEN 'November' ELSE 'October' END) AS MONTH , a.name
FROM (
    SELECT campaign_id AS id, DAY, sum(imp) AS imp, sum(click) AS click, sum(reach) AS reach,  sum(two_jump) AS tj
            , SUM(imp_conversion) AS ic, sum(click_conversion) AS cc , sum(adv_cost) AS cost
    FROM report.rpt_effect_day
    WHERE advertiser_id IN  (8080) AND DAY > '2015-10-01'
    GROUP BY campaign_id, DAY
)red, optimus.campaign a
WHERE a.id = red.id   AND (a.name LIKE '%PC%') -- AND a.active = 1
ORDER BY a.name, DAY