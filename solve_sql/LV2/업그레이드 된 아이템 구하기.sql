select a.item_id, c.item_name, c.rarity
from item_tree a
    join item_info b
    on a.parent_item_id=b.item_id
    join item_info c
    on a.item_id=c.item_id
where a.parent_item_id is not null and b.rarity = 'RARE'
order by a.item_id desc;