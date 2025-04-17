{
  local nums = [1, 2, 3],
  indices:
    std.mapWithIndex(
      function(i, num)
        num + ' has index ' + i,
      nums,
    ),

  local kvs = {
    a: 'apple',
    b: 'banana',
    c:: 'citrus',
  },

  keys: std.objectFields(kvs),
  keys_all: std.objectFieldsAll(kvs),
  kvs: std.objectKeysValues(kvs),

  str: std.stringChars('go'),
}
