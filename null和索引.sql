--�ò��Գ�֮�� ���Ʊ�ɽ4.1.3 null������С��
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

--��������
create unique index hc_i_c on hc_testc(id,name)

select index_name,num_rows from user_indexes where index_name='HC_I_C'
--index_name  num_rows
--hc_i_c 4
--��ʾ�����������4�����ݣ�����֮ǰ��insert ��5�����ݵġ�������Ϊnull��������.��������ط��������n��(null,null)������

--��������null��ִ�мƻ��Ĺ�ϵ
--F5ִ��
select * from hc_testc where id is  null
--SELECT STATEMENT, GOAL = ALL_ROWS			3	1	6
-- TABLE ACCESS FULL	DALIMSDATA	HC_TESTC	3	1	6

--��ִ��
select * from hc_testc where id is not null
--SELECT STATEMENT, GOAL = ALL_ROWS			1	2	12
-- INDEX FULL SCAN	DALIMSDATA	HC_I_C	1	2	12
--���Կ���is null����û������������Ϊname in null ���ܻ��ҵ�(null,null)����������,��(nulll,null)�ǲ��������������ġ������������������
--����һ����not null��Լ���Ļ�,��ô��ѯ�ͻ�������,����Ͳ���������.

---------------------------------------------------------------------------------------------------------------------------------------
--�������ĳһ��������˵��������������null�ģ���������is null �����������Ļ�������ô��?
drop index hc_i_c
--��������α�е� ��������,�����0�������дʲô
create index hc_i_c on hc_testc(id,0)
--ִ�� ��ʾ��5������ ����������һ����
select index_name,num_rows from user_indexes where index_name='HC_I_C'
--ִ��
select * from hc_testc where id is null
--SELECT STATEMENT, GOAL = ALL_ROWS			0	1	6
-- TABLE ACCESS BY INDEX ROWID	DALIMSDATA	HC_TESTC	0	1	6
--  INDEX RANGE SCAN	DALIMSDATA	HC_I_C	0	1	

--���Կ��������Ļ�is null��������������


---------------------------------------------------------------------
--ʵ�ʰ���:���һ������ϵͳ��ĳ���е���status�ֶ�ֻ�洢 �Ѵ����δ�������Ѵ����������ȥ��ѯ�Ļ��᲻�Ǻܴ�Ϊ�˼���������ά������
--�Ϳ������ⲿ���Ѵ�������ݲ�������
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

--����һ�����ں���(decode)��������name�ֶβ�Ϊ0�Ķ�ת��Ϊnull�ˣ��ٸ�������Ĳ��Կ���֪��,�ⲿ��ת�������ݿ϶�����������
create index hc_i_c on hc_testc(decode(name,0,0,null))

--ִ�� ��ʾֻ��4������
select index_name,num_rows from user_indexes where index_name='HC_I_C'

