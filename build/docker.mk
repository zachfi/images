#
# build/docker.mk — Parametric build/push targets
#
# Expects build/vars.mk for: registry, owner, IMAGES
#

build-%:
	docker build $* -t $(registry)/$(owner)/$*:latest

push-%: build-%
	docker push $(registry)/$(owner)/$*:latest

build-all: $(addprefix build-,$(IMAGES))
push-all:  $(addprefix push-,$(IMAGES))

.PHONY: build-all push-all
