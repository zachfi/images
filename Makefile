#

all: nvidia 
images	= shell p910nd aur unbound nsd syslog chrony

modules:
	@git submodule init
	@git submodule update

build:
	@for image in $(images); do \
    docker build $$image -t xaque208/$$image; \
	done

nvidia:
	@docker build nvidia/ -t xaque208/miner:nvidia
	@docker push xaque208/miner:nvidia

xmrig:
	@docker build xmrig/ -t xaque208/miner:xmrig

shell:
	@docker build shell -t xaque208/shell:archlinux
	@docker push xaque208/shell:archlinux

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

openldap_exporter:
	@docker build openldap_exporter -t xaque208/openldap_exporter:latest
	@docker push xaque208/openldap_exporter:latest

chrony:
	@docker build chrony -t xaque208/chrony:latest
	@docker push xaque208/chrony:latest

motion:
	@docker build motion -t xaque208/motion:latest
	@docker push xaque208/motion:latest

dhcp:
	@docker build dhcp -t xaque208/dhcp:latest
	@docker push xaque208/dhcp:latest

aur_pkgs = duo_unix gomplate-bin k3s-bin
aur:
	@mkdir -p aur/repo
	@rm -f aur/repo/*.pkg.tar.zst
	@cp /home/zach/go/src/github.com/zachfi/nodemanager/contrib/arch/nodemanager*.pkg.tar.zst aur/repo
	@rm -f aur/repo/*.pkg.tar.zst
	@for image in $(aur_pkgs); do \
		pushd aur/$$image; makepkg; popd; \
	done
	@cp aur/*/*.pkg.tar.zst aur/repo
	@cp /home/zach/go/src/github.com/xaque208/nodemanager/contrib/arch/nodemanager*.pkg.tar.zst aur/repo
	@repo-add aur/repo/custom.db.tar.gz aur/repo/*pkg.tar.zst
	@docker build aur -t xaque208/aur:latest
	@docker push xaque208/aur:latest

pkgng:
	@rsync -aL --del rsync://olaf.wire.znet/freebsd-pkg/ pkgng/repo/
	@docker build pkgng -t xaque208/www:larch
	@echo docker push xaque208/www:larch

.PHONY: all modules xmrig nvidia shell printer syslog gomplate build nsd unbound chrony dhcp aur pkgng openldap_exporter motion
