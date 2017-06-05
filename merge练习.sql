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
insert into hc_testB values('a',10);
insert into hc_testB values('c',20);


select * from hc_testA
--name money
--a	20
--b	20
select * from hc_testB
--name money
--a	10
--c	20

--普通用法
merge into hc_testB tb
using hc_testA ta
on(ta.name=tb.name)
when matched then
update set tb.money=ta.money+tb.money
when not matched then
insert values(ta.name,ta.money)

--执行以后查询B,这里有两个地方发生了改变，一个是新增了数据b，第二个是数据a有原来的10 变成了30
select * from hc_testB
--name money
--a	30
--c	20
--b 20



--update、insert 二选一，且可以添加条件
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


/*这里新增了delete，值得注意的是最后的delete语句，生效的前提必须是ta.name=tb.name，所以如果delete条件写成tb.name=a的话，那么B表中的a数
据会被删除.但是如果写成tb.name=c的话，那么B表中的数据将不会被删除*/
merge into hc_testB tb
using hc_testA ta
on (ta.name=tb.name)
when matched then
update set tb.money=ta.money+tb.money--在这里可以添加where语句，来筛选数据.谨记delete 的where语句必须放到最后不然会报错
delete where (tb.name='c')
select * from hc_testB


--无条件insert 如果on条件是一个恒等或者恒不等的话,相当于把A表的数据直接添加到B表中，雷同于insert..select
merge into hc_testB tb
using hc_testA ta
on (1=2)
when not matched then
insert values(ta.name,ta.money)


/*merge误区,这里在A表中新增一个a,15的数据。然后执行第一个个sql语句就会报错：ORA-30926: 无法在源表中获得一组稳定的行。
报错的原因是A表中匹配了多条数据(有两个a)。解决方法有两个，一个是给name字段创建主键，防止重复。如果该数据已经有其他字段是主键的话，那么就
用第二种方法，也就是下面展示的方法。该方法是把同名称的数据 作为一个分组，这就变成了一条数据了*/
insert into hc_testA values('a',15)
--误区解决方法
merge into hc_testB tb
using(select name,sum(money) money from hc_testA group by name) ta
on(ta.name=tb.name)
when matched then
update set tb.money=ta.money+tb.money


--自表更新
merge into hc_testB tb
using (select * from hc_testB where name='d') ta
on(ta.name=tb.name)
when matched then
update set tb.money=100
when not matched then
insert values('d',100)

--此语句原意是如果B表中存在d数据的话那么就修改其money为100,如果没有就插入数据,但是执行过以后发现B表没有发生任何的变化,原因是uning后面的
--必须包含要更新或者插入的行，而B表中根本就不存在name=d的数据，可以改成:
merge into hc_testB tb
using (select count(0) cnt from hc_testB where name='d') ta
on(cnt<>0)
when matched then
update set tb.money=100
when not matched then
insert values('d',100)


--真实案例一
--如何将hc_testC表中id=1的name值改成id=2的name值，将id=2的name值改成id=1的name值
create table hc_testC
(
id number,
name nvarchar2(20)
)

insert into hc_testC values(1,'a');
insert into hc_testC values(2,'b');

--如果安装常规的方法
update hc_testC set name=(select name from hc_testC where id=2) where id=1;
--那么此时id=1的name的值已经被修改了，又该如何去满足修改id=2的值修改成id=1的name的值呢？
--所以可以用虚拟表和merge来实现
merge into hc_testC tc
using(select 1 id,(select name from hc_testC where id=2) name from dual
      union all
      select 2,(select name from hc_testC where id=1) name from dual) t--此方法虚拟表是关键所在
on(tc.id=t.id)
when matched then
update set tc.name=t.name
