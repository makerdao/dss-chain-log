#!/usr/bin/env bash
### keys2ascii -- list keys from the ChainLog in ascii
### Usage: ./keys2ascii.sh
set -e

[[ "$ETH_RPC_URL" ]] || { echo "Please set a ETH_RPC_URL"; exit 1; }

CHANGELOG=0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F

echo -e "Network: $(seth chain)"
list=$(seth call "$CHANGELOG" 'list()(bytes32[])')
IFS=","
for key in $list
do
    seth --to-ascii "$key"
done
