local generator = import './generate.libsonnet';

local examples = import './examples_list.libsonnet';

std.foldl(
  function(pages, index)
    local example = examples[index];
    pages
    + {
      [example.name + '.html']:
        generator(
          example.input,
          example.output,
          next=(
            if index + 1 < std.length(examples)
            then examples[index + 1]
            else null
          )
        ),
    },
  std.range(0, std.length(examples) - 1),
  {},
)
