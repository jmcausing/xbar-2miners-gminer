#!/bin/bash

export PATH="/usr/local/bin:$PATH"

JQ=$(command -v jq)

json1=$(curl -s https://eth.2miners.com/api/accounts/EDIT___THIS__TO__YOUR__2MINERS_ETH_WALLET) # Get data from 2miners API wallet

balance_none_eth=$($JQ -r ".stats | .balance" <<< $json1) # Get current 1ETH to PHP value

convert=1000000000 # Conversion var

eth_bal=$($JQ -n $balance_none_eth/$convert) # Conversion to ETH

a_rounded=`printf "%.6f" $eth_bal` # Lessen decimal to display the same in 2miners website

# Get updated currency ETH rate to PHP (Philippine Peso)

ethphprate=$(curl -s "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=PHP")

ethphp=$($JQ -r ".PHP" <<< $ethphprate) # Get current 1ETH to PHP value

RES=$(echo "scale=2; $ethphp*$eth_bal" | bc) # Convert ETH balance to PHP value

eth_php_bal=`printf "%.0f" $RES` # Lessen decimal to display the same in 2miners website

echo ETH Bal: $a_rounded [PHP: $eth_php_bal] # Display real ETH Balance

