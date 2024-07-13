select b.title as TITLE, b.board_id as BOARD_ID, r.reply_id as REPLY_ID,
        r.writer_id as WRITER_ID, r.contents as CONTENTS, 
        date_format(r.created_date, "%Y-%m-%d") as CREATED_DATE
from used_goods_board as b
join used_goods_reply as r
    on b.board_id = r.board_id
where date_format(b.created_date, '%Y-%m')='2022-10'
order by CREATED_DATE, TITLE;
