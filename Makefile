#

.PHONY: drone drone-signature
drone:
	@drone jsonnet --stream --format
	@drone lint

drone-signature:
ifndef DRONE_TOKEN
	$(error DRONE_TOKEN is not set, visit https://drone.zach.fi/account)
endif
	@DRONE_SERVER=https://drone.zach.fi drone sign --save zachfi/images .drone.yml

.PHONY: .github/dependabot.yml
.github/dependabot.yml:
	@jsonnet -S .github/dependabot.yml.jsonnet -o .github/dependabot.yml

modules:
	@git submodule init
	@git submodule update

build-image:
	@docker build build-image/ -t zachfi/build-image:latest
	@docker push zachfi/build-image:latest

shell:
	@docker pull archlinux/archlinux:base-devel
	@docker build shell/ -t zachfi/shell:latest
	@docker push reg.dist.svc.cluster.znet:5000/zachfi/shell:latest

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
	@docker build pkgng -t zachfi/www:pkg
	@docker push zachfi/www:pkg

.PHONY: all modules xmrig nvidia shell printer syslog gomplate build nsd unbound chrony dhcp dhcp-kea pkgng openldap_exporter motion postfix dovecot build-image
