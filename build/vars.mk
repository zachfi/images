#
# build/vars.mk — Project-level variables
#
# Override on the command line or in the environment:
#   registry=your.registry.example:5000  — prefix all images with this registry
#

PROJECT_NAME ?= images

registry ?= reg.dist.svc.cluster.znet:5000
owner    ?= zachfi

# Canonical list — add/remove image dir names here only
IMAGES := chrony cron dhcp-kea dovecot nsd postfix printer restic shell syslog tools unbound
