#

all: shell p910nd aur unbound nsd syslog chrony dhcp-kea postfix dovecot
images	= shell p910nd aur unbound nsd syslog chrony postfix dovecot

drone:
	drone jsonnet --format

modules:
	@git submodule init
	@git submodule update

build:
	@for image in $(images); do \
    docker build $$image -t zachfi/$$image; \
	done

build-image:
	@docker build build-image/ -t zachfi/build-image:latest
	@docker push zachfi/build-image:latest

nvidia:
	@docker build nvidia/ -t zachfi/miner:nvidia
	@docker push zachfi/miner:nvidia

xmrig:
	@docker build xmrig/ -t zachfi/miner:xmrig

shell:
	@docker build shell -t zachfi/shell:archlinux
	@docker push zachfi/shell:archlinux

miner:
	@docker build cgminer-gekko -t zachfi/miner:cgminer-gekko
	@docker push zachfi/miner:cgminer-gekko

printer:
	@docker build p910nd -t zachfi/p910nd:latest
	@docker push zachfi/p910nd:latest

syslog:
	@docker build syslog -t zachfi/syslog:latest
	@docker push zachfi/syslog:latest

gomplate:
	@docker build gomplate -t zachfi/gomplate:latest
	@docker push zachfi/gomplate:latest

unbound:
	@docker build unbound -t zachfi/unbound:latest
	@docker push zachfi/unbound:latest

nsd:
	@docker build nsd -t zachfi/nsd:latest
	@docker push zachfi/nsd:latest

openldap_exporter:
	@docker build openldap_exporter -t zachfi/openldap_exporter:latest
	@docker push zachfi/openldap_exporter:latest

chrony:
	@docker build chrony -t zachfi/chrony:latest
	@docker push zachfi/chrony:latest

motion:
	@docker build motion -t zachfi/motion:latest
	@docker push zachfi/motion:latest

dhcp:
	@docker build dhcp -t zachfi/dhcp:latest
	@docker push zachfi/dhcp:latest

dhcp-kea:
	@docker build dhcp-kea -t zachfi/dhcp-kea:latest
	@docker push zachfi/dhcp-kea:latest

dovecot:
	@docker build dovecot -t zachfi/dovecot:latest
	@docker push zachfi/dovecot:latest

postfix:
	@docker build postfix -t zachfi/postfix:latest
	@docker push zachfi/postfix:latest

aur_pkgs = duo_unix gomplate-bin k3s-bin nvidia-container-runtime nvidia-container-toolkit libnvidia-container nodemanager
aur:
	@mkdir -p aur/repo
	@rm -f aur/repo/*.pkg.tar.zst
	@for image in $(aur_pkgs); do \
		pushd aur/$$image; makepkg; popd; \
	done
	@cp aur/*/*.pkg.tar.zst aur/repo
	@cp /home/zach/go/src/github.com/zachfi/nodemanager/contrib/arch/nodemanager*.pkg.tar.zst aur/repo
	@repo-add aur/repo/custom.db.tar.gz aur/repo/*pkg.tar.zst
	@docker build aur -t zachfi/aur:latest
	@docker push zachfi/aur:latest

pkgng:
	@rsync -aL --del rsync://olaf.wire.znet/freebsd-pkg/ pkgng/repo/
	@docker build pkgng -t zachfi/www:larch
	@echo docker push zachfi/www:larch

.PHONY: all modules xmrig nvidia shell printer syslog gomplate build nsd unbound chrony dhcp dhcp-kea aur pkgng openldap_exporter motion postfix dovecot build-image
