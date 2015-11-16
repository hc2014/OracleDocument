create table test1
(
id char(3) primary key  not null,
name varchar(20),
age number,
remark nvarchar2(100),
type1 nvarchar2(100)
)

select * from test2
insert into test2 values(1,'A',13,'a','bb');
insert into test2 values(2,'J',14,'a','bb');
insert into test2 values(3,'G',13,'b','');
insert into test2 values(4,'G',16,'b','bbb');
insert into test2 values(5,'H',17,null,'bb');
insert into test2 values(6,'MM',20,'c',null);
insert into test2 values(7,'R',13,'','');

--��ͨ���Ӳ�ѯ
select * from test1,test2 where test1.id=test2.id
--����
select  * from test1 inner join test2 on test1.id=test2.id
--ȫ����
select * from test1 full outer join test2 on test1.type1=test2.type1
--�ѿ����˻� �� ������������κ����� һ���Ĳ�ѯ���
select * from test1 cross join test2 where test1.id>5

select id from test1 union select id from test2



declare
 
begin 
 update test2 set name='aaa' where id=7;
    dbms_output.put_line(to_char(sql%rowcount));
 end;



-- �洢����
create or replace procedure testPro(
i in number,
j in number
) is
var_sum number;
begin
    var_sum:=i+j;
    dbms_output.put_line(var_sum);
end testPro;
       

--EXECUTE testPro(2,3); �����д��

declare
v_sql varchar(100);
begin
v_sql:='begin testPro(:i,:j);end;';
execute immediate v_sql using in '1',in '2';
end;

--set serveroutput on Ҳ�Ǵ����д��
 --exec testPro(1,2) 

--����
create sequence test_quence 
start with 1
increment by 1 
nomaxvalue
nocycle
cache 10

--�������� ����������
insert into test2 values(test_quence.nextval,'Rr',13,'','');--currval ��ʾ���е�ǰ��ֵ��nextval��ʾ ��һ��ֵ
--��ѯ������Ϣ  ��ͼ����Ҫ��д
select * from USER_SEQUENCES where sequence_name='TEST_QUENCE'
--��ѯ ������һ��ֵ
select test_quence.nextval from dual


--������ͼ
create view test_view
as
select * from test2

--��ѯ��ͼ
select * from test_view
--�޸���ͼ�ķ�ʽ�� �޸�ԭʼ����
update test_view set name='b' where id=11

--��ѯ���Ա��޸ĵ���ͼ/��  ��yes/no ��ʾ
select * from user_updatable_columns where table_name='TEST_VIEW'

       
--�����û�
create user huangchao identified by "000000";
grant create session to huangchao;  
           grant create table to  huangchao;  
           grant create tablespace to  huangchao;  
           grant create view to  huangchao;
           grant connect, resource to huangchao;
--����ѯ   huangchao���û�        
select * from huangchao.test3

--��ѯ ������
select * from v$lock_type where type in ('TX','TM')

--�����޸�����
declare
begin 
for cur in (select id,age,name from test1) loop
 update test2 set name=cur.name,age=cur.age where id=cur.id;
  end loop;
 end;

--ͬʱ�޸Ķ�������
update test2 set (name,age)=(select name,age from test1 where test1.id=4) where test2.id=2



--�α�
declare
cursor c
is 
select name,age,remark from test2 where id=2;
c_row c%rowtype;
begin
for r in c loop
 dbms_output.put_line(r.name||r.age||r.remark);
 end loop;
 end;

--�м�������
create or replace trigger delete_test1_trigger
after delete
on test1
-for each row
begin 
 delete test2 where id=:old.id;
end;


select t1.*,t2.id from test1 t1  join test2 t2 on t1.id=t2.id(+)--������
select t1.*,t2.id from test1 t1  join test2 t2 on t1.id(+)=t2.id--������

