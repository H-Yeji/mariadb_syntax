select sum(price) as TOTAL_PRICE
from item_info
group by rarity
having rarity="LEGEND";
