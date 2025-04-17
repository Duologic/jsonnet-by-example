// Values
// Any value that can be represented with JSON is a valid value for Jsonnet.

[
  // Strings, which can be added together with +.
  'json' + 'net',

  // Numbers, with support for arithmetics
  '1+1 = ' + (1 + 1),
  '7.0/3.0 = ' + (7.0 / 3.0),

  // Booleans, with boolean operators as you’d expect.
  true && false,
  true || false,
  !true,

  // Objects
  {},
  { key: 'value' },

  // Arrays, with mixed values
  [],
  ['item1', 42],

  // And null
  null,
]

// The default manifestation of <code>jsonnet</code> is JSON.
// This example is manifested as an array.
