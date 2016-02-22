
select advertiser_id, day, strategy_id, tt.name,
     -- ss.pyid_categories ,
      (case when length( ss.pyid_categories ) > 4 then '算法人群策略' else '非人群' end) as 策略type,
    bid,imp, click, reach, inv, conv, cost
from
(
select advertiser_id, day, strategy_id, conversion_target_id,
    sum(bid) as bid,
    sum(imp) as imp,
    sum(click)as click,
    sum(reach) as reach,
    sum(imp_conversion) as inv ,
   sum(click_conversion) as conv
   ,sum(adv_cost) as cost


from report. rpt_effect_day

where advertiser_id = 8283 and  day > '2015-10-08' -- and imp > 0
group by advertiser_id, day, strategy_id, conversion_target_id

) red , optimus.conversion_target tt , optimus.strategy ss
where
   red.conversion_target_id = tt.id
    and ss.id = red.strategy_id

 order by name, day