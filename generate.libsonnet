local ml = import 'github.com/Duologic/jsonml-libsonnet/main.libsonnet';

function(input, output, next=null)
  local blocks(lines) = std.foldl(
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
          index: index - 1,
          comments+: [],
          code+: [line],
        },
        [if line != '' then 'block' + index]+: {
          index: index,
          comments+: if std.startsWith(line, '//') then [std.lstripChars(line, '/ ')] else [],
          code+: if !std.startsWith(line, '//') then [ln] else [],
        },
      },
    lines,  //[:std.length(lines) - 1],
    { index:: 0, previousLine:: '', lineCount:: 0 }
  );

  local inputLines = std.split(std.rstripChars(input, '\n\r'), '\n');
  local _inputBlocks = std.objectValues(blocks(inputLines));
  local inputBlocks = _inputBlocks[1:std.length(_inputBlocks)];

  local name = _inputBlocks[0].comments[0];
  local description = _inputBlocks[0].comments[1:];

  local outputLines = std.split(std.rstripChars(output, '\n\r'), '\n');
  local outputBlocks = std.objectValues(blocks(outputLines));
  local _outputBlocks = std.map(
    function(block)
      block + { comments: _inputBlocks[std.length(_inputBlocks) - 1].comments },
    _outputBlocks
  );

  local table =
    ml.tag.new('table')
    + ml.tag.withElements(
      [
        ml.tag.new('tr')
        + ml.tag.withAttributes(
          ml.attribute.new('class', 'description')
        )
        + ml.tag.withElements([
          ml.tag.new('td')
          + ml.tag.withElements([
            ml.tag.new('p')
            + ml.tag.withElements([
              ml.literal.new(line),
            ])
            for line in description
          ]),
          ml.tag.new('td'),
        ]),
      ]
      + [
        ml.tag.new('tr')
        + ml.tag.withAttributes(
          ml.attribute.new('class', 'input')
        )
        + ml.tag.withElements([
          ml.tag.new('td')
          + ml.tag.withElements([
            ml.tag.new('p')
            + ml.tag.withElements([
              ml.literal.new(line),
            ])
            for line in block.comments
          ]),
          ml.tag.new('td')
          + ml.tag.withAttributes([
            ml.attribute.new('class', 'code'),
          ])
          + ml.tag.withElements([
            ml.tag.new('code')
            + ml.tag.withElements([
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
              ),
            ]),
          ]),
        ])
        for block in inputBlocks
      ]
      + [
        ml.tag.new('tr')
        + ml.tag.withAttributes(
          ml.attribute.new('class', 'space')
        )
        + ml.tag.withElements([
          ml.tag.new('td'),
          ml.tag.new('td'),
        ]),
      ]
      + [
        ml.tag.new('tr')
        + ml.tag.withAttributes(
          ml.attribute.new('class', 'output')
        )
        + ml.tag.withElements([
          ml.tag.new('td')
          + ml.tag.withElements([
            ml.tag.new('p')
            + ml.tag.withElements([
              ml.literal.new(line),
            ])
            for line in block.comments
          ]),
          ml.tag.new('td')
          + (
            assert std.trace(std.manifestJson(block.code), true);
            if std.length(block.code) > 0
            then
              ml.tag.withAttributes([
                ml.attribute.new('class', 'code'),
              ])
            else {}
          )
          + ml.tag.withElements([
            ml.tag.new('code')
            + ml.tag.withElements([
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
              ),
            ]),
          ]),
        ])
        for block in outputBlocks
      ]
      + (
        if next != null
        then
          [
            ml.tag.new('tr')
            + ml.tag.withAttributes(
              ml.attribute.new('class', 'next')
            )
            + ml.tag.withElements([
              ml.tag.new('td')
              + ml.tag.withElements(
                ml.tag.new('p')
                + ml.tag.withElements([
                  ml.literal.new('Next: '),
                  ml.tag.new('a')
                  + ml.tag.withAttributes(
                    ml.attribute.new('href', next.name + '.html')
                  )
                  + ml.tag.withElements(
                    ml.literal.new(std.lstripChars(std.splitLimit(next.input, '\n', 1)[0], '/ '))
                  ),
                ])
              ),
              ml.tag.new('td'),
            ]),
          ]
        else []
      )
    );

  local head =
    ml.tag.new('head')
    + ml.tag.withElements([
      ml.tag.new('title')
      + ml.tag.withElements([
        ml.literal.new('Jsonnet by Example: ' + name),
      ]),
      ml.tag.new('style')
      + ml.tag.withElements(ml.literal.new(importstr './css/reset.css')),
      ml.tag.new('style')
      + ml.tag.withElements(ml.literal.new(importstr './css/custom.css')),
    ]);

  local body =
    ml.tag.new('body')
    + ml.tag.withElements([
      ml.tag.new('div')
      + ml.tag.withAttributes(
        ml.attribute.new('class', 'content')
      )
      + ml.tag.withElements([
        ml.tag.new('h1')
        + ml.tag.withElements(
          ml.literal.new('Jsonnet by Example: ' + name)
        ),
        table,
      ]),
    ]);

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
