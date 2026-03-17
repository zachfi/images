include build/vars.mk

all: push-all

include build/docker.mk
include build/ci.mk

# Legacy targets kept for muscle memory
shell chrony nsd unbound restic cron aur-build-image tools: %:
	$(MAKE) push-$@

.PHONY: all shell chrony nsd unbound restic cron aur-build-image tools
