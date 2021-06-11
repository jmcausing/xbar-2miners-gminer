#!/bin/bash

export PATH="/usr/local/bin:$PATH"

JQ=$(command -v jq)

json=$(curl -s http://192.168.1.5:8887/stat)
echo $json > /tmp/miner1.json
miner_file=/tmp/miner1.json

#gpu name example
# jq -r '.devices[0] | .name ' $miner_file 

total_gpu=$(jq -r '.devices[] | .name ' $miner_file | wc -l)

#loop/get all gpu data, speed/etc
x=0
total_kh=0

while [ $x -ne $total_gpu ]
do
  loop_mh=$($JQ -r ".devices[$x] | .speed " /tmp/miner1.json)

  # Sum total mh in this loop
  total_kh=`expr $total_kh + $loop_mh`

  x=$(( $x + 1 ))

done

#convert kH to Mh
kh=1000
total_mh=`expr $total_kh / $kh`


echo Total GPU speed: $total_mh kH/s
