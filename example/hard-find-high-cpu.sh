# Geektime 06

# 系统配置：2C8G
# Nginx + Php

# 现象：使用ab 100并发请求 每秒请求数87（比较低）

# 并发 100 个请求测试 Nginx 性能，总共测试 1000 个请求
ab -c 100 -n 1000 http://192.168.0.10:10000/

#This is ApacheBench, Version 2.3 <$Revision: 1706008 $> 4 Copyright 1996 Adam Twiss, Zeus Technology Ltd,
#...
#Requests per second: 87.86 [#/sec] (mean)
#Time per request: 1138.229 [ms] (mean)
#...

#将测试的并发请求数改成 5，同时把请求时长设置为 10 分钟
ab -c 5 -t 600 http://192.168.0.10:10000/


# 使用top

# ...
#%Cpu(s): 80.8 us, 15.1 sy,  0.0 ni,  2.8 id,  0.0 wa,  0.0 hi,  1.3 si,  0.0 st
#...
#
#  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
# 6882 root      20   0    8456   5052   3884 S   2.7  0.1   0:04.78 docker-containe
# 6947 systemd+  20   0   33104   3716   2340 S   2.7  0.0   0:04.92 nginx
# 7494 daemon    20   0  336696  15012   7332 S   2.0  0.2   0:03.55 php-fpm
# 7495 daemon    20   0  336696  15160   7480 S   2.0  0.2   0:03.55 php-fpm
#10547 daemon    20   0  336696  16200   8520 S   2.0  0.2   0:03.13 php-fpm
#10155 daemon    20   0  336696  16200   8520 S   1.7  0.2   0:03.12 php-fpm
#10552 daemon    20   0  336696  16200   8520 S   1.7  0.2   0:03.12 php-fpm
#15006 root      20   0 1168608  66264  37536 S   1.0  0.8   9:39.51 dockerd
# 4323 root      20   0       0      0      0 I   0.3  0.0   0:00.87 kworker/u4:1
#...

#现象：CPU使用率很高，但是没有CPU异常的进程

# 间隔 1 秒输出一组数据（按 Ctrl+C 结束）
# 使用pidstat再次查看cpu使用情况
pidstat 1

#...
#04:36:24      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
#04:36:25        0      6882    1.00    3.00    0.00    0.00    4.00     0  docker-containe
#04:36:25      101      6947    1.00    2.00    0.00    1.00    3.00     1  nginx
#04:36:25        1     14834    1.00    1.00    0.00    1.00    2.00     0  php-fpm
#04:36:25        1     14835    1.00    1.00    0.00    1.00    2.00     0  php-fpm
#04:36:25        1     14845    0.00    2.00    0.00    2.00    2.00     1  php-fpm
#04:36:25        1     14855    0.00    1.00    0.00    1.00    1.00     1  php-fpm
#04:36:25        1     14857    1.00    2.00    0.00    1.00    3.00     0  php-fpm
#04:36:25        0     15006    0.00    1.00    0.00    0.00    1.00     0  dockerd
#04:36:25        0     15801    0.00    1.00    0.00    0.00    1.00     1  pidstat
#04:36:25        1     17084    1.00    0.00    0.00    2.00    1.00     0  stress
#04:36:25        0     31116    0.00    1.00    0.00    0.00    1.00     0  atopacctd
#...

# 现象：也没有CPU高的进程

# 再次使用top

#top - 04:58:24 up 14 days, 15:47,  1 user,  load average: 3.39, 3.82, 2.74
#Tasks: 149 total,   6 running,  93 sleeping,   0 stopped,   0 zombie
#%Cpu(s): 77.7 us, 19.3 sy,  0.0 ni,  2.0 id,  0.0 wa,  0.0 hi,  1.0 si,  0.0 st
#KiB Mem :  8169348 total,  2543916 free,   457976 used,  5167456 buff/cache
#KiB Swap:        0 total,        0 free,        0 used.  7363908 avail Mem
#
#  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
# 6947 systemd+  20   0   33104   3764   2340 S   4.0  0.0   0:32.69 nginx
# 6882 root      20   0   12108   8360   3884 S   2.0  0.1   0:31.40 docker-containe
#15465 daemon    20   0  336696  15256   7576 S   2.0  0.2   0:00.62 php-fpm
#15466 daemon    20   0  336696  15196   7516 S   2.0  0.2   0:00.62 php-fpm
#15489 daemon    20   0  336696  16200   8520 S   2.0  0.2   0:00.62 php-fpm
# 6948 systemd+  20   0   33104   3764   2340 S   1.0  0.0   0:00.95 nginx
#15006 root      20   0 1168608  65632  37536 S   1.0  0.8   9:51.09 dockerd
#15476 daemon    20   0  336696  16200   8520 S   1.0  0.2   0:00.61 php-fpm
#15477 daemon    20   0  336696  16200   8520 S   1.0  0.2   0:00.61 php-fpm
#24340 daemon    20   0    8184   1616    536 R   1.0  0.0   0:00.01 stress
#24342 daemon    20   0    8196   1580    492 R   1.0  0.0   0:00.01 stress
#24344 daemon    20   0    8188   1056    492 R   1.0  0.0   0:00.01 stress
#24347 daemon    20   0    8184   1356    540 R   1.0  0.0   0:00.01 stress
#...

