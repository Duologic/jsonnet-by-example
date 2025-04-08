local sum(nums) =
  // mimic variadic arguments
  local arr =
    if std.isArray(nums)
    then nums
    else [nums];
  std.foldl(
    function(a, b)
      assert std.isNumber(b) : 'Unexpected type %s, expected number' % std.type(a);
      a + b, arr, 0
  );

sum([1, 2, 3, 4])
