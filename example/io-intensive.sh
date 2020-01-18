# IO密集型进程

# window one: 模拟 I/O 压力，即不停地执行 sync
stress -i 1 --timeout 600
# 出现问题：iowait无法升高
# 原因：1. iowait无法升高的问题，是因为案例中stress使用的是 sync() 系统调用，它的作用是刷 新缓冲区内存到磁盘中。
# 对于新安装的虚拟机，缓冲区可能比较小，无法产生大的IO压力，这样大部分就都是系统调用的消耗了


# window two:运行 uptime 查看平均负载的变化情况
# -d 参数表示高亮显示变化的区域
watch -d uptime

# window three: 查看 CPU 使用率的变化情况
# -P ALL 表示监控所有 CPU，后面数字 5 表示间隔 5 秒后输出一组数据
mpstat -P ALL 5 1


# 1 分钟的平均负载会慢慢增加到 1.06，其中一个 CPU 的系统 CPU 使用 率升高到了 23.87，
# 而 iowait 高达 67.53%。这说明，平均负载的升高是由于 iowait 的升 高。

# 哪个进程导致了 CPU 使用率为 100% 呢?你可以使用 pidstat 来查询
# 间隔 5 秒后输出一组数据，-u 表示 CPU 指标
pidstat -u 5 1

#11:03:12 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
#11:03:17 PM     0       318    0.00    0.20    0.00    0.20     0  kworker/0:1H
#11:03:17 PM     0      1033    0.40    0.40    0.00    0.80     1  AliYunDun
#11:03:17 PM     0      1194    0.00    0.20    0.00    0.20     0  dockerd
#11:03:17 PM   999      1695    0.00    0.40    0.00    0.40     0  mysqld
#11:03:17 PM     0     14369    0.20    0.00    0.00    0.20     0  watch
#11:03:17 PM     0     15442    0.00   98.20    0.00   98.20     0  stress
#11:03:17 PM    70     15613    0.20    0.00    0.00    0.20     1  postgres
#11:03:17 PM    70     15647    0.20    0.00    0.00    0.20     1  postgres
#11:03:17 PM     0     15675    0.00    0.20    0.00    0.20     1  pidstat
#11:03:17 PM     0     16009    0.00    0.40    0.00    0.40     0  kworker/u4:2
#11:03:17 PM     0     18094    0.40    0.00    0.00    0.40     1  frontend
#11:03:17 PM     0     18108    0.20    0.00    0.00    0.20     1  github-proxy
#11:03:17 PM     0     18133    0.20    0.00    0.00    0.20     0  repo-updater
#11:03:17 PM     0     18168    0.00    0.20    0.00    0.20     1  redis-server
#
#Average:      UID       PID    %usr %system  %guest    %CPU   CPU  Command
#Average:        0       318    0.00    0.20    0.00    0.20     -  kworker/0:1H
#Average:        0      1033    0.40    0.40    0.00    0.80     -  AliYunDun
#Average:        0      1194    0.00    0.20    0.00    0.20     -  dockerd
#Average:      999      1695    0.00    0.40    0.00    0.40     -  mysqld
#Average:        0     14369    0.20    0.00    0.00    0.20     -  watch
#Average:        0     15442    0.00   98.20    0.00   98.20     -  stress
#Average:       70     15613    0.20    0.00    0.00    0.20     -  postgres
#Average:       70     15647    0.20    0.00    0.00    0.20     -  postgres
#Average:        0     15675    0.00    0.20    0.00    0.20     -  pidstat
#Average:        0     16009    0.00    0.40    0.00    0.40     -  kworker/u4:2
#Average:        0     18094    0.40    0.00    0.00    0.40     -  frontend
#Average:        0     18108    0.20    0.00    0.00    0.20     -  github-proxy
#Average:        0     18133    0.20    0.00    0.00    0.20     -  repo-updater
#Average:        0     18168    0.00    0.20    0.00    0.20     -  redis-server