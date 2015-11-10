###任何跟Null的比较操作都返回unknown,判断和比较规则如下:
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

###null做+、-、*、/运算结果还是Null，但是做||运算结果就是||后面的值.在not、and、or、运算中，规则如下:
####*NOT:如果是true，则返回false，如果是false则返回true，其他都返回unknown
####*TRUE:如果是true，才返回true,有一个false,则返回false,其他都返回unknown
####*OR:如果全为false，才返回false，有一个true，则返回true，其他都返回unknown