--�ݹ��ѯ ʵ��
create table test_lvl1 (id number, parent_id number, name varchar2(10));
insert into test_lvl1 values (1,null,'SLI1');
 insert into test_lvl1 values (2,1,'SLI2');
 insert into test_lvl1 values (3,1,'SLI3');
 insert into test_lvl1 values (4,null,'SLI4');
 insert into test_lvl1 values (5,2,'SLI5');
 insert into test_lvl1 values (6,3,'SLI6');
 insert into test_lvl1 values (7,5,'SLI7');
 insert into test_lvl1 values (8,7,'SLI8');
 insert into test_lvl1 values (9,4,'SLI9');
 insert into test_lvl1 values (10,3,'SLI10');
 insert into test_lvl1 values (11,1,'SLI11');
 
select * from test_lvl1

--�ݹ��ѯ
select a.*, b.name parent_name
 from
 (select name, ID, PARENT_ID, LEVEL
 from test_lvl1
 start with parent_id is null
 connect by prior id=PARENT_ID) a,
 test_lvl1 b
 where a.parent_id=b.id(+)


--�ݹ��ѯʵ��2
CREATE TABLE SC_DISTRICT
(
  ID         NUMBER(10)                  NOT NULL,
  PARENT_ID  NUMBER(10),
  NAME       VARCHAR2(255 BYTE)          NOT NULL
);
INSERT INTO SC_DISTRICT(ID,NAME) VALUES(1,'�Ĵ�ʡ');

INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(2,1,'������');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(3,1,'������'); 

INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(4,2,'������');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(5,2,'ͨ����');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(6,2,'ƽ����');

INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(7,3,'ͨ����');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(8,3,'������');

INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(9,8,'������');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(10,8,'������');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(11,8,'������');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(12,8,'�ϰ���');
 
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(13,6,'��կ��');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(14,6,'��̲��');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(15,6,'������');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(16,6,'������');

select * from sc_district
--�ݹ��ѯ2
select * from sc_district start with parent_id is null
connect by prior  id=parent_id 
--connect_by_root���������е�ǰ�棬��¼���ǵ�ǰ�ڵ�ĸ��ڵ������
select connect_by_root name,sc_district.* from sc_district start with parent_id is null
connect by prior  id=parent_id 
--connect_by_isleaf���������жϵ�ǰ�ڵ��Ƿ�����¼��ڵ㣬��������Ļ���˵������Ҷ�ӽڵ㣬���ﷵ��0����֮���ﷵ��1��
select connect_by_isleaf,sc_district.* from sc_district start with parent_id is null
connect by prior  id=parent_id 







--�����Զ��庯������������
select * from test1
--��������
CREATE OR REPLACE FUNCTION f_test1_sing(p_value in VARCHAR2)RETURN VARCHAR2   
deterministic IS     
BEGIN   
  RETURN p_value;  
END; 

--������������
CREATE INDEX idx_f_sing_y ON test1(f_test1_sing(name));  
ANALYZE TABLE test1 compute STATISTICS FOR TABLE FOR ALL indexes FOR ALL indexed COLUMNS; 

--��ѯ
select t.* from test1 t where f_test1_sing(name)='tom'

--�޸ĺ�������
CREATE OR REPLACE FUNCTION f_test1_sing(p_value in VARCHAR2)RETURN VARCHAR2   
deterministic IS     
BEGIN   
  RETURN p_value||'$';  
END; 

--�ٴβ�ѯ
--������������ˣ��Ѿ��޸Ĺ��ĺ��� �������ٴβ�ѯ����û��
select t.* from test1 t where f_test1_sing(name)='tom'--�ڶ����޸ĵĺ�����ƥ�������tom$
----ʹ��hints���������󣬲鲻�����ϣ���ȷ�� 
SELECT /*+no_index(t)*/ * FROM test1 t where f_test1_sing(name)='tom'
--ɾ������ �������´��������Ժ󣬲Ż���ݵڶ����޸ĵĺ����Ĺ�����ƥ���ѯ�Ľ��
DROP INDEX idx_f_sing_y; 
 

