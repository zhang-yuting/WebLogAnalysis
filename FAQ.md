<h1>FAQ</h1>

这里为用户提供Web访问量分析器常见问题解答


<b>是否支持Windows系统？</b>

	目前本项目不支持Windows系统。
  
<b>那么IIS也不支持了吧？</b>

	可以把IIS日志通过复制或NFS共享到linux系统上，然后用本工具进行分析
	
<b>分析1年的日志为什么不响应？</b>

	如果日志数据量太大，比如达到100GB以上时，分析日志需要很长时间，甚至可能由于内存不足导致分析失败。
	
<b>为什么提示没有权限执行？</b>

	执行./weblog-analysis.sh脚本需要有脚本执行权限，另外当前用户对web日志也需要有读取权限。
	为weblog-analysis.sh赋予执行权限的命令：
	chmod u+x weblog-analysis.sh