# 现象：很难发现的一个问题：Running的进程有6个，并且R状态的进程不是nginx和php的，是stress的

# 分析stress进程
pidstat -p 24344

# 16:14:55      UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command

# 现象：没有任何输出

# 使用ps再次确认
# 从所有进程中查找 PID 是 24344 的进程
ps aux | grep 24344
#root      9628  0.0  0.0  14856  1096 pts/0    S+   16:15   0:00 grep --color=auto 24344

# 现象：还是没有输出

# 再次使用top确认
top

#...
#%Cpu(s): 80.9 us, 14.9 sy,  0.0 ni,  2.8 id,  0.0 wa,  0.0 hi,  1.3 si,  0.0 st
#...
#
#  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
# 6882 root      20   0   12108   8360   3884 S   2.7  0.1   0:45.63 docker-containe
# 6947 systemd+  20   0   33104   3764   2340 R   2.7  0.0   0:47.79 nginx
# 3865 daemon    20   0  336696  15056   7376 S   2.0  0.2   0:00.15 php-fpm
#  6779 daemon    20   0    8184   1112    556 R   0.3  0.0   0:00.01 stress
#...

# 现象：看到 stress 进程不存在了，怎么现在还在运行呢？再细看一下 top 的输出，原来，这次 stress 进程的 PID 跟前面不一样了，
# 原来的 PID 24344 不见了，现在的是 6779。


#进程的 PID 在变，这说明什么呢？在我看来，要么是这些进程在不停地重启，要么就是全新的进程，这无非也就两个原因：
#第一个原因，进程在不停地崩溃重启，比如因为段错误、配置错误等等，这时，进程在退出后可能又被监控系统自动重启了。
#第二个原因，这些进程都是短时进程，也就是在其他应用内部通过 exec 调用的外面命令。这些命令一般都只运行很短的时间就会结束，
# 你很难用 top 这种间隔时间比较长的工具发现（上面的案例，我们碰巧发现了）。

#查找一个进程的父进程呢？没错，用 pstree 就可以用树状形式显示所有进程之间的关系：

pstree | grep stress

#        |-docker-containe-+-php-fpm-+-php-fpm---sh---stress
#        |         |-3*[php-fpm---sh---stress---stress]


# 现象：stress 是被 php-fpm 调用的子进程，并且进程数量不止一个

# 找到父进程，进入app分析

# grep 查找看看是不是有代码在调用 stress 命令
grep stress -r app
#app/index.php:// fake I/O with stress (via write()/unlink()).
#app/index.php:$result = exec("/usr/local/bin/stress -t 1 -d 1 2>&1", $output, $status);

#可以看到，源码里对每个请求都会调用一个 stress 命令，模拟 I/O 压力

#前面已经用了 top、pidstat、pstree 等工具，没有发现大量的 stress 进程。那么，还有什么其他的工具可以用吗？
#还记得上一期提到的 perf 吗？它可以用来分析 CPU 性能事件，用在这里就很合适。依旧在第一个终端中运行 perf record -g 命令 ，
# 并等待一会儿（比如 15 秒）后按 Ctrl+C 退出。然后再运行 perf report 查看报告：


# 记录性能事件，等待大约 15 秒后按 Ctrl+C 退出
perf record -g

# 查看报告
perf report


# 现象:stress 占了所有 CPU 时钟事件的 77%，而 stress 调用调用栈中比例最高的，是随机数生成函数 random()，看来它的确就是 CPU 使用率升高的元凶了


# 对于这种短时进程，可以使用专门的工具
#execsnoop 就是一个专为短时进程设计的工具。它通过 ftrace 实时监控进程的 exec() 行为，
# 并输出短时进程的基本信息，包括进程 PID、父进程 PID、命令行参数以及执行的结果。

#可以直接得到 stress 进程的父进程 PID 以及它的命令行参数，并可以发现大量的 stress 进程在不停启动：
# 按 Ctrl+C 结束
execsnoop
#PCOMM            PID    PPID   RET ARGS
#sh               30394  30393    0
#stress           30396  30394    0 /usr/local/bin/stress -t 1 -d 1
#sh               30398  30393    0
#stress           30399  30398    0 /usr/local/bin/stress -t 1 -d 1
#sh               30402  30400    0
#stress           30403  30402    0 /usr/local/bin/stress -t 1 -d 1
#sh               30405  30393    0
#stress           30407  30405    0 /usr/local/bin/stress -t 1 -d 1
#...