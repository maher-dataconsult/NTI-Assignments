USE Hotels;
-- ---------------------------------------------------------------------------
/* Creating the union view of all years transactions */
CREATE VIEW hotel_log AS
SELECT * FROM ['2018']
UNION ALL
SELECT * FROM ['2019']
UNION ALL
SELECT * FROM ['2020'];
-- ---------------------------------------------------------------------------
/*  ايه هى نسبه الربح لكل شهر على مدار السنين ؟ */
SELECT arrival_date_year as year,
		arrival_date_month as month,
		ROUND(SUM(adr*(stays_in_week_nights+stays_in_weekend_nights)),0) as total_revenue
FROM hotel_log
WHERE is_canceled = 0
GROUP BY arrival_date_year,
			arrival_date_month
ORDER BY arrival_date_year,
			total_revenue DESC ; -- 'august' is the most profitable
-- ---------------------------------------------------------------------------
/* اإيه أكتر وجبات بتساهم فالربح السنوى */
with cte01 as (
SELECT hl.arrival_date_year as year,
		hl.meal,
		SUM(stays_in_week_nights+stays_in_weekend_nights) as days
FROM hotel_log hl
WHERE is_canceled = 0
group by hl.arrival_date_year,
		hl.meal
)
SELECT cte01.year,
		cte01.meal,
		mc.Cost,
		cte01.days,
		ROUND(mc.Cost*days,0) as total_rev
FROM cte01
join meal_cost mc on mc.meal = cte01.meal 
ORDER BY year, total_rev DESC; -- 'BB' meal is the most profitable

-- ---------------------------------------------------------------------------
/*  اكتر مجموعات عملاء (زي العائلات أو الشركات) اللي بتساهم في الإيرادات السنوية لكل فندق؟ */
SELECT hl.arrival_date_year as year,
		market_segment,
		ROUND(SUM(adr*(stays_in_week_nights+stays_in_weekend_nights)),0) as total_revenue
FROM hotel_log hl
WHERE is_canceled = 0
GROUP BY hl.arrival_date_year, market_segment 
ORDER BY arrival_date_year ,total_revenue DESC ; --'Online Ta' is the most Profitable
-- ---------------------------------------------------------------------------
/* هل الإجازات بتزود المكسب ولا الأيام العادية أفضل؟ */
SELECT hl.arrival_date_year as year,
		ROUND(SUM(stays_in_week_nights*adr),0) as weekdays_revenue,
		ROUND(SUM(stays_in_weekend_nights*adr),0) as WEEKENDS_revenue
FROM hotel_log hl
WHERE is_canceled = 0
GROUP BY hl.arrival_date_year
ORDER BY arrival_date_year; --'weekdays' are the most Profitable
-- ---------------------------------------------------------------------------
/* تاثير نوع الفندق على الإيرادات السنوية؟ */
SELECT hl.arrival_date_year as year,
		hotel,
		ROUND(SUM(adr*(stays_in_week_nights+stays_in_weekend_nights)),0) as total_revenue
FROM hotel_log hl
WHERE is_canceled = 0
GROUP BY hl.arrival_date_year, hotel
ORDER BY arrival_date_year, total_revenue DESC; 
-- the most Profitable in 2019 is 'Resort Hotel' while in 2019 & 2020 is'City Hotel'
-- ---------------------------------------------------------------------------
/* تاثير نوع الغرفه على الإيرادات السنوية؟ */
SELECT hl.arrival_date_year as year,
		reserved_room_type,
		ROUND(SUM(adr*(stays_in_week_nights+stays_in_weekend_nights)),0) as total_revenue
FROM hotel_log hl
WHERE is_canceled = 0
GROUP BY hl.arrival_date_year, reserved_room_type
ORDER BY arrival_date_year, total_revenue DESC; -- 'A' is the most reserved roomtype