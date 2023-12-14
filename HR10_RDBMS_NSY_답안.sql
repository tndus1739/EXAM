select * from employee ;

--  1. �����ȣ(eno)�� 7788�� ����� �̸�(ename)�� �μ���ȣ(dno)�� ����ϼ���.  �÷����� ��Ī(alias) ���Ѽ� ��� �ϼ���.

select ename �̸� , dno �μ���ȣ
from employee
where eno = 7788; 

-- 2. 1981�⵵ �Ի��� ����� �̸�(ename)�� �Ի���(hiredate) �� ��� �Ͻÿ� ( like �����ڿ� ���ϵ� ī�� ���: _ , %)

select ename �̸� , hiredate �Ի���
from employee
where hiredate like '81%' ;

--3. ��� ����(job) �� �繫��(CLERK) �Ǵ� �������(SALESMAN)�̸鼭 �޿��� $1600, $950, �Ǵ� $1300 �� �ƴ� ����� �̸�, ������, �޿��� ����Ͻÿ�.

select ename ����̸� , job ������ , salary �޿�
from employee
where (job =  'CLERK' or job = 'SALESMAN')  and  salary not in ( 1600 , 950 , 1300 ) ;

--4. �ڽ��� �¾ ��¥���� ������� �� ������ �������� ��� �ϼ���. �Ҽ����� �߶� ��� �ϼ��� . (months_between , trunc �Լ� ���)

select trunc( months_between( sysdate , to_date (19930108 , 'yyyymmdd') ) )  as " ��������� ��ƿ� ���� ��" 
from dual;

--5. �μ���(dno) ������ ����� 2000 �̻� ��� �ϵ� �μ���ȣ(dno)��  ������������ ����ϼ���. ����� �Ҽ����� 2�ڸ������� ����ϵ� �ݿø��ؼ� ��� �ϼ���.
select dno �μ���ȣ , round (avg (salary) , 2)  "������ ���"
from employee
group by dno
having round (avg (salary) , 2) >= 2000
order by dno asc ;


--6. �޿��� ��� �޿����� ���� ������� �����ȣ(eno)�� �̸�(ename)�� ǥ���ϵ� ����� �޿�(salary) �� ���� �������� �����Ͻÿ�.  subquery�� ����ؼ� ��� �ϼ���.
select eno �����ȣ , ename �̸� ,  salary �޿�
from employee
where salary > ( select avg (salary) from employee )
order by salary asc ;


--7. ��å(job) �� 'MANAGER' �� ����̸�(ename), �μ���ȣ(dno), �μ���(dname), �μ���ġ(loc) ����ϵ� ����̸�(ename) �������� �����ϼ���.

select ename ����̸� , d.dno �μ���ȣ , dname �μ��� , loc  �μ���ġ 
from employee e
        join department d
          on e.dno = d.dno
where job = 'MANAGER'
order by ename desc ;

/*
8. ������ ������ ������ view �� �����ؼ� �ܼ�ȭ�ϰ� view�� �����Ͻÿ� . 
��(view) �� :  v_join 

employee, department ���̺��� �μ����� �ּ� ������ �޴� ����̸�(ename), ����� ��å (job), �μ���(dname), �μ���ġ (loc) �� ��µ� �ּҿ����� 900�̻� �� ����ϼ���. ��, �μ���ȣ 20���� �����ϰ� ����ϼ���. 
    ��Ʈ :  JOIN, group by, where, having , subquery  ������ Ȱ�� �ϼ���
   
   - ��� :  view ���� ����, view ���� ���� �� ��������. 
*/

create view v_join
as
select ename ����̸� , job "����� ��å" , dname �μ��� , loc �μ���ġ
from employee e 
     join department d
        on e.dno = d.dno
where  d.dno <> 20  and salary  in  ( select  min (salary) from employee group by dno having  min ( salary ) >= 900) ;

select * from v_join ;

/*
9. ���̺� ����� alter table �� ����Ͽ� ������ ���� ���̺�� ���� ���� ������ �߰� �Ͻÿ� 
   employee ���̺��� ��� �÷��� ���� �����Ͽ� EMP50 ���̺��� �����Ͻÿ�
   department ���̺��� ��� �÷��� ���� �����Ͽ� DEPT50 ���̺��� �����Ͻÿ�. 
   ���� ���̺� �ο��� ���������� ����� ���̺��� �ο� �Ͻÿ� . 
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

-- ���̺��� �������� Ȯ��

select * from user_constraints  where table_name in ('DEPT50') ;  
select * from user_constraints  where table_name in ('EMP50') ;  


/*
10. 9�� ���׿��� ������ ���̺� (EMP50, DEPT50) ���̺��� ����Ͽ� �Ʒ� ������ �ۼ��Ͻÿ�. 
     - ��� ������ DataBase �� ������ ���� �Ͻÿ�. 
     1. EMP50 ���̺� ���ڵ�(���� �߰��Ͻÿ�). 
          �����ȣ : 8181     ����̸� : ȫ�浿     ��å : �繫��     ���ӻ�� :  SCOTT (7788) 
          �Ի糯¥ : ������ �ý����� ��¥     ���� : 1000.     ���ʽ� : 100     �μ���ȣ : 20
    2. EMP50 ���̺� ���� ���ʽ��� ���� ������� ã�Ƽ� ���ʽ��� 50���� ���� �Ͻÿ�. 
    3. DEPT50 ���̺��� �μ���ȣ 40�� �μ����� ����Ρ��� �ٲٰ�, �μ���ġ�� ������� �����Ͻÿ�. 
    4. EMP50 ���̺��� ��å�� ��MANAGER�� ������� ã�� ���� �Ͻÿ�. 

*/

select * from emp50 ;
desc emp50 ;

insert into emp50 
values ( 8181 , 'ȫ�浿' ,' CLERK' , 7788 , sysdate , 1000 , 100 , 20 );

update emp50
set commission = 50
where commission is null  or commission = 0 ;

select * from dept50 ;

update dept50
set dname = '���' , loc = '����'
where dno = 40;

delete emp50
where job = 'MANAGER';

commit;
