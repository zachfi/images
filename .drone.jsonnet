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

local dockerBuild(name, dry=false, platform='linux/amd64,linux/arm64', purge=false) = {
  name: 'docker-%s/%s' % [owner, name],
  image: 'plugins/docker',
  pull_image: true,
  platform: platform,
  dry_run: dry,
  purge: purge,
  settings: {
    dockerfile: '%s/Dockerfile' % name,
    context: name,
    username: {
      from_secret: 'DOCKER_USERNAME',
    },
    password: {
      from_secret: 'DOCKER_PASSWORD',
    },
    repo: '%s/%s' % [owner, name],
  },
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

local make(target) = step(target) {
  commands: ['make %s' % target],
};


local localPush(target, tag='latest') = step(target) {
  local image = '%(owner)s/%(target)s:%(tag)s' % { owner: owner, target: target, tag: tag },
  commands: [
    'docker tag %(image)s %(localRegistry)s/%(image)s' % { image: image, localRegistry: localRegistry },
    'docker push %(localRegistry)s/%(image)s' % { image: image, localRegistry: localRegistry },
  ],
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
      ],
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
    pipeline('cleanup', depends_on=['localpush']) {
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
