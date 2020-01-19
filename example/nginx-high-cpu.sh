# 模拟Nginx 繁忙CPU案例
# 需要工具：安装 docker、sysstat、perf、ab 等工具，如 apt install docker.io sysstat linux-tools-common apache2-utils

# 启动Nginx

# 启动PHP服务

# 192.168.0.10 是第一台虚拟机的 IP 地址
curl http://192.168.0.10:10000/

# 并发 10 个请求测试 Nginx 性能，总共测试 100 个请求
ab -c 10 -n 100 http://192.168.0.10:10000/

# This is ApacheBench, Version 2.3 <$Revision: 1706008 $> 4 Copyright 1996 Adam Twiss, Zeus Technology Ltd,
# ...
# Requests per second: 11.63 [#/sec] (mean)
# Time per request: 859.942 [ms] (mean)

#从 ab 的输出结果我们可以看到，Nginx 能承受的每秒平均请求数只有 11.63。你一定在吐 槽，这也太差了吧。那到底是哪里出了问题呢?我们用 top 和 pidstat 再来观察下

# 将测试总请求数加到10000
ab -c 10 -n 10000 http://10.240.0.5:10000/

#使用top命令，按下数字1，切换到每个CPU的使用率

#系统中有几个 php-fpm 进程的 CPU 使用率加起来接近 200%;而每个 CPU 的用户使用率(us)也已经超过了 98%，
# 接近饱和。这样，我们就可以确认，正是用 户空间的 php-fpm 进程，导致 CPU 使用率骤升。

# 如何知道哪个函数导致CPU使用率升高呢？
# -g 开启调用关系分析，-p 指定 php-fpm 的进程号 21515
perf top -g -p 21515


# 按方向键切换到 php-fpm，再按下回车键展开 php-fpm 的调用关系，你会发现，调用关 系最终到了 sqrt 和 add_function
# 通过看调用链的源码去分析那几个函数导致CPU占用率升高，进行优化

# 再次使用ab进行测试
ab -c 10 -n 10000 http://10.240.0.5:10000/

#Complete requests: 10000
#Requests per second: 2237.04 [#/sec] (mean)

#每秒的平均请求数，已经从原来的 11 变成了 2237。