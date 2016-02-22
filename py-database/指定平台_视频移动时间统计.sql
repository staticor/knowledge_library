
SELECT platform, sum(bid), sum(imp), SUM(click)
FROM report.rpt_effect_day red, advertiser a,  strategy s
WHERE a.pool_id = 2 AND a.id = red.advertiser_id AND red.day >= '2015-01-01' AND red.day <='2015-10-31' AND red.strategy_id = s.id
    AND (
             (UPPER(platform) IN ('LETV', 'YOUKU', 'BAOFENG' , 'FUNSHION', 'TENCENT') AND  s.ad_unit_types = 'Video')
             OR (UPPER(platform) IN ( 'BAIDU', 'MOGO', 'Inmobi') AND s.advertising_mode = 'Mobile')
             )
GROUP BY platform