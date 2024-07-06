select count(*) as COUNT
from ecoli_data
where (genotype & 2 = 0) and (genotype & 1 <> 0 or genotype & 4 <> 0);

/*
    genotype & 2 => genotype과 2를 비트를 비교해 확인하는 것 
    
    ex) 1001(2)일 때, 오른쪽부터 1, 2, 4, 8
    genotype & 2 = 0 => 오른쪽에서 두번째 비트가 0인지 확인
    genotype & 1 <> 0 => 오른쪽에서 첫번째 비트가 0이 아닌지 확인 
*/