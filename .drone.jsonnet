local stdImages = [
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
local localRegistry = 'reg.dist.svc.cluster.znet:5000/%s' % owner;

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
};

local dockerBuild(name, dry=false, platform='linux/amd64,linux/arm64') = {
  name: 'docker-%s/%s' % [owner, name],
  image: 'plugins/docker',
  pull_image: true,
  platform: platform,
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
};

local make(target) = step(target) {
  commands: ['make %s' % target],
};


local localPush(target, tag='latest') = step(target) {
  local image = '%(owner)s/%(target)s:%(tag)s' % { owner: owner, target: target, tag: tag },
  commands: [
    'docker tag %(image)s $(localRegistry)s:5000/%(image)s' % { image: image, localRegistry: localRegistry },
    'docker push $(localRegistry)s:5000/%(image)s' % { image: image, localRegistry: localRegistry },
  ],
};

[
  (
    pipeline('publish') {
      steps+: [
        dockerBuild(f)
        for f in stdImages
      ],
    }
  ),
  (
    pipeline('build') {
      steps+: [
        dockerBuild(f, dry=true)
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
    pipeline('localpush', depends_on=['publish']) {
      steps+: [
        dockerBuild(f, dry=true)
        for f in stdImages
      ],
      trigger: {
        branch: [
          'main',
        ],
      },
    }
  ),
]
