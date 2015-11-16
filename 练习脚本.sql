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

--普通链接查询
select * from test1,test2 where test1.id=test2.id
--内链
select  * from test1 inner join test2 on test1.id=test2.id
--全外链
select * from test1 full outer join test2 on test1.type1=test2.type1
--笛卡尔乘积 和 两表关联不加任何条件 一样的查询结果
select * from test1 cross join test2 where test1.id>5

select id from test1 union select id from test2



declare
 
begin 
 update test2 set name='aaa' where id=7;
    dbms_output.put_line(to_char(sql%rowcount));
 end;



-- 存储过程
create or replace procedure testPro(
i in number,
j in number
) is
var_sum number;
begin
    var_sum:=i+j;
    dbms_output.put_line(var_sum);
end testPro;
       

--EXECUTE testPro(2,3); 错误的写法

declare
v_sql varchar(100);
begin
v_sql:='begin testPro(:i,:j);end;';
execute immediate v_sql using in '1',in '2';
end;

--set serveroutput on 也是错误的写法
 --exec testPro(1,2) 

--序列
create sequence test_quence 
start with 1
increment by 1 
nomaxvalue
nocycle
cache 10

--利用序列 来插入数据
insert into test2 values(test_quence.nextval,'Rr',13,'','');--currval 表示序列当前的值，nextval表示 下一个值
--查询序列信息  试图名称要大写
select * from USER_SEQUENCES where sequence_name='TEST_QUENCE'
--查询 序列下一个值
select test_quence.nextval from dual


--创建试图
create view test_view
as
select * from test2

--查询试图
select * from test_view
--修改试图的方式来 修改原始数据
update test_view set name='b' where id=11

--查询可以被修改的试图/列  用yes/no 表示
select * from user_updatable_columns where table_name='TEST_VIEW'

       
--创建用户
create user huangchao identified by "000000";
grant create session to huangchao;  
           grant create table to  huangchao;  
           grant create tablespace to  huangchao;  
           grant create view to  huangchao;
           grant connect, resource to huangchao;
--跨库查询   huangchao是用户        
select * from huangchao.test3

--查询 锁类型
select * from v$lock_type where type in ('TX','TM')

--批量修改数据
declare
begin 
for cur in (select id,age,name from test1) loop
 update test2 set name=cur.name,age=cur.age where id=cur.id;
  end loop;
 end;

--同时修改多条数据
update test2 set (name,age)=(select name,age from test1 where test1.id=4) where test2.id=2



--游标
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

--行级触发器
create or replace trigger delete_test1_trigger
after delete
on test1
-for each row
begin 
 delete test2 where id=:old.id;
end;


select t1.*,t2.id from test1 t1  join test2 t2 on t1.id=t2.id(+)--左链接
select t1.*,t2.id from test1 t1  join test2 t2 on t1.id(+)=t2.id--右链接

--递归查询 实例
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

--递归查询
select a.*, b.name parent_name
 from
 (select name, ID, PARENT_ID, LEVEL
 from test_lvl1
 start with parent_id is null
 connect by prior id=PARENT_ID) a,
 test_lvl1 b
 where a.parent_id=b.id(+)


--递归查询实例2
CREATE TABLE SC_DISTRICT
(
  ID         NUMBER(10)                  NOT NULL,
  PARENT_ID  NUMBER(10),
  NAME       VARCHAR2(255 BYTE)          NOT NULL
);
INSERT INTO SC_DISTRICT(ID,NAME) VALUES(1,'四川省');

INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(2,1,'巴中市');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(3,1,'达州市'); 

INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(4,2,'巴州区');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(5,2,'通江县');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(6,2,'平昌县');

INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(7,3,'通川区');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(8,3,'宣汉县');

INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(9,8,'塔河乡');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(10,8,'三河乡');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(11,8,'胡家镇');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(12,8,'南坝镇');
 
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(13,6,'大寨乡');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(14,6,'响滩镇');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(15,6,'龙岗镇');
INSERT INTO SC_DISTRICT(ID,PARENT_ID,NAME) VALUES(16,6,'白衣镇');

