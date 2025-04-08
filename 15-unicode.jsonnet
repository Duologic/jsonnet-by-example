local str = 'สวัสดี';

[
  str,
  std.length(str),
  std.stringChars(str),
  std.map(
    function(x) '%s has codepoint %d' % [x, std.codepoint(x)],
    std.stringChars(str)
  ),
  std.char(127866),
  std.join(
    '',
    std.map(
      std.char,
      [
        128145,
        128674,
        129398,
      ]
    ),
  ),
]
