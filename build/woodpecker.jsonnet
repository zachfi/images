// build/woodpecker.jsonnet — Woodpecker CI pipeline for the images repo
//
// Generate .woodpecker.yml via:  make ci-pipeline
//
// On push to main: build + push all images to the internal registry.
// On PR / non-main push: build only (validate Dockerfiles, no push).

local registry = 'reg.dist.svc.cluster.znet:5000';
local owner = 'zachfi';

// shell image has docker CLI, make, bash (base-devel includes make)
local toolsImage = registry + '/' + owner + '/shell:latest';

local dockerEnv = {
  DOCKER_HOST: 'tcp://docker:2375',
  DOCKER_TLS_VERIFY: '0',
};

local mainOnly = [{ event: 'push', branch: 'main' }];
local pushOrPR = [{ event: 'push' }, { event: 'pull_request' }];

local cloneStep = {
  name: 'clone',
  image: 'woodpeckerci/plugin-git',
  pull: true,
  dns: ['8.8.8.8', '8.8.4.4'],
};

local buildAll = {
  name: 'build-all',
  image: toolsImage,
  pull: true,
  environment: dockerEnv,
  when: pushOrPR,
  commands: ['make build-all'],
};

local pushAll = {
  name: 'push-all',
  image: toolsImage,
  pull: true,
  environment: dockerEnv,
  when: mainOnly,
  commands: ['make push-all'],
};

local services = [{
  name: 'docker',
  image: 'docker:24-dind',
  privileged: true,
  environment: { DOCKER_TLS_CERTDIR: '' },
}];

std.manifestYamlDoc({
  skip_clone: true,
  services: services,
  steps: [cloneStep, buildAll, pushAll],
})
