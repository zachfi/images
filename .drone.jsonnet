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

local pipeline(name, arch='amd64') = {
  kind: 'pipeline',
  name: name,
  platform: {
    os: 'linux',
    arch: arch,
  },
  steps: [],
  depends_on: [],
  trigger: {
    ref: [
      'refs/heads/main',
      'refs/tags/v*',
    ],
  },
};

local dockerImage(arch, name, dry=false) = {
  name: 'docker-%s/%s' % [owner, name],
  image: 'plugins/docker',
  pull_image: true,
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
  (
    pipeline('docker-' + arch, arch) {
      steps+: [
        dockerImage(arch, f)
        for f in stdImages
      ],
    }
  )
  for arch in archs
]
+ [
  (
    pipeline('docker-' + arch, arch) {
      steps+: [
        dockerImage(arch, f, dry=true)
        for f in stdImages
      ],
      trigger: {
        ref: [
          'refs/heads/**',
        ],
      },
    }
  )
  for arch in archs
]
