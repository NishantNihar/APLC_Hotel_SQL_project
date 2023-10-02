USE theap44a_hotel;

/* select * from hotel2018;
select * from hotel2019;
select * from hotel2020;
select * from market_segment;
select * from meal_cost; */

-- Revenue calculation
-- Meal cost = Meal from table hotel * its cost from meal_cost table
-- total bookings, room rent, total customers and meal cost
-- Total nights = weekend stay+ weekday stay
-- room rent = total nights * adr (or) daily_room_rate
-- total customers = adult + children
-- meal cost = total customers * meal cost* total nights
-- final payment = room rent + meal cost - discount


/** Question 1 **/
-- Is hotel revenue increasing year on year
SELECT ht8.arrival_date_year, ROUND((SUM((ht8.stays_in_weekend_nights+ht8.stays_in_week_nights)*ht8.adr) + 
SUM((ht8.stays_in_weekend_nights+ht8.stays_in_week_nights)*(ht8.adults+ht8.children)*m.cost)) - SUM(ms.discount*100),2 ) as Final_payment
from hotel2018 ht8 inner join meal_cost m on ht8.meal=m.meal inner join 
market_segment ms on ht8.market_segment = ms.market_segment and ht8.is_canceled = 0 group by 1
UNION ALL
SELECT ht9.arrival_date_year, ROUND((SUM((ht9.stays_in_weekend_nights+ht9.stays_in_week_nights)*ht9.adr) + 
SUM((ht9.stays_in_weekend_nights+ht9.stays_in_week_nights)*(ht9.adults+ht9.children)*m.cost)) - SUM(ms.discount*100),2 ) as Final_payment
from hotel2019 ht9 inner join meal_cost m on ht9.meal=m.meal inner join 
market_segment ms on ht9.market_segment = ms.market_segment and ht9.is_canceled = 0 group by 1
UNION ALL
SELECT ht0.arrival_date_year, ROUND((SUM((ht0.stays_in_weekend_nights+ht0.stays_in_week_nights)*ht0.daily_room_rate) + 
SUM((ht0.stays_in_weekend_nights+ht0.stays_in_week_nights)*(ht0.adults+ht0.children)*m.cost)) - SUM(ms.discount*100),2 ) as Final_payment
from hotel2020 ht0 inner join meal_cost m on ht0.meal=m.meal inner join 
market_segment ms on ht0.market_segment = ms.market_segment and ht0.is_canceled = 0 group by 1;


/** Question2 **/
-- What market segment are major contributors of the revenue per year? In there a change year on year?
SELECT ht8.arrival_date_year, ht8.market_segment, ROUND(SUM((ht8.stays_in_weekend_nights+ht8.stays_in_week_nights)*ht8.adr +
((ht8.stays_in_weekend_nights+ht8.stays_in_week_nights)*(ht8.adults+ht8.children)*m.cost) - ms.discount*100),2) as revenue
from hotel2018 ht8 inner join meal_cost m on ht8.meal=m.meal inner join 
market_segment ms on ht8.market_segment = ms.market_segment and ht8.is_canceled = 0 group by 1,2 
order by revenue desc limit 1;
SELECT ht9.arrival_date_year, ht9.market_segment, ROUND(SUM((ht9.stays_in_weekend_nights+ht9.stays_in_week_nights)*ht9.adr +
((ht9.stays_in_weekend_nights+ht9.stays_in_week_nights)*(ht9.adults+ht9.children)*m.cost) - ms.discount*100),2) as revenue
from hotel2019 ht9 inner join meal_cost m on ht9.meal=m.meal inner join 
market_segment ms on ht9.market_segment = ms.market_segment and ht9.is_canceled = 0 group by 1,2 
order by revenue desc limit 1;
SELECT ht0.arrival_date_year, ht0.market_segment, ROUND(((SUM((ht0.stays_in_weekend_nights+ht0.stays_in_week_nights)*ht0.daily_room_rate) + 
SUM((ht0.stays_in_weekend_nights+ht0.stays_in_week_nights)*(ht0.adults+ht0.children)*m.cost)) - SUM(ms.discount)*100),2 ) as revenue
from hotel2020 ht0 inner join meal_cost m on ht0.meal=m.meal inner join 
market_segment ms on ht0.market_segment = ms.market_segment and ht0.is_canceled = 0 group by 1,2 
order by revenue desc limit 1;


/** Question 3 **/
-- When is the hotel at maximum occupancy? Is the period consistent across the years?
SELECT arrival_date_year, arrival_date_month, SUM(adults+children+babies) as family_count from hotel2018 where is_canceled = '0' group by 1,2 order by family_count desc limit 1;
SELECT arrival_date_year, arrival_date_month, SUM(adults+children+babies) as family_count from hotel2019 where is_canceled = '0' group by 1,2 order by family_count desc limit 1;
SELECT arrival_date_year, arrival_date_month, SUM(adults+children+babies) as family_count from hotel2020 where is_canceled = '0' group by 1,2 order by family_count desc limit 1;


/** QUestion 4 **/
-- When are people cancelling the most? 
SELECT arrival_date_year, arrival_date_month, count(reservation_status) from hotel2018 where is_canceled = '1' group by 1,2 order by count(reservation_status) desc limit 1;
SELECT arrival_date_year, arrival_date_month, count(reservation_status) from hotel2019 where is_canceled = '1' group by 1,2 order by count(reservation_status) desc limit 1;
SELECT arrival_date_year, arrival_date_month, count(reservation_status) from hotel2020 where is_canceled = '1' group by 1,2 order by count(reservation_status) desc limit 1;


/** Question 5 **/
-- Are families with kids more likely to cancel the hotel booking?
SELECT arrival_date_year, count(*) from hotel2018 where is_canceled=1 union 
SELECT arrival_date_year, count(babies) from hotel2018 where is_canceled =1 and babies<>0
union
SELECT arrival_date_year, count(*) from hotel2019 where is_canceled=1 union 
SELECT arrival_date_year, count(babies) from hotel2019 where is_canceled =1 and babies<>0
union
SELECT arrival_date_year, count(*) from hotel2020 where is_canceled=1 union 
SELECT arrival_date_year, count(babies) from hotel2020 where is_canceled =1 and babies<>0;