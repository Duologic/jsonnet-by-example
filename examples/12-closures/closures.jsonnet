// Closures

local intSeq(start) = function(i) start + i;

local nextInt = intSeq(5);

{
  seq: std.map(
    nextInt,
    std.range(0, 5)
  ),

  direct: intSeq(4)(10),
}