--merge�÷�
merge into test2 t2
using test1 t1
on(t1.id=t2.id)
when matched then
update set t2.age=1
when not matched then
insert  values(t1.id,t1.name,null,null,null)

--group_test
create table group_test (group_id int, job varchar2(10), name varchar2(10), salary int);

insert into group_test values (10,'Coding',    'Bruce',1000);
insert into group_test values (10,'Programmer','Clair',1000);
insert into group_test values (10,'Architect', 'Gideon',1000);
insert into group_test values (10,'Director',  'Hill',1000);

insert into group_test values (20,'Coding',    'Jason',2000);
insert into group_test values (20,'Programmer','Joey',2000);
insert into group_test values (20,'Architect', 'Martin',2000);
insert into group_test values (20,'Director',  'Michael',2000);

insert into group_test values (30,'Coding',    'Rebecca',3000);
insert into group_test values (30,'Programmer','Rex',3000);
insert into group_test values (30,'Architect', 'Richard',3000);
insert into group_test values (30,'Director',  'Sabrina',3000);

insert into group_test values (40,'Coding',    'Samuel',4000);
insert into group_test values (40,'Programmer','Susy',4000);
insert into group_test values (40,'Architect', 'Tina',4000);
insert into group_test values (40,'Director',  'Wendy',4000);

select * from group_test;
--��ͨ��id���飬���
select group_id,sum(salary) from group_test group by group_id;
--��group_id������ͨ��roolup����---����С����з��飬ͬʱ���ܼ�
select group_id,sum(salary) from group_test group by rollup(group_id);

--rollup���е����
select group_id,job,sum(salary) from group_test group by rollup(group_id, job);

--grouping����  ���ĳһ����Ϊgrouping�������ص�����'1'ʱ����ô�����0��ô��ʾ���и�����ͳ�ƵĽ���������1����
--http://blog.itpub.net/519536/viewspace-610995/
select group_id,job,grouping(GROUP_ID),grouping(JOB),sum(salary) from group_test group by rollup(group_id, job);
--cube  http://blog.itpub.net/519536/viewspace-610997/
select group_id,job,grouping(GROUP_ID),grouping(JOB),sum(salary) from group_test group by cube(group_id, job) order by 1;


--abcd4���֣�����ϵ�����
with tmp as
   (
      select 'A' str from dual
      union all
       select 'B' str from dual
       union all
       select 'C' str from dual
       union all
       select 'D' str from dual
   )
   select replace(sys_connect_by_path(str, ','), ',') str
     from tmp
     connect by prior str < str and prior dbms_random.value is not null order by str;
--�����һ������չ������ ֻҪ�޸�4Ϊ�������־�����  
SELECT LISTAGG(c) WITHIN GROUP(ORDER BY c)
   FROM (SELECT LEVEL bits FROM DUAL CONNECT BY LEVEL<=POWER(2, 4)-1)
       ,(SELECT CHR(64+LEVEL) c,POWER(2,LEVEL-1) b FROM DUAL CONNECT BY LEVEL<=4)
 WHERE BITAND(bits,b)>0
 GROUP BY bits;
 --����3
 SELECT COL1 || COL2 || COL3 || COL4
    FROM (SELECT *
            FROM (SELECT 'A' COL1, 'B' COL2, 'C' COL3, 'D' COL4 FROM DUAL)
           GROUP BY CUBE(COL1, COL2, COL3, COL4))
   ORDER BY 1 NULLS LAST;
   
   
   
   
--��ת��  listagg()within group()����
 with temp as(  
  select 'China' nation ,'Guangzhou' city from dual union all  
  select 'China' nation ,'Shanghai' city from dual union all  
  select 'China' nation ,'Beijing' city from dual union all  
  select 'USA' nation ,'New York' city from dual union all  
  select 'USA' nation ,'Bostom' city from dual union all  
  select 'Japan' nation ,'Tokyo' city from dual   
)  
select nation,listagg(city,',') within GROUP (order by city)  
from temp  
group by nation    
     
     
