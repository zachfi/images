// build/woodpecker.jsonnet — Woodpecker CI pipelines for the images repo
//
// Generate .woodpecker/*.yml via:  make ci-pipeline
//
// Each image gets its own workflow file with path-based triggers.
// On push to main: build + push only the changed image.
// On PR / non-main push: build only (validate Dockerfile, no push).

local registry = 'reg.dist.svc.cluster.znet:5000';
local owner = 'zachfi';

local images = [
  'chrony',
  'cron',
  'dhcp-kea',
  'dovecot',
  'nsd',
  'postfix',
  'printer',
  'restic',
  'shell',
  'syslog',
  'tools',
  'unbound',
];

// shell image has docker CLI, make, bash
local toolsImage = registry + '/' + owner + '/shell:latest';

local dockerEnv = {
  DOCKER_HOST: 'tcp://docker:2375',
  // DOCKER_TLS_VERIFY must NOT be set — Docker CLI enables TLS for any non-empty value,
  // including '0'. DinD runs without TLS (DOCKER_TLS_CERTDIR: ''), so plain TCP only.
};

local cloneStep = {
  name: 'clone',
  image: 'woodpeckerci/plugin-git',
  pull: true,
};

local workflow(name) = std.manifestYamlDoc({
  when: {
    path: '%s/**' % name,
    event: ['push', 'pull_request', 'manual'],
  },
  skip_clone: true,
  steps: [
    cloneStep,
    {
      name: 'build',
      image: toolsImage,
      pull: true,
      environment: dockerEnv,
      commands: ['make build-%s' % name],
    },
    {
      name: 'push',
      image: toolsImage,
      pull: true,
      environment: dockerEnv,
      when: { branch: 'main', event: 'push' },
      commands: ['make push-%s' % name],
    },
  ],
});

{
  ['%s.yml' % name]: workflow(name)
  for name in images
}
