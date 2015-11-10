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

