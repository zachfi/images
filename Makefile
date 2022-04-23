#

all: nvidia xmrig shell miner

nvidia:
	@docker build nvidia/ -t xaque208/miner:nvidia
	docker push xaque208/miner:nvidia

xmrig:
	@docker build xmrig/ -t xaque208/miner:xmrig

shell:
	docker build shell -t xaque208/shell:archlinux

miner:
	docker build cgminer-gekko -t xaque208/miner:cgminer-gekko
	docker push xaque208/miner:cgminer-gekko

printer:
	docker build p910nd -t xaque208/p910nd:latest
	# docker push xaque208/p910nd:latest

.PHONY: all xmrig nvidia shell printer
