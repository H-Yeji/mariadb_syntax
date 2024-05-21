-- 서브쿼리로 풀기 
select o.ANIMAL_ID, o.name
from ANIMAL_OUTS o 
where ANIMAL_ID not in(select ANIMAL_ID from ANIMAL_INS i)
order by o.ANIMAL_ID asc;

-- left join으로 풀기
select o.ANIMAL_ID, o.name
from ANIMAL_OUTS o 
left join ANIMAL_INS i
    on o.ANIMAL_ID=i.ANIMAL_ID
where i.ANIMAL_ID is null
order by i.ANIMAL_ID asc;
