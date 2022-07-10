#

all: nvidia xmrig shell miner
images	= shell p910nd

build:
	@for image in $(images); do \
    docker build $$image; \
	done

nvidia:
	@docker build nvidia/ -t xaque208/miner:nvidia
	@docker push xaque208/miner:nvidia

xmrig:
	@docker build xmrig/ -t xaque208/miner:xmrig

shell:
	@docker build shell -t xaque208/shell:latest
	@docker push xaque208/shell:latest

miner:
	@docker build cgminer-gekko -t xaque208/miner:cgminer-gekko
	@docker push xaque208/miner:cgminer-gekko

printer:
	@docker build p910nd -t xaque208/p910nd:latest
	@docker push xaque208/p910nd:latest

syslog:
	@docker build syslog -t xaque208/syslog:latest
	@docker push xaque208/syslog:latest

gomplate:
	@docker build gomplate -t xaque208/gomplate:latest
	@docker push xaque208/gomplate:latest

unbound:
	@docker build unbound -t xaque208/unbound:latest
	@docker push xaque208/unbound:latest

nsd:
	@docker build nsd -t xaque208/nsd:latest
	@docker push xaque208/nsd:latest

chrony:
	@docker build chrony -t xaque208/chrony:latest
	@docker push xaque208/chrony:latest

dhcp:
	@docker build dhcp -t xaque208/dhcp:latest
	@docker push xaque208/dhcp:latest

.PHONY: all xmrig nvidia shell printer syslog gomplate build nsd unbound chrony dhcp
