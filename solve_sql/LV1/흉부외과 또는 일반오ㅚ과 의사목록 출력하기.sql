select DR_NAME, DR_ID, MCDP_CD, date_format(HIRE_YMD, '%Y-%m-%d')
from DOCTOR
where MCDP_CD='CS' OR MCDP_CD='GS'
order by HIRE_YMD desc, DR_NAME asc;
