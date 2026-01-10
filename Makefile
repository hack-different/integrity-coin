-include .env

SEPOLIA_RPC_URL := https://sepolia.gateway.tenderly.co
SEPOLIA_ETHERSCAN_URL := https://sepolia.etherscan.io
LEDGER_ETH_ADDRESS := 0x17F4147ED32F8b47BBbB030b84181c09C69889e8


build:
	forge build

test:
	forge test

deploy-sepolia:
	forge create src/ApplePackageIntegrity.sol:ApplePackageIntegrity --rpc-url $(SEPOLIA_RPC_URL) \
	--ledger --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) \
	--constructor-args $(LEDGER_ETH_ADDRESS) $(LEDGER_ETH_ADDRESS)

grant-sepolia:
	cast send $(CONTRACT_ADDR) "grantHashSetter(address)" 0x63bbb5E593e3623De5acdee71C5e6A3ACF83D81f \
	--ledger --rpc-url $(SEPOLIA_RPC_URL)