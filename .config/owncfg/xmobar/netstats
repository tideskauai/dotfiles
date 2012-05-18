#!/bin/bash

received=$(cat /sys/class/net/eth0/statistics/rx_bytes)
transferred=$(cat /sys/class/net/eth0/statistics/tx_bytes)

echo -n "<fc=#5d7caf>$(( $received/1024/1024 )) </fc>MB "
echo "<fc=#FBA4A8>$(( $transferred/1024/1024 )) </fc>MB"
