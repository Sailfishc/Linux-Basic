# 大量进程的场景

# 模拟8个进程
stress -c 8 --timeout 600

# window two:运行 uptime 查看平均负载的变化情况
# -d 参数表示高亮显示变化的区域
watch -d uptime

#由于系统只有 2 个 CPU，明显比 8 个进程要少得多，因而系统的 CPU 处于严重过载状态


# 间隔 5 秒后输出一组数据
pidstat -u 5 1

#11:07:10 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
#11:07:15 PM     0         9    0.00    0.20    0.00    0.20     0  rcu_sched
#11:07:15 PM     0      1033    0.20    0.40    0.00    0.60     1  AliYunDun
#11:07:15 PM   999      1695    0.20    0.20    0.00    0.40     0  mysqld
#11:07:15 PM     0     14369    0.00    0.20    0.00    0.20     0  watch
#11:07:15 PM     0     15890   24.45    0.00    0.00   24.45     0  stress
#11:07:15 PM     0     15891   25.05    0.00    0.00   25.05     1  stress
#11:07:15 PM     0     15892   22.47    0.00    0.00   22.47     1  stress
#11:07:15 PM     0     15893   28.43    0.00    0.00   28.43     0  stress
#11:07:15 PM     0     15894   24.85    0.00    0.00   24.85     1  stress
#11:07:15 PM     0     15895   24.45    0.00    0.00   24.45     1  stress
#11:07:15 PM     0     15896   25.84    0.00    0.00   25.84     0  stress
#11:07:15 PM     0     15897   21.27    0.00    0.00   21.27     1  stress
#11:07:15 PM    70     15933    0.20    0.00    0.00    0.20     0  postgres
#11:07:15 PM     0     15973    0.00    0.20    0.00    0.20     1  pidstat
#11:07:15 PM     0     18094    0.20    0.00    0.00    0.20     1  frontend
#
#Average:      UID       PID    %usr %system  %guest    %CPU   CPU  Command
#Average:        0         9    0.00    0.20    0.00    0.20     -  rcu_sched
#Average:        0      1033    0.20    0.40    0.00    0.60     -  AliYunDun
#Average:      999      1695    0.20    0.20    0.00    0.40     -  mysqld
#Average:        0     14369    0.00    0.20    0.00    0.20     -  watch
#Average:        0     15890   24.45    0.00    0.00   24.45     -  stress
#Average:        0     15891   25.05    0.00    0.00   25.05     -  stress
#Average:        0     15892   22.47    0.00    0.00   22.47     -  stress
#Average:        0     15893   28.43    0.00    0.00   28.43     -  stress
#Average:        0     15894   24.85    0.00    0.00   24.85     -  stress
#Average:        0     15895   24.45    0.00    0.00   24.45     -  stress
#Average:        0     15896   25.84    0.00    0.00   25.84     -  stress
#Average:        0     15897   21.27    0.00    0.00   21.27     -  stress
#Average:       70     15933    0.20    0.00    0.00    0.20     -  postgres
#Average:        0     15973    0.00    0.20    0.00    0.20     -  pidstat
#Average:        0     18094    0.20    0.00    0.00    0.20     -  frontend
#可以看出，8 个进程在争抢 2 个 CPU，每个进程等待 CPU 的时间(也就是代码块中的 %wait 列)高达 75%。这些超出 CPU 计算能力的进程，最终导致 CPU 过载。