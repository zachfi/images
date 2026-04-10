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
local owner = 'zachfi';
local localRegistry = 'reg.dist.svc.cluster.znet:5000';

local volumes = [
  { name: 'dockersock', host: { path: '/var/run/docker.sock' } },
];

local volumeMount = { name: 'dockersock', path: '/var/run/docker.sock' };

local dockerBuild(name, dry=true, purge=false) = {
  name: 'build',
  image: 'plugins/docker',
  pull_image: true,
  settings: {
    compress: true,
    dry_run: dry,
    purge: purge,
    dockerfile: '%s/Dockerfile' % name,
    context: name,
    username: { from_secret: 'DOCKER_USERNAME' },
    password: { from_secret: 'DOCKER_PASSWORD' },
    repo: '%s/%s' % [owner, name],
    ipv6: true,
    daemon_off: true,
  },
  volumes: [volumeMount],
};

local localPush(name) = {
  local image = '%s/%s:latest' % [owner, name],
  name: 'push-local',
  image: '%s/zachfi/tools' % localRegistry,
  pull: 'always',
  commands: [
    'docker tag %s %s/%s' % [image, localRegistry, image],
    'docker push %s/%s' % [localRegistry, image],
  ],
  volumes: [volumeMount],
};

local cleanup() = {
  name: 'cleanup',
  image: '%s/zachfi/tools' % localRegistry,
  pull: 'always',
  commands: ['docker system prune -f'],
  volumes: [volumeMount],
};

// Per-image PR pipeline: dry-run build only, triggered by changes to the image dir
local prPipeline(name) = {
  kind: 'pipeline',
  name: '%s-pr' % name,
  trigger: {
    event: ['push', 'pull_request'],
    branch: { exclude: ['main'] },
    paths: { include: ['%s/**' % name] },
  },
  volumes: volumes,
  steps: [dockerBuild(name, dry=true, purge=true)],
};

// Per-image main pipeline: build, push to dockerhub, push to local registry
local mainPipeline(name) = {
  kind: 'pipeline',
  name: '%s-main' % name,
  trigger: {
    event: ['push'],
    branch: ['main'],
    ref: ['refs/heads/main', 'refs/tags/v*'],
    paths: { include: ['%s/**' % name] },
  },
  volumes: volumes,
  steps: [
    dockerBuild(name, dry=false),
    localPush(name),
    cleanup(),
  ],
};

// Generate a PR and main pipeline for each image
std.flattenArrays([
  [prPipeline(img), mainPipeline(img)]
  for img in images
])
