local stdImages = [
  'printer',
  'unbound',
  'nsd',
  'syslog',
  'chrony',
  'dhcp-kea',
  'postfix',
  'dovecot',
  'shell',
];
local archs = ['amd64', 'arm64'];
local owner = 'zachfi';

local pipeline(name) = {
  kind: 'pipeline',
  name: name,
  steps: [],
  depends_on: [],
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

[
  pipeline('publish') {
    steps+: [
      dockerBuild(f)
      for f in stdImages
    ],
  },
]
+ [
  pipeline('build') {
    steps+: [
      dockerBuild(f, dry=true)
      for f in stdImages
    ],
    trigger: {
      event: [
        'push',
        'pull_request',
      ],
    },
  },
]
