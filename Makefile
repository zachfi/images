#

drone:
	@drone jsonnet --format
	@drone lint

modules:
	@git submodule init
	@git submodule update

build-image:
	@docker build build-image/ -t zachfi/build-image:latest
	@docker push zachfi/build-image:latest

shell:
	@docker pull archlinux/archlinux:base-devel
	@docker build shell/ -t zachfi/shell:archlinux
	@docker push zachfi/shell:archlinux

nvidia:
	@docker build nvidia/ -t zachfi/miner:nvidia
	@docker push zachfi/miner:nvidia

xmrig:
	@docker build xmrig/ -t zachfi/miner:xmrig


miner:
	@docker build cgminer-gekko -t zachfi/miner:cgminer-gekko
	@docker push zachfi/miner:cgminer-gekko

gomplate:
	@docker build gomplate -t zachfi/gomplate:latest
	@docker push zachfi/gomplate:latest

openldap_exporter:
	@docker build openldap_exporter -t zachfi/openldap_exporter:latest
	@docker push zachfi/openldap_exporter:latest

motion:
	@docker build motion -t zachfi/motion:latest
	@docker push zachfi/motion:latest

dhcp:
	@docker build dhcp -t zachfi/dhcp:latest
	@docker push zachfi/dhcp:latest

dhcp-kea:
	@docker build dhcp-kea -t zachfi/dhcp-kea:latest
	@docker push zachfi/dhcp-kea:latest

pkgng:
	@rsync -aL --del rsync://olaf.wire.znet/freebsd-pkg/ pkgng/repo/
	@docker build pkgng -t zachfi/www:larch
	@echo docker push zachfi/www:larch

.PHONY: all modules xmrig nvidia shell printer syslog gomplate build nsd unbound chrony dhcp dhcp-kea aur pkgng openldap_exporter motion postfix dovecot build-image
