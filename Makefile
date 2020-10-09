all    :; SOLC_FLAGS="--optimize --optimize-runs=1000" dapp --use solc:0.6.7 build
clean  :; dapp clean
test   :; SOLC_FLAGS="--optimize --optimize-runs=1000" dapp --use solc:0.6.7 test -v
deploy :; SOLC_FLAGS="--optimize --optimize-runs=1000" dapp --use solc:0.6.7 build && dapp create ChainLog
