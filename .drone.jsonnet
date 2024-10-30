local stdImages = [
  'aur-build-image',
  'build-image',
  'chrony',
  'dhcp-kea',
  'dovecot',
  'nsd',
  'postfix',
  'printer',
  'shell',
  'syslog',
  'unbound',
];
local archs = ['amd64', 'arm64'];
local owner = 'zachfi';
local localRegistry = 'reg.dist.svc.cluster.znet:5000';

local pipeline(name, depends_on=[]) = {
  kind: 'pipeline',
  name: name,
  steps: [],
  depends_on: depends_on,
  trigger: {
    ref: [
      'refs/heads/main',
      'refs/tags/v*',
    ],
    // event: [
    //   'cron',
    // ],
    // cron: {
    //   include: ['weekly'],
    // },
  },
  volumes: [
    // { name: 'cache', temp: {} },
    { name: 'dockersock', host: { path: '/var/run/docker.sock' } },
  ],
};

local dockerBuild(name, dry=false, purge=false, platform='linux/amd64,linux/arm64') = {
  name: 'docker-%s/%s' % [owner, name],
  image: 'plugins/docker',
  pull_image: true,
  platform: platform,
  settings: {
    compress: true,
    dry_run: dry,
    purge: purge,
    dockerfile: '%s/Dockerfile' % name,
    context: name,
    username: {
      from_secret: 'DOCKER_USERNAME',
    },
    password: {
      from_secret: 'DOCKER_PASSWORD',
    },
    repo: '%s/%s' % [owner, name],
    ipv6: true,
    daemon_off: true,
  },
  volumes+: [
    { name: 'dockersock', path: '/var/run/docker.sock' },
  ],
};

local localBuild(name, dry=false, purge=false, platform='linux/amd64,linux/arm64') = {
  name: 'local-%s/%s' % [owner, name],
  image: 'plugins/docker',
  pull_image: true,
  privileged: true,
  platform: platform,
  settings: {
    dry_run: dry,
    purge: purge,
    compress: true,
    dockerfile: '%s/Dockerfile' % name,
    context: name,
    repo: '%s/%s/%s' % [localRegistry, owner, name],
    registry: localRegistry,
    insecure: true,
    ipv6: true,
    daemon_off: true,
  },
  volumes+: [
    { name: 'dockersock', path: '/var/run/docker.sock' },
  ],
};

local step(name) = {
  name: name,
  image: 'zachfi/build-image',
  pull: 'always',
  commands: [],
  volumes+: [
    { name: 'dockersock', path: '/var/run/docker.sock' },
  ],
};

local localPush(target, tag='latest') = step(target) {
  local image = '%(owner)s/%(target)s:%(tag)s' % { owner: owner, target: target, tag: tag },
  commands: [
    'docker tag %(image)s %(localRegistry)s0/%(image)s' % { image: image, localRegistry: localRegistry },
    'docker push %(localRegistry)s:5000/%(image)s' % { image: image, localRegistry: localRegistry },
  ],
};

local make(target) = step(target) {
  commands: ['make %s' % target],
};

local cleanup() = {
  name: 'cleanup',
  image: 'zachfi/build-image',
  pull: 'always',
  volumes+: [
    { name: 'dockersock', path: '/var/run/docker.sock' },
  ],
  commands: [
    '/usr/local/bin/docker system prune -f',
  ],
};
[
  (
    pipeline('build') {
      steps+: [
        dockerBuild(f)
        for f in stdImages
      ],
    }
  ),
  (
    pipeline('pr') {
      steps+: [
        dockerBuild(f, dry=true, purge=true)
        for f in stdImages
      ]
      ,
      trigger: {
        branch: {
          exclude: ['main'],
        },
        event: [
          'push',
          'pull_request',
        ],
      },
    }
  ),
  (
    pipeline('localpush', depends_on=['build']) {
      steps+: [
        localPush(f)
        for f in stdImages
      ],
      trigger: {
        branch: [
          'main',
        ],
      },
    }
  ),
  (
    pipeline('cleanup', depends_on=['build']) {
      steps+: [
        cleanup(),
      ],
      trigger: {
        branch: [
          'main',
        ],
      },
    }
  ),
]
