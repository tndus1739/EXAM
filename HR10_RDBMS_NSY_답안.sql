select * from employee ;

--  1. 사원번호(eno)가 7788인 사원의 이름(ename)과 부서번호(dno)를 출력하세요.  컬럼명을 별칭(alias) 시켜서 출력 하세요.

select ename 이름 , dno 부서번호
from employee
where eno = 7788; 

-- 2. 1981년도 입사한 사원의 이름(ename)과 입사일(hiredate) 을 출력 하시오 ( like 연산자와 와일드 카드 사용: _ , %)

select ename 이름 , hiredate 입사일
from employee
where hiredate like '81%' ;

--3. 담당 업무(job) 가 사무원(CLERK) 또는 영업사원(SALESMAN)이면서 급여가 $1600, $950, 또는 $1300 이 아닌 사원의 이름, 담당업무, 급여를 출력하시오.

select ename 사원이름 , job 담당업무 , salary 급여
from employee
where (job =  'CLERK' or job = 'SALESMAN')  and  salary not in ( 1600 , 950 , 1300 ) ;

--4. 자신이 태어난 날짜에서 현재까지 몇 개월이 지났는지 출력 하세요. 소숫점은 잘라서 출력 하세요 . (months_between , trunc 함수 사용)

select trunc( months_between( sysdate , to_date (19930108 , 'yyyymmdd') ) )  as " 현재까지의 살아온 개월 수" 
from dual;

--5. 부서별(dno) 월급의 평균이 2000 이상만 출력 하되 부서번호(dno)를  오름차순으로 출력하세요. 평균의 소숫점은 2자리까지만 출력하되 반올림해서 출력 하세요.
select dno 부서번호 , round (avg (salary) , 2)  "월급의 평균"
from employee
group by dno
having round (avg (salary) , 2) >= 2000
order by dno asc ;


--6. 급여가 평균 급여보다 많은 사원들의 사원번호(eno)와 이름(ename)을 표시하되 결과를 급여(salary) 에 대해 오름차순 정렬하시오.  subquery를 사용해서 출력 하세요.
select eno 사원번호 , ename 이름 ,  salary 급여
from employee
where salary > ( select avg (salary) from employee )
order by salary asc ;


--7. 직책(job) 이 'MANAGER' 인 사원이름(ename), 부서번호(dno), 부서명(dname), 부서위치(loc) 출력하되 사원이름(ename) 내림차순 정렬하세요.

select ename 사원이름 , d.dno 부서번호 , dname 부서명 , loc  부서위치 
from employee e
        join department d
          on e.dno = d.dno
where job = 'MANAGER'
order by ename desc ;

/*
8. 다음은 복잡한 쿼리를 view 를 생성해서 단순화하고 view를 실행하시오 . 
뷰(view) 명 :  v_join 

employee, department 테이블의 부서별로 최소 월급을 받는 사원이름(ename), 사원의 직책 (job), 부서명(dname), 부서위치 (loc) 를 출력되 최소월급이 900이상 만 출력하세요. 단, 부서번호 20번은 제외하고 출력하세요. 
    힌트 :  JOIN, group by, where, having , subquery  구문을 활용 하세요
   
   - 답안 :  view 생성 구문, view 실행 구문 을 넣으세요. 
*/

create view v_join
as
select ename 사원이름 , job "사원의 직책" , dname 부서명 , loc 부서위치
from employee e 
     join department d
        on e.dno = d.dno
where  d.dno <> 20  and salary  in  ( select  min (salary) from employee group by dno having  min ( salary ) >= 900) ;

select * from v_join ;

/*
9. 테이블 복사및 alter table 을 사용하여 복사한 원본 테이블과 같은 제약 조건을 추가 하시오 
   employee 테이블의 모든 컬럼과 값을 복사하여 EMP50 테이블을 생성하시오
   department 테이블의 모든 컬럼과 값을 복사하여 DEPT50 테이블을 생성하시오. 
   원본 테이블에 부여된 제약조건을 복사된 테이블에도 부여 하시오 . 
*/

create table emp50
as
select * from employee ;

create table dept50
as
select * from department ;

alter table dept50
add constraint PK_DEPT50_DNO primary key (dno) ;

alter table emp50
add constraint PK_EMP50_ENO  primary key (eno) ;

alter table emp50
add constraint FK_EMP50_DNO foreign key (dno) references dept50 (dno);

-- 테이블의 제약조건 확인

select * from user_constraints  where table_name in ('DEPT50') ;  
select * from user_constraints  where table_name in ('EMP50') ;  


/*
10. 9번 문항에서 복사한 테이블 (EMP50, DEPT50) 테이블을 사용하여 아래 쿼리를 작성하시오. 
     - 모든 내용은 DataBase 에 영구히 저장 하시오. 
     1. EMP50 테이블에 레코드(값을 추가하시오). 
          사원번호 : 8181     사원이름 : 홍길동     직책 : 사무원     직속상관 :  SCOTT (7788) 
          입사날짜 : 현재의 시스템의 날짜     월급 : 1000.     보너스 : 100     부서번호 : 20
    2. EMP50 테이블에 값을 보너스가 없는 사원들을 찾아서 보너스를 50으로 적용 하시오. 
    3. DEPT50 테이블의 부서번호 40의 부서명을 “운영부”로 바꾸고, 부서위치를 “서울”로 변경하시오. 
    4. EMP50 테이블의 직책이 “MANAGER” 사원들을 찾아 제거 하시오. 

*/

select * from emp50 ;
desc emp50 ;

insert into emp50 
values ( 8181 , '홍길동' ,' CLERK' , 7788 , sysdate , 1000 , 100 , 20 );

update emp50
set commission = 50
where commission is null  or commission = 0 ;

select * from dept50 ;

update dept50
set dname = '운영부' , loc = '서울'
where dno = 40;

delete emp50
where job = 'MANAGER';

commit;
