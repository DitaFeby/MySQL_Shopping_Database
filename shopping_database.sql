CREATE SCHEMA shopee2;

CREATE TABLE shopee2.order (
  `shopid` VARCHAR(13),
  `orderid` VARCHAR(13),
  `buyerid` VARCHAR(13),
  `itemid` VARCHAR(13),
  `gmv` FLOAT,
  `order_time` DATE
  
);

CREATE TABLE shopee2.performance (
  `shopid` VARCHAR(13),
  `total_clicks` INTEGER,
  `impressions` INTEGER,
  `item_views` INTEGER
);

CREATE TABLE shopee2.user (
  `shopid` VARCHAR(13),
  `buyerid` VARCHAR(13),
  `register_date` DATE,
  `country` VARCHAR(13)
);

#Write an SQL statement to find the first and latest order date of each buyer in each shop
SELECT DISTINCT buyerid, shopid, MIN(order_time), MAX(order_time)
FROM order_tab
GROUP BY buyerid, shopid
ORDER BY buyerid;

#Write an SQL statement to find buyer that make more than 1 order in 1 month
SELECT t2.buyerid, t2.months, t2.counts FROM
	(SELECT buyerid, EXTRACT(MONTH FROM order_time) AS months, 
	COUNT(EXTRACT(MONTH FROM order_time)) AS counts 
	FROM order_tab
	GROUP BY buyerid
    )t2
WHERE t2.counts > 1
ORDER BY buyerid;

#Write an SQL statement to find the first buyer of each shop
SELECT shopid, buyerid, MIN(t2.first_date) AS buy_date
FROM
	(SELECT shopid, buyerid, MIN(order_time) as first_date
	FROM order_tab
	GROUP BY shopid, buyerid
	ORDER BY shopid, first_date
    )t2
GROUP BY shopid;

#Write an SQL statement to find the TOP 10 Buyer by GMV in Country ID & SG
SELECT DISTINCT order_tab.buyerid, order_tab.gmv, user_tab.country
FROM order_tab
JOIN user_tab
ON  order_tab.shopid = user_tab.shopid
WHERE country IN ('ID', 'SG')
ORDER BY country, gmv DESC;


#Write an SQL statement to find number of buyer of each country that purchased item with even and odd itemid number
SELECT t2.country, 
SUM(CASE WHEN t2.itemid % 2 = 0 THEN 1 ELSE 0 END) AS buyer_even_item,
SUM(CASE WHEN t2.itemid % 2 != 0 THEN 1 ELSE 0 END) AS buyer_odd_item
FROM
	(SELECT DISTINCT user_tab.country, user_tab.buyerid, order_tab.itemid
	FROM user_tab
	JOIN order_tab
	ON user_tab.buyerid = order_tab.buyerid
    ) t2
GROUP BY t2.country;

#Write an SQL statement to find the number of order/views & clicks/impressions of each shop
SELECT DISTINCT order_tab.shopid,
COUNT(order_tab.orderid)/SUM(performance_tab.item_views) AS order_per_views,
SUM(performance_tab.total_clicks)/SUM(performance_tab.impressions) AS click_per_impressions 
FROM order_tab
JOIN performance_tab
ON order_tab.shopid = performance_tab.shopid
GROUP BY shopid;








