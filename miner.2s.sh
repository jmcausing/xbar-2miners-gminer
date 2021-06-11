#!/bin/bash

# Setup path and JQ
export PATH="/usr/local/bin:$PATH"
JQ=$(command -v jq)

json=$(curl -s http://192.168.1.5:8887/stat) #get api url gmianer

total_gpu=$(jq -r '.devices[] | .name ' <<< $json | wc -l) #total number of GPUs

#loop/get all gpu data, speed/etc
x=0
total_kh=0

while [ $x -ne $total_gpu ]
do
  loop_mh=$($JQ -r ".devices[$x] | .speed " <<< $json)

  # Sum total mh in this loop
  total_kh=`expr $total_kh + $loop_mh`

  x=$(( $x + 1 ))

done

#convert kH to Mh
kh=1000
total_mh=`expr $total_kh / $kh`


# Display data xbar - green if more than 239999
lessthan240=239999
if [ "$total_mh" -le "$lessthan240" ]; then
  echo "Speed: $total_mh kH/s | color=red";
else
  echo "Speed: $total_mh kH/s | color=green"
fi
