#!/bin/bash
# John Mark Causing - ETH Mining hashrate checker from gminer and ETH balance checker from 2miners for xbar MacOS app (status bar display)
# v1.0
# June 14, 2021

export PATH="/usr/local/bin:$PATH"

JQ=$(command -v jq)

json1=$(curl -s https://eth.2miners.com/api/accounts/xxxxxxxxxxxxxxx) # Get data from 2miners API wallet

balance_none_eth=$($JQ -r ".stats | .balance" <<< $json1) # Get current 1ETH to PHP value

convert=1000000000 # Conversion var

eth_bal=$($JQ -n $balance_none_eth/$convert) # Conversion to ETH

a_rounded=`printf "%.6f" $eth_bal` # Lessen decimal to display the same in 2miners website

# Get updated currency ETH rate to PHP (Philippine Peso) - crypto compare API
ethphprate=$(curl -s "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=PHP")
ethphp=$($JQ -r ".PHP" <<< $ethphprate) # Get current 1ETH to PHP value
RES=$(echo "scale=2; $ethphp*$eth_bal" | bc) # Convert ETH balance to PHP value
eth_php_bal=`printf "%.0f" $RES` # Lessen decimal to display the same in 2miners website

# Get updated currency ETH rate to PHP (Philippine Peso) - Coin Gecko API
ethphp_coingeco=$(curl -s "https://api.coingecko.com/api/v3/coins/markets?vs_currency=php&ids=ethereum")
ethphp_coingeco_current=$(JQ -r ".[] | .current_price" <<< $ethphp_coingeco)
RES_cg=$(echo "scale=2; $ethphp_coingeco_current*$eth_bal" | bc) # Convert ETH balance to PHP value
eth_php_bal_cg=`printf "%.0f" $RES_cg` # Lessen decimal to display the same in 2miners website

echo "ETH Bal: $a_rounded [PHP: $eth_php_bal_cg]" # Display real ETH Balance

echo "---"

echo "ETH Bal: $a_rounded [PHP: $eth_php_bal] Crypto Compare API" # Display real ETH Balance

echo "---"

ethphp_24hrs=$($JQ -r ".PHP" <<< $ethphprate) # Get current 1ETH to PHP value

# Get last 24 hours reward
bal24hrs_orig=$($JQ -r '.["24hreward"]' <<< $json1) # Get current 1ETH to PHP value
bal24hrs=$($JQ -n $bal24hrs_orig/$convert) # Conversion to ETH
bal24hrs_a_rounded=`printf "%.6f" $bal24hrs` # Lessen decimal to display the same in 2miners website
RES_24hours=$(echo "scale=2; $ethphp_24hrs*$bal24hrs_a_rounded" | bc) # Convert ETH balance to PHP value
eth_php_bal_24hours=`printf "%.0f" $RES_24hours` # Lessen decimal to display the same in 2miners website
RES_24hours_cg=$(echo "scale=2; $ethphp_coingeco_current*$bal24hrs_a_rounded" | bc) # Convert ETH balance to PHP value
eth_php_bal_24hours_cg=`printf "%.0f" $RES_24hours_cg` # Lessen decimal to display the same in 2miners website


# Get 60 minutes balance
bal60mins_orig=$($JQ -r '.sumrewards | .[] | select(.name=="Last 60 minutes") | .reward' <<< $json1)
bal60mins=$($JQ -n $bal60mins_orig/$convert) # Conversion to ETH
bal60mins_a_rounded=`printf "%.6f" $bal60mins` # Lessen decimal to display the same in 2miners website
RES_60mins=$(echo "scale=2; $ethphp_24hrs*$bal60mins_a_rounded" | bc) # Convert ETH balance to PHP value
eth_php_bal_60mins=`printf "%.0f" $RES_60mins` # Lessen decimal to display the same in 2miners website
RES_60mins_cg=$(echo "scale=2; $ethphp_coingeco_current*$bal60mins_a_rounded" | bc) # Convert ETH balance to PHP value
eth_php_bal_60mins_cg=`printf "%.0f" $RES_60mins_cg` # Lessen decimal to display the same in 2miners website

# Get 12 hours balance
bal12hrs_orig=$($JQ -r '.sumrewards | .[] | select(.name=="Last 12 hours") | .reward' <<< $json1)
bal12hrs=$($JQ -n $bal12hrs_orig/$convert) # Conversion to ETH
bal12hrs_a_rounded=`printf "%.6f" $bal12hrs` # Lessen decimal to display the same in 2miners website
RES_12hrs=$(echo "scale=2; $ethphp_24hrs*$bal12hrs_a_rounded" | bc) # Convert ETH balance to PHP value
eth_php_bal_12hrs=`printf "%.0f" $RES_12hrs` # Lessen decimal to display the same in 2miners website
RES_12hrs_cg=$(echo "scale=2; $ethphp_coingeco_current*$bal12hrs_a_rounded" | bc) # Convert ETH balance to PHP value
eth_php_bal_12hrs_cg=`printf "%.0f" $RES_12hrs_cg` # Lessen decimal to display the same in 2miners website

echo "Current ETH PHP rate: $ethphp_24hrs (cryptocompare API)"

echo "Current ETH PHP rate: $ethphp_coingeco_current (coingecko API API)"

echo "---"

echo "Last 60 minutes: $bal60mins_a_rounded - PHP: $eth_php_bal_60mins_cg (CG Api) - PHP: $eth_php_bal_60mins (CC Api)"

echo "Last 12 hours: $bal12hrs_a_rounded - PHP: $eth_php_bal_12hrs_cg (CG Api) - PHP: $eth_php_bal_12hrs (CC Api)"

echo "Last 24 Hours Reward: $bal24hrs_a_rounded - PHP $eth_php_bal_24hours_cg (CG Api) - PHP: $eth_php_bal_24hours"
