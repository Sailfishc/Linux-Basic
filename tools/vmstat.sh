# vmstat：vmstat 是一个常用的系统性能分析工具，主要用来分析系统的内存使用情况，也常用来分 析 CPU 上下文切换和中断的次数
# 每隔 5 秒输出 1 组数据
vmstat 5

#procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
# r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
# 1  0      0 266360 181252 2543424    0    0     0    11    2    4  1  1 99  0  0
# 0  0      0 264388 181252 2543456    0    0     0     0 1800 3314  1  1 98  0  0

# cs(context switch)是每秒上下文切换的次数。
# in(interrupt)则是每秒中断的次数。
# r(Running or Runnable)是就绪队列的长度，也就是正在运行和等待 CPU 的进程 数。
# b(Blocked)则是处于不可中断睡眠状态的进程数。

# vmstat给出的是系统整体的上下文切换情况
# 要想查看每个进程的详细情况，就需要使用 我们前面提到过的 pidstat 了。给它加上 -w 选项，你就可以查看每个进程上下文切换的情 况了。

# 每隔 5 秒输出 1 组数据
 pidstat -w 5

#07:47:19 AM   UID       PID   cswch/s nvcswch/s  Command
#07:47:24 AM     0         6      0.40      0.00  ksoftirqd/0
#07:47:24 AM     0         7      0.60      0.00  migration/0
#07:47:24 AM     0         9     65.40      0.00  rcu_sched
#07:47:24 AM     0        11      0.40      0.00  watchdog/0
#07:47:24 AM     0        12      0.40      0.00  watchdog/1
#07:47:24 AM     0        13      0.20      0.00  migration/1
#07:47:24 AM     0        14      0.80      0.00  ksoftirqd/1

# cswch:表示每秒自愿上下文切换 (voluntary context switches)的次数：
# 自愿上下文切换：是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、 内存等系统资源不足时，就会发生自愿上下文切换。
# nvcswch:表示每秒非自愿上下文 切换(non voluntary context switches)的次数。
# 非自愿上下文切换：则是指进程由于时间片已到等原因，被系统强制调度，进而发生的 上下文切换