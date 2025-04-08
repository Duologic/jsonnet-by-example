{
  switch0:
    local i = 2;
    local s =
      std.get(
        {
          '1': 'one',
          '2': 'two',
          '3': 'three',
        },
        std.toString(i),
      );
    'Write ' + i + ' as ' + s,

  switch1:
    local day = 'Monday';
    std.get(
      {
        [d]: "It's a weekend"
        for d in ['saturday', 'sunday']
      },
      std.asciiLower(day),
      "It's a weekday"
    ),

  switch2:
    local time = { hour: 14 };
    if time.hour < 12
    then "It's before noon"
    else "It's after noon",

  switch3:
    local time = { hour: 10 };
    std.get(
      {
        [std.toString(h)]: "It's before noon"
        for h in std.range(0, 11)
      },
      std.toString(time.hour),
      "It's after noon",
    ),

  local whatAmI(fn) =
    std.get(
      {
        boolean: "I'm a bool",
        'function': "I'm a function",
      },
      std.type(fn),
      "Don't know type " + std.type(fn)
    ),

  switch4: [
    whatAmI(true),
    whatAmI(8),
    whatAmI(function(x) x),
  ],
}
