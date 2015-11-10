--该测试出之于 剑破冰山4.1.3 null和索引小节
create table hc_testc
(
id number,
name nvarchar2(20)
)
insert into hc_testc values(1,null);
insert into hc_testc values(null,null);
insert into hc_testc values(null,1);
insert into hc_testc values(1,1);
insert into hc_testc values(2,1);

--创建索引
create unique index hc_i_c on hc_testc(id,name)

select index_name,num_rows from user_indexes where index_name='HC_I_C'
--index_name  num_rows
--hc_i_c 4
--显示索引里面存了4条数据，而我之前是insert 了5条数据的。这是因为null不走索引.所以这个地方可以添加n个(null,null)的数据

--再来看看null和执行计划的关系
--F5执行
select * from hc_testc where id is  null
--SELECT STATEMENT, GOAL = ALL_ROWS			3	1	6
-- TABLE ACCESS FULL	DALIMSDATA	HC_TESTC	3	1	6

--再执行
select * from hc_testc where id is not null
--SELECT STATEMENT, GOAL = ALL_ROWS			1	2	12
-- INDEX FULL SCAN	DALIMSDATA	HC_I_C	1	2	12
--可以看出is null条件没有走索引，因为name in null 可能会找到(null,null)这样的数据,而(nulll,null)是不存放在索引里面的。但是如果复合索引中
--任意一列有not null的约束的话,那么查询就会走索引,这里就不做测试了.

---------------------------------------------------------------------------------------------------------------------------------------
--如果对于某一个单列来说存在少数数据是null的，而又想让is null 条件走索引的话，该怎么办?
drop index hc_i_c
--创建具有伪列的 复合索引,后面的0可以随便写什么
create index hc_i_c on hc_testc(id,0)
--执行 显示有5条数据 和期望的是一样的
select index_name,num_rows from user_indexes where index_name='HC_I_C'
--执行
select * from hc_testc where id is null
--SELECT STATEMENT, GOAL = ALL_ROWS			0	1	6
-- TABLE ACCESS BY INDEX ROWID	DALIMSDATA	HC_TESTC	0	1	6
--  INDEX RANGE SCAN	DALIMSDATA	HC_I_C	0	1	

--可以看到这样的话is null条件就走索引了


---------------------------------------------------------------------
--实际案例:如果一个工单系统中某表中的列status字段只存储 已处理和未处理。而已处理的数据再去查询的机会不是很大，为了减少索引的维护费用
--就可以让这部分已处理的数据不走索引
drop index hc_i_c
delete  hc_testc
select * from hc_testc

insert into hc_testc values(1,0);
insert into hc_testc values(2,0);
insert into hc_testc values(3,1);
insert into hc_testc values(4,1);
insert into hc_testc values(5,0);
insert into hc_testc values(6,0);
insert into hc_testc values(7,1);
insert into hc_testc values(8,1);

--创建一个基于函数(decode)的索引，name字段不为0的都转换为null了，再根据上面的测试可以知道,这部分转换的数据肯定不走索引的
create index hc_i_c on hc_testc(decode(name,0,0,null))

--执行 显示只有4条数据
select index_name,num_rows from user_indexes where index_name='HC_I_C'

