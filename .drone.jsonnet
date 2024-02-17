{
  local this = self,

  dockerImage(name, dir):: {
    name: 'docker-' + name,
    image: 'plugins/docker',
    settings: {
      dockerfile: '%s/Dockerfile' % dir,
      context: dir,
      username: {
        from_secret: 'DOCKER_USERNAME',
      },
      password: {
        from_secret: 'DOCKER_PASSWORD',
      },
      repo: name,
    },
  },

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
  ],
  kind: 'pipeline',
  name: 'build',
  steps: [
    this.dockerImage('zachfi/%s' % f, f)
    for f in stdImages
  ],
}
