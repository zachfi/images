{
  kind: 'pipeline',
  type: 'docker',
  name: 'default',
  steps: [
    {
      name: 'make',
      image: 'alpine',
      commands: [
        'make',
      ],
    },
  ],
}
