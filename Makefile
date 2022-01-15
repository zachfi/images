#

all: nvidia xmrig shell

nvidia:
	@docker build nvidia/ -t xaque208/miner:nvidia

xmrig:
	@docker build xmrig/ -t xaque208/miner:xmrig

shell:
	docker build shell -t xaque208/shell:archlinux

.PHONY: all xmrig nvidia shell
