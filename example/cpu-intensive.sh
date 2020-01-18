# CPU密集型进程

# window one: 模拟一个 CPU 使用率 100% 的场景
stress --cpu 1 --timeout 600

# window two:运行 uptime 查看平均负载的变化情况
# -d 参数表示高亮显示变化的区域
watch -d uptime

# window three: 查看 CPU 使用率的变化情况
# -P ALL 表示监控所有 CPU，后面数字 5 表示间隔 5 秒后输出一组数据
mpstat -P ALL 5


# 终端二中可以看到，1 分钟的平均负载会慢慢增加到 1.00，而从终端三中还可以看到，
# 正好有一个 CPU 的使用率为 100%，但它的 iowait 只有 0。这说明，平均负载的升高正是 由于 CPU 使用率为 100% 。

# 哪个进程导致了 CPU 使用率为 100% 呢?你可以使用 pidstat 来查询
pidstat -u 5 1

#10:57:31 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
#10:57:36 PM     0      1033    0.80    0.00    0.00    0.80     0  AliYunDun
#10:57:36 PM   999      1695    0.20    0.20    0.00    0.40     0  mysqld
#10:57:36 PM     0     14369    0.20    0.20    0.00    0.40     0  watch
#10:57:36 PM     0     15006  100.00    0.00    0.00  100.00     1  stress
#10:57:36 PM    70     15186    0.20    0.00    0.00    0.20     0  postgres
#10:57:36 PM    70     15232    0.20    0.00    0.00    0.20     0  postgres
#10:57:36 PM     0     15239    0.00    0.20    0.00    0.20     0  pidstat
#10:57:36 PM     0     18094    0.00    0.40    0.00    0.40     1  frontend
#
#Average:      UID       PID    %usr %system  %guest    %CPU   CPU  Command
#Average:        0      1033    0.80    0.00    0.00    0.80     -  AliYunDun
#Average:      999      1695    0.20    0.20    0.00    0.40     -  mysqld
#Average:        0     14369    0.20    0.20    0.00    0.40     -  watch
#Average:        0     15006  100.00    0.00    0.00  100.00     -  stress
#Average:       70     15186    0.20    0.00    0.00    0.20     -  postgres
#Average:       70     15232    0.20    0.00    0.00    0.20     -  postgres
#Average:        0     15239    0.00    0.20    0.00    0.20     -  pidstat
#Average:        0     18094    0.00    0.40    0.00    0.40     -  frontend