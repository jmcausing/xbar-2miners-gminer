#!/bin/bash

export PATH="/usr/local/bin:$PATH"

JQ=$(command -v jq)

json1=$(curl -s https://eth.2miners.com/api/accounts/0xad26dc72fcf82ce0c3838575624493506bf1d90d) # Get data from 2miners API wallet

echo $json1 > /tmp/2miners.json # Save and overwrite json file

balance_none_eth=$(jq  -r ".stats | .balance" /tmp/2miners.json) # Get balance from json file

convert=1000000000 # Conversion var

eth_bal=$($JQ -n $balance_none_eth/$convert) # Conversion to ETH

a_rounded=`printf "%.6f" $eth_bal` # Lessen decimal to display the same in 2miners website

echo ETH Bal: $a_rounded # Display real ETH Balance
