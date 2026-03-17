# images

A collection of container images pushed to `reg.dist.svc.cluster.znet:5000/zachfi/`.

## Images

`aur-build-image` `chrony` `cron` `nsd` `restic` `shell` `tools` `unbound`

## Usage

```bash
make build-all         # build all images locally (no push)
make push-all          # build + push all images to the registry
make push-<name>       # build + push a single image  (e.g. make push-shell)
make ci-pipeline       # regenerate .woodpecker.yml from build/woodpecker.jsonnet
```

CI runs on push via Woodpecker. Pushes to `main` build and push all images;
PRs and non-main pushes build only.
