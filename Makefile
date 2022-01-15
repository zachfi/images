#

all: nvidia xmrig

nvidia:
	@docker build nvidia/ -t xaque208/miner:nvidia

xmrig:
	@docker build xmrig/ -t xaque208/miner:xmrig

.PHONY: all xmrig nvidia