select * from sc_district
--递归查询2
select * from sc_district start with parent_id is null
connect by prior  id=parent_id 
--connect_by_root函数用来列的前面，记录的是当前节点的根节点的内容
select connect_by_root name,sc_district.* from sc_district start with parent_id is null
connect by prior  id=parent_id 
--connect_by_isleaf函数用来判断当前节点是否包含下级节点，如果包含的话，说明不是叶子节点，这里返回0；反之这里返回1。
select connect_by_isleaf,sc_district.* from sc_district start with parent_id is null
connect by prior  id=parent_id 







--基于自定义函数索引的问题
select * from test1
--创建函数
CREATE OR REPLACE FUNCTION f_test1_sing(p_value in VARCHAR2)RETURN VARCHAR2   
deterministic IS     
BEGIN   
  RETURN p_value;  
END; 

--创建函数索引
CREATE INDEX idx_f_sing_y ON test1(f_test1_sing(name));  
ANALYZE TABLE test1 compute STATISTICS FOR TABLE FOR ALL indexes FOR ALL indexed COLUMNS; 

--查询
select t.* from test1 t where f_test1_sing(name)='tom'

--修改函数代码
CREATE OR REPLACE FUNCTION f_test1_sing(p_value in VARCHAR2)RETURN VARCHAR2   
deterministic IS     
BEGIN   
  RETURN p_value||'$';  
END; 

--再次查询
--这里问题就来了，已经修改过的函数 在这里再次查询后结果没变
select t.* from test1 t where f_test1_sing(name)='tom'--第二次修改的函数的匹配规则是tom$
----使用hints禁用索引后，查不到资料，正确。 
SELECT /*+no_index(t)*/ * FROM test1 t where f_test1_sing(name)='tom'
--删除索引 并且重新创建索引以后，才会根据第二次修改的函数的规则来匹配查询的结果
DROP INDEX idx_f_sing_y; 
 

--merge用法
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
--普通按id分组，求和
select group_id,sum(salary) from group_test group by group_id;
--对group_id进行普通的roolup操作---按照小组进行分组，同时求总计
select group_id,sum(salary) from group_test group by rollup(group_id);

--rollup两列的情况
select group_id,job,sum(salary) from group_test group by rollup(group_id, job);

--grouping函数  如果某一行因为grouping函数返回的数据'1'时，那么如果是0那么表示是有该列来统计的结果，如果是1则不是
--http://blog.itpub.net/519536/viewspace-610995/
select group_id,job,grouping(GROUP_ID),grouping(JOB),sum(salary) from group_test group by rollup(group_id, job);
--cube  http://blog.itpub.net/519536/viewspace-610997/
select group_id,job,grouping(GROUP_ID),grouping(JOB),sum(salary) from group_test group by cube(group_id, job) order by 1;


--abcd4个字，求组合的种类
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
--这个是一个可扩展的例子 只要修改4为其他数字就行了  
SELECT LISTAGG(c) WITHIN GROUP(ORDER BY c)
   FROM (SELECT LEVEL bits FROM DUAL CONNECT BY LEVEL<=POWER(2, 4)-1)
       ,(SELECT CHR(64+LEVEL) c,POWER(2,LEVEL-1) b FROM DUAL CONNECT BY LEVEL<=4)
 WHERE BITAND(bits,b)>0
 GROUP BY bits;
 --方法3
 SELECT COL1 || COL2 || COL3 || COL4
    FROM (SELECT *
            FROM (SELECT 'A' COL1, 'B' COL2, 'C' COL3, 'D' COL4 FROM DUAL)
           GROUP BY CUBE(COL1, COL2, COL3, COL4))
   ORDER BY 1 NULLS LAST;
   
   
   
   
--行转列  listagg()within group()方法
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
     
     
