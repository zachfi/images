#
# build/ci.mk — CI pipeline generation
#
# make ci-pipeline   Render .woodpecker/*.yml from build/woodpecker.jsonnet
#
# jsonnet and jq must be available on the host.
#

CI_JSONNET_SOURCE ?= build/woodpecker.jsonnet
CI_OUTPUT_DIR     ?= .woodpecker

.PHONY: ci-pipeline
ci-pipeline:
	@mkdir -p $(CI_OUTPUT_DIR)
	@rm -f $(CI_OUTPUT_DIR)/*.yml
	@jsonnet -S -m $(CI_OUTPUT_DIR) $(CI_JSONNET_SOURCE)
	@echo "wrote $(CI_OUTPUT_DIR)/"

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
