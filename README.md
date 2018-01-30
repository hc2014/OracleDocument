### 任何跟Null的比较操作都返回unknown,判断和比较规则如下:
|A值|条件|判断|
|:-----|:-----|:-----|
|10|a is null|false|
|10|a is not  null|true|
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
||TRUE|FALSE|UNKNOWN|
|:-----|:-----|:-----|-----|
|NOT|FALSE|TRUE|UNKNOWN|
***
##### and的逻辑与计算结果
||TRUE|FALSE|UNKNOWN|
|:-----|:-----|:-----|-----|
|AND|TRUE|FALSE|UNKNOWN|
|TRUE|TRUE|FALSE|UNKNOWN|
|FALSE|FALSE|FALSE|FALSE|
|UNKNOWN|UNKNOWN|FALSE|UNKNOWN|
***
##### or的逻辑或计算结果
||TRUE|FALSE|UNKNOWN|
|:-----|:-----|:-----|-----|
|OR|TRUE|FALSE|UNKNOWN|
|TRUE|TRUE|TRUE|TRUE|
|FALSE|TRUE|FALSE|UNKNOWN|
|UNKNOWN|TRUE|UNKNOWN|UNKNOWN|


 ### COALESCE
 COALESCE返回参数列表中第一个非空表达式。必须指定最少两个参数。如果所有的参数都是null，则返回null。Oracle使用短路运算，它依次对每个表达式求值判断它是否为空，而不是对所有表达式都求值后在判断第一个非空值。
 
 
 下面的例子给所有的产品按list_price打9折，如果没有list_price，就按最低价MIN_PRICE算。 如果也没有MIN_PRICE，那么sale就是5. 
  ```
 SELECT product_id, list_price, min_price,
       COALESCE(0.9*list_price, min_price, 5) "Sale"
  FROM product_information
  WHERE supplier_id = 102050
  ORDER BY product_id;
  ```
 
 
 
