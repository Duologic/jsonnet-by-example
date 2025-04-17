[
  {
    local arr1 = std.makeArray(5, function(x) x),
    emp: arr1,
    get: self.set[4],
    len: std.length(self.set),
    set:
      std.mapWithIndex(
        function(i, v)
          if i == 4
          then 100
          else v,
        arr1
      ),
    setOnCreate:
      std.makeArray(
        5,
        function(x)
          if x == 4
          then 100
          else x
      ),
  },
  {
    local arr2 = [0, 1, 2, 3, 4],
    dcl: arr2,
  },
  {
    local arr3 = std.range(100, 500),
    slice: arr3[100:103],
    step: arr3[::100],
    stepandslice: arr3[90:200:50],
  },

  {
    '2d':
      [
        [
          i + j
          for j in std.range(0, 2)
        ]
        for i in std.range(0, 1)
      ],
  },
]
