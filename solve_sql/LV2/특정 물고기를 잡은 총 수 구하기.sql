select sum(fish_count) as FISH_COUNT
from (select count(*) as fish_count
from fish_name_info a
left join fish_info b
	on a.fish_type=b.fish_type
where a.fish_name in('BASS', 'SNAPPER')
group by a.fish_name) as s1;
