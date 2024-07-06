select a.id as ID, a.genotype as GENOTYPE, b.genotype as PARENT_GENOTYPE
from ecoli_data as a, ecoli_data as b
where a.parent_id = b.id 
    and a.genotype & b.genotype = b.genotype
order by id;

/*
    같은 테이블을 각각 자식id, 부모id를 기준으로 join 
    : a.parent_id=b.id => a테이블을 '자식 테이블'로 지정하고 
    a 테이블의 부모id와 같은 id를 가진 데이터를 b테이블(부모 테이블)에서 찾아 join

    자식 테이블의 genotype과 부모 테이블의 genotype을 and 연산을 하고⭐ 
    그 결과가 부모 테이블의 genotype과 같으면 됨 (자식이 모두 가지고 있다는 뜻)
*/