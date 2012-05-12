#!/bin/bash

CPU=$(sensors | awk '/(CPU Temp)/ {print $3}' | cut -c 2-3)
#GPU=$(sensors | awk '/temp1/ && $0 !~ /crit/ {print $2}'| cut -c 2-3)
GPU=$(aticonfig --adapter=0 --od-gettemperature | tail -n1 | awk '{print $5}')

echo "c:<fc=#5d7caf>$CPU</fc> g:<fc=#5d7caf>$GPU</fc>"
