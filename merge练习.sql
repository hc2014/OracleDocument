create table hc_testA
(
name nvarchar2(20),
mongey number
);
create table hc_testB
(
name nvarchar2(20),
money number
)


insert into hc_testA values('a',20);
insert into hc_testA values('b',20);
insert into hc_testA values('a',10);
insert into hc_testA values('c',20);


select * from hc_testA
--name money
--a	20
--b	20
select * from hc_testB
--name money
--a	10
--c	20

--��ͨ�÷�
merge into hc_testB tb
using hc_testA ta
on(ta.name=tb.name)
when matched then
update set tb.money=ta.money+tb.money
when not matched then
insert values(ta.name,ta.money)

--ִ���Ժ��ѯB,�����������ط������˸ı䣬һ��������������b���ڶ���������a��ԭ����10 �����30
select * from hc_testB
--name money
--a	30
--c	20
--b 20



--update��insert ��ѡһ���ҿ����������
merge into hc_testB tb
using hc_testA ta
on (ta.name=tb.name)
when matched then
update set tb.money=ta.money/2+5 where ta.name='a'
select * from hc_testB
--name money
--a	15
--c	20
--b 20


/*����������delete��ֵ��ע���������delete��䣬��Ч��ǰ�������ta.name=tb.name���������delete����д��tb.name=a�Ļ�����ôB���е�a��
�ݻᱻɾ��.�������д��tb.name=c�Ļ�����ôB���е����ݽ����ᱻɾ��*/
merge into hc_testB tb
using hc_testA ta
on (ta.name=tb.name)
when matched then
update set tb.money=ta.money+tb.money--������������where��䣬��ɸѡ����.����delete ��where������ŵ����Ȼ�ᱨ��
delete where (tb.name='c')
select * from hc_testB


--������insert ���on������һ����Ȼ��ߺ㲻�ȵĻ�,�൱�ڰ�A�������ֱ����ӵ�B���У���ͬ��insert..select
merge into hc_testB tb
using hc_testA ta
on (1=2)
when not matched then
insert values(ta.name,ta.money)


/*merge����,������A��������һ��a,15�����ݡ�Ȼ��ִ�е�һ����sql���ͻᱨ��ORA-30926: �޷���Դ���л��һ���ȶ����С�
�����ԭ����A����ƥ���˶�������(������a)�����������������һ���Ǹ�name�ֶδ�����������ֹ�ظ�������������Ѿ��������ֶ��������Ļ�����ô��
�õڶ��ַ�����Ҳ��������չʾ�ķ������÷����ǰ�ͬ���Ƶ����� ��Ϊһ�����飬��ͱ����һ��������*/
insert into hc_testA values('a',15)
--�����������
merge into hc_testB tb
using(select name,sum(money) money from hc_testA group by name) ta
on(ta.name=tb.name)
when matched then
update set tb.money=ta.money+tb.money


--�Ա����
merge into hc_testB tb
using (select * from hc_testB where name='d') ta
on(ta.name=tb.name)
when matched then
update set tb.money=100
when not matched then
insert values('d',100)

--�����ԭ�������B���д���d���ݵĻ���ô���޸���moneyΪ100,���û�оͲ�������,����ִ�й��Ժ���B��û�з����κεı仯,ԭ����uning�����
--�������Ҫ���»��߲�����У���B���и����Ͳ�����name=d�����ݣ����Ըĳ�:
merge into hc_testB tb
using (select count(0) cnt from hc_testB where name='d') ta
on(cnt<>0)
when matched then
update set tb.money=100
when not matched then
insert values('d',100)


--��ʵ����һ
--��ν�hc_testC����id=1��nameֵ�ĳ�id=2��nameֵ����id=2��nameֵ�ĳ�id=1��nameֵ
create table hc_testC
(
id number,
name nvarchar2(20)
)

insert into hc_testC values(1,'a');
insert into hc_testC values(2,'b');

--�����װ����ķ���
update hc_testC set name=(select name from hc_testC where id=2) where id=1;
--��ô��ʱid=1��name��ֵ�Ѿ����޸��ˣ��ָ����ȥ�����޸�id=2��ֵ�޸ĳ�id=1��name��ֵ�أ�
--���Կ�����������merge��ʵ��
merge into hc_testC tc
using(select 1 id,(select name from hc_testC where id=2) name from dual
      union all
      select 2,(select name from hc_testC where id=1) name from dual) t--�˷���������ǹؼ�����
on(tc.id=t.id)
when matched then
update set tc.name=t.name
