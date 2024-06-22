select count(*) as fish_count
from fish_name_info a
left join fish_info b
	on a.fish_type=b.fish_type
where a.fish_name in('BASS', 'SNAPPER');
