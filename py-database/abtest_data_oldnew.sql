
-- select * from checklist_abtest_data


insert into checklist_abtest_data(strategy_id, day, adv_mode, bid, imp, click, reach, two_jump, cost, target_name, imp_conversion, click_conversion, abtype, campaign_id )


select strategy_id, day, stype as adv_mode, bid, imp, click, reach, two_jump, cost, target_name, imp_conversion, click_conversion, abtype, campaign_id
from (
select upup.id as strategy_id, upup.day ,
     ( CASE   -- 顺序  自媒体, 视频, 视频&Banner, 移动, PC
			 WHEN s.advertising_mode = 'OwnMedia' THEN  '自媒体'
                                    WHEN s.ad_unit_types = 'Video' THEN '视频'
                                    WHEN s.ad_unit_types = 'Banner,Video' THEN   '视频+Banner'
                                    WHEN s.advertising_mode = 'Mobile' THEN  '移动'
                                    WHEN s.advertising_mode = 'Desktop' THEN  'PC'
                                    ELSE NULL
                                  END ) AS stype

      , bid,imp,click, reach, two_jump, cost
          --  , concat('$      ', ROUND(cost/click,2), '  元') AS 'cpc'
           -- , concat(ROUND(click/imp*100,2), '%') AS 'ctr'
           -- , (case when cc > 0 then   concat('$      ', ROUND(cost/cc,2), '  元') else '.' end ) AS 'cpa'
      , ct.name as target_name, ic as imp_conversion, cc as click_conversion
        , replace( replace( s.pyid_categories, '\r', ''), '\n', '@') as pyid, s.algorithm_code, s.script_code

      , s.name as 策略名称 , c.name as campaign, o.name as orderName, c.id as campaign_id
       , (case when as1.name is not null then 'abtest/老版算法'
          when as2.name is not null then 'abtest/新版算法'
          else '相同计划下其它策略' end ) abtype
from (
select   red.id, day, bid, imp, click, reach, two_jump, cost
FROM
    (

    SELECT strategy_id AS id, DAY, sum(bid) as bid, sum(imp) AS imp, sum(click) AS click, sum(reach) AS reach,  sum(two_jump) AS two_jump
           , sum(adv_cost) AS cost
    FROM reportdb.rpt_effect_day
    WHERE  campaign_id in ( select  campaign_id from abtest_strategy where id > 39 )
    		 and
        DAY > '2015-11-28'
    GROUP BY strategy_id, DAY
    Having SUM(adv_cost) > 10
)red, reportdb.strategy s
WHERE s.id = red.id )  upup

LEFT JOIN (

    SELECT strategy_id AS id, DAY, tar.name
              , sum(imp_conversion) as ic, sum(click_conversion) as cc
    FROM reportdb.rpt_effect_day , monitor.conversion_target tar
    WHERE campaign_id in ( select  campaign_id from abtest_strategy where id > 39 ) and
           DAY > '2015-11-28'  and conversion_target_id = tar.target_id
    GROUP BY strategy_id, DAY, tar.name
  ) ct
ON
    upup.id = ct.id and  upup.day = ct.day
JOIN reportdb.strategy s ON s.id = upup.id
JOIN reportdb.campaign c ON c.id = s.campaign_id
JOIN reportdb.ad_order o ON o.id = c.order_id
LEFT JOIN abtest_strategy as1 ON s.id = as1.a_group
LEFT JOIN abtest_strategy as2 ON s.id = as2.b_group
) final_result
order by campaign_id, day, strategy_id, target_name




select * from checklist_abtest_data