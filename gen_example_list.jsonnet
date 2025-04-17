function(dirs=importstr '/dev/stdin')
  '['
  + std.lines([
    std.rstripChars(|||
      {
        name: '%(dir)s',
        input: importstr 'examples/%(dir)s/%(file)s.jsonnet',
        output: importstr 'examples/%(dir)s/%(file)s.jsonnet.out',
      },
    ||| % {
      dir: dir,
      file: dir[3:],
    }, '\n')
    for dir in std.split(dirs, '\n')
    if dir != ''
  ])
  + ']'
