std.manifestYamlDoc(
  {
    local names = [
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
    ],

    version: 2,

    updates: [
      {
        'package-ecosystem': 'docker',
        directory: '/%s' % name,
        schedule: {
          interval: 'daily',
        },
      }
      for name in names
    ],

  },
  indent_array_in_object=true,
  quote_keys=false,
)
