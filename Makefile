
#!/bin/bash

include .env

run-attack: 
	forge script script/RunLvlAttack.sol --sig "run(uint256, uint256)" 0 $(lvl)  --rpc-url $(CHAIN_RPC_URL) --private-key $(PRIVATE_KEY2) --broadcast
test-attack: 
	forge script script/RunLvlAttack.sol --sig "run(uint256, uint256)" 0 $(lvl)  --rpc-url $(CHAIN_RPC_URL) --private-key $(PRIVATE_KEY2) -vvvvv
tests:
	forge test -vvv
