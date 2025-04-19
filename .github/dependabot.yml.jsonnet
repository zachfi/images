std.manifestYamlDoc(
  {
    local names = [
      'aur-build-image',
      'build-image',
      'chrony',
      'dhcp',
      'dhcp-kea',
      'dovecot',
      'nsd',
      'nvidia',
      'pkgng',
      'postfix',
      'printer',
      'shell',
      'syslog',
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
