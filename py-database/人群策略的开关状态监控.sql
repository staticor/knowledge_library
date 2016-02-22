
select distinct  operator_name, timestamp, ll.type
    -- , target
      , target_name
      -- , referrer_url
      , adv.pyid_categories
      ,(case when sl.name = 'active' and old_val = 'true' and new_val = 'false' then '策略关闭'
           when sl.name = 'active' and old_val = 'false' and new_val = 'true' then '策略开' else null end) as status
from sys_operation_log  ll , (SELECT s.name,  s.id, s.active +'', s.last_modified  , s.`pyid_categories`
       FROM strategy s , campaign c , ad_order o , advertiser a
         WHERE s.campaign_id = c.id AND c.order_id = o.id AND a.id = o.advertiser_id AND a.id = 8283 ) adv ,
         sys_field_log  sl
where entity_cls = 'com.ipinyou.optimus.console.ad.entity.Strategy' And result = 'Success' AND ll.type = 'Update'
  and ll.timestamp > ADDDATE(SYSDATE(), INTERVAL - 7 day)
    and adv.id = ll.target_id
    and ll.id = sl.log_id and sl.name = 'active'
order by pyid_categories, timestamp
