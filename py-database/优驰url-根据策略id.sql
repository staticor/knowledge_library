


-- 根据策略得到优驰的url
 SELECT concat('http://inconsole.ipinyou.com/advertiser/', a.id,'/order/', o.id, '/campaign/', c.id, '/strategy/' ) AS url ,
       c.name, o.name
 FROM strategy s , campaign c , ad_order o , advertiser a
 WHERE s.campaign_id = c.id AND c.order_id = o.id AND a.id = o.advertiser_id AND s.id = 142624
