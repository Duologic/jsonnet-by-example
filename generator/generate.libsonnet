local ml = import 'github.com/Duologic/jsonml-libsonnet/main.libsonnet';

function(file)
  local lines = std.split(file, '\n');

  local blocks = std.foldl(
    function(acc, ln)
      local line = std.lstripChars(ln, ' ');
      local isNewBlock =
        acc.lineCount != 0
        && line == ''
        || (
          std.startsWith(line, '//')
          && !std.startsWith(acc.previousLine, '//')
          && acc.previousLine != ''
        );

      local index =
        if isNewBlock
        then acc.index + 1
        else acc.index;

      acc + {
        lineCount+: 1,
        previousLine: line,
        index: index,
        [if line == '' then 'block' + (index - 1)]+: {
          code+: [line],
        },
        [if line != '' then 'block' + index]+: {
          comments+: if std.startsWith(line, '//') then [std.lstripChars(line, '/ ')] else [],
          code+: if !std.startsWith(line, '//') then [ln] else [],
        },
      },
    lines,
    { index:: 0, previousLine:: '', lineCount:: 0 }
  );

  local table =
    ml.tag.new('table')
    + ml.tag.withElements([
      ml.tag.new('tr')
      + ml.tag.withElements([
        ml.tag.new('td')
        + ml.tag.withElements([
          ml.tag.new('p')
          + ml.tag.withElements(
            ml.literal.new(line)
          )
          for line in block.comments
        ]),
        ml.tag.new('td')
        + ml.tag.withAttributes([
          ml.attribute.new('class', 'code'),
        ])
        + ml.tag.withElements([
          ml.tag.new('code')
          + ml.tag.withElements(
            ml.literal.new(
              std.lines(
                std.map(
                  function(line)
                    local leadingSpacesLength = std.length(line) - std.length(std.lstripChars(line, ' '));
                    std.join('', [' ' for _ in std.range(0, leadingSpacesLength)])
                    + line,
                  block.code
                )
              )
            )
          ),
        ]),
      ])
      for block in std.objectValues(blocks)
    ]);


  local head =
    ml.tag.new('head')
    + ml.tag.withElements([
      ml.literal.new('<style>%s</style>' % importstr './reset.css'),
      ml.literal.new('<style>%s</style>' % importstr './custom.css'),
    ]);

  local body =
    ml.tag.new('body')
    + ml.tag.withElements(
      table
    );

  local html =
    ml.tag.new('html')
    + ml.tag.withAttributes(
      ml.attribute.new('lang', 'en')
    )
    + ml.tag.withElements([
      head,
      body,
    ]);

  std.foldr(
    function(fn, html)
      fn(html),
    [
      function(html) std.strReplace(html, '<code>\n', '<code>'),
      function(html) std.strReplace(html, '\n\n</code>', '</code>'),
    ],
    html.manifest()
  )

