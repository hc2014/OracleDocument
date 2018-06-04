### 任何跟Null的比较操作都返回unknown,判断和比较规则如下:
| A值   | 条件             | 判断    |
| :--- | :------------- | :---- |
| 10   | a is null      | false |
| 10   | a is not  null | true  |
|null|a is null|rue
|null|a is not  null|false|
|10|a=null|unknown|
|10|a!=null|unknown|
|null|a=null|unknown|
|null|a!=null|unknown|
|null|a=10|unknown|
|null|a!=10|unknown|

### null做+、-、*、/运算结果还是Null，但是做||运算结果就是||后面的值.在not、and、or、运算中，规则如下:
#####*NOT:如果是true，则返回false，如果是false则返回true，其他都返回unknown
#####*TRUE:如果是true，才返回true,有一个false,则返回false,其他都返回unknown
#####*OR:如果全为false，才返回false，有一个true，则返回true，其他都返回unknown
***
##### not取反的计算结果
|      | TRUE  | FALSE | UNKNOWN |
| :--- | :---- | :---- | ------- |
| NOT  | FALSE | TRUE  | UNKNOWN |
***
##### and的逻辑与计算结果
|         | TRUE    | FALSE | UNKNOWN |
| :------ | :------ | :---- | ------- |
| AND     | TRUE    | FALSE | UNKNOWN |
| TRUE    | TRUE    | FALSE | UNKNOWN |
| FALSE   | FALSE   | FALSE | FALSE   |
| UNKNOWN | UNKNOWN | FALSE | UNKNOWN |
***
##### or的逻辑或计算结果
|         | TRUE | FALSE   | UNKNOWN |
| :------ | :--- | :------ | ------- |
| OR      | TRUE | FALSE   | UNKNOWN |
| TRUE    | TRUE | TRUE    | TRUE    |
| FALSE   | TRUE | FALSE   | UNKNOWN |
| UNKNOWN | TRUE | UNKNOWN | UNKNOWN |


 ### COALESCE
 COALESCE返回参数列表中第一个非空表达式。必须指定最少两个参数。如果所有的参数都是null，则返回null。Oracle使用短路运算，它依次对每个表达式求值判断它是否为空，而不是对所有表达式都求值后在判断第一个非空值。


 下面的例子给所有的产品按list_price打9折，如果没有list_price，就按最低价MIN_PRICE算。 如果也没有MIN_PRICE，那么sale就是5. 
    SELECT product_id, list_price, min_price,
    COALESCE(0.9*list_price, min_price, 5) "Sale"
    FROM product_information
    WHERE supplier_id = 102050
    ORDER BY product_id;
 



### char

char是数据库中定长的字符类型，大多数用来创建 枚举类型的字段，但是也会看到有人当做varchar2一样用来当做字符型字段的数据类型

char 是定长，位数不足就用空格来填充

```
create table hc_test
(
id varchar2(32),
name char(20)
)
```

创建了一个 hc_test 表，其中name 字段 是char(20)，录入数据

```
   ID    NAME
1	1	aaa                 
2	2	bbb                 
```

看起来name 字段的长度是3，但是实际上它的长度是20

```
select length(name) from hc_test where id='1'-- 查询出来的是20
```

现在如果把name 字段改成 varchar2(20)，经过测试，发现原来已经存在的数据，长度依旧是20，它存储的数据是 'aaa           '(17个空格)，而新添加的数据就会根据 修改后的字段vharchar2(20)来，不定长存储数据

```
select length(name) from hc_test
    length(name)
1	20
2	20
3	5
```

所以 在修改完成字段类型后，需要利用 trim 函数把 原来的带空格的数据给修改掉