# 节拍率 HZ 是内核的可配选项，可以设置为 100、250、1000 等。不同的系统可能设置不 同数值，你可以通过查询 /boot/config 内核选项来查看它的配置值
grep 'CONFIG_HZ=' /boot/config-$(uname -r)