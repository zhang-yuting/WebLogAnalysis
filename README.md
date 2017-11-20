# WebLogAnalysis
Web访问量分析器通过读取Web服务器的日志文件，按字段提取其中的数据，根据功能生成统计报告，并根据执行时间将报告存储为文件。

环境要求：

	1.支持的操作系统：Web访问量分析器目前支持CentOS或RedHat Linux，
	2.支持的shell环境：bash

安装：
	
	将weblog-analysis.sh文件复制到apache或nginx日志所在目录

使用：		

	执行./weblog-analysis.sh启动Web访问分析工具，工具支持2个参数：
	-t  可选，-t参数后可输入过滤日志的条件，支持正则表达式例如：-t web1-access*.log。不指定该参数默认分析当前目录所有日志。
	-s  可选，指定统计多长时间范围内的日志，例如统计10天内的日志：-s "-10 day"。默认分析30天内的日志。

使用示例：

	./weblog-analysis.sh -t web1-access*.log -s "-10 day"

正确运行后返回的结果为10天内每小时访问量的统计列表，按时间顺序排序：

	时间               访问量
	2017-11-01-00       123
	2017-11-01-01      5345
	2017-11-01-02      3423
	2017-11-01-03      1123
	2017-11-01-04      5553
	2017-11-01-05     89123
	...


统计网站页面的平均访问时间

./weblog-analysis.sh
-t web1-access*.log -s "-10 day" -c avg_response

正确运行后返回的结果为10天内网站页面的平均访问时间，可看出浏览者需要等待多长时间才能获得页面，从而确定性能问题出在哪里。按时间顺序排序：

统计开始时间    
    平均访问时间（秒）

2017-11-01    
     1.45



按平均访问时间对网站页面进行排序

./weblog-analysis.sh
-t web1-access*.log -s "-10 day" -c avg_response_pages

正确运行后返回的结果为10天内按平均访问时间对网站页面进行排序，显示的是平均访问时间最长的10个页面：

页面地址                                       平均访问时间（秒）                  

/sales/models/orders/pay.php          3.89

/user/login.action                    2.14

/user/logout.action                   2.09

/user/reg.action                              2.01

/user/profile.php                             1.98

/images/index_flag.jsp                1.97

/css/allthing.css                             1.88

/js/jquery.js                         1.85

/index.html                           1.52

/sales/list.jsp                       1.41

 

按访问量大小对网站页面进行排序

./weblog-analysis.sh
-t web1-access*.log -s "-10 day" -c count_pages

正确运行后返回的结果为10天内按访问量大小对网站页面进行排序(不包括图片，脚本或样式表)，显示的是访问最多的10个页面：

页面地址                                       平均访问时间（秒）                  

/index.html                           15321

/user/login.action                    12129

/sales/list.jsp                       11012

/sales/itemShow.jsp                   10842

/sales/iloveit.jsp                            10526

/games/play.php                       
9231

/games/select.php                             
9182

/sales/startItem/phone/iphonex.html            9081

/sales/startItem/car/tesla/models.html  9722

