
#!/bin/bash

include .env

run-attack: 
	forge script script/RunLvlAttack.sol --sig "run(uint256)" $(lvl)  --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) 
	#  --broadcast
test-attack: 
	forge script script/RunLvlAttack.sol --sig "run(uint256)" $(lvl)  --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY)