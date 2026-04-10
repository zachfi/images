#
# build/ci.mk — CI pipeline generation
#
# make ci-pipeline   Render .woodpecker.yml from build/woodpecker.jsonnet
#
# jsonnet and jq must be available on the host.
#

CI_CONFIG         ?= .woodpecker.yml
CI_JSONNET_SOURCE ?= build/woodpecker.jsonnet

.PHONY: ci-pipeline
ci-pipeline:
	jsonnet $(CI_JSONNET_SOURCE) | jq -r . > $(CI_CONFIG)
	@echo "wrote $(CI_CONFIG)"

#
# Drone CI helpers
#
# make drone                              Lint the Drone pipeline
# make drone-signature DRONE_REPO=owner/repo  Sign the pipeline config
#

DRONE_REPO ?= zachfi/images

.PHONY: drone drone-signature
drone:
	@drone jsonnet --stream --format
	@drone lint --trusted

drone-signature:
ifndef DRONE_TOKEN
	$(error DRONE_TOKEN is not set, visit https://drone.zach.fi/account)
endif
	@DRONE_SERVER=https://drone.zach.fi drone sign --save $(DRONE_REPO) .drone.yml
