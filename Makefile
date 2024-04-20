
#!/bin/bash

include .env

run-attack: 
	forge script RunLvlAttack --sig "run(uint256)" $(lvl)  --rpc-url $(CHAIN_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
test-attack: 
	forge script RunLvlAttack --sig "run(uint256)" $(lvl)  --rpc-url $(CHAIN_RPC_URL) --private-key $(PRIVATE_KEY) -vvvvv
tests:
	forge test -vvv
