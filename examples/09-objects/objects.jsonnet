// Objects

local m = {
  k1: 7,
  k2: 13,
  k3:: 'hidden field',
  ['k' + 4]: 'expr key',
};

local v1 = m.k1;
local v3 = m.k2;

[
  'm: ' + m,
  'v1: ' + v1,
  'v3: ' + v3,
  //'del: '+std.objectRemoveKey(m, 'k2'), // v0.21.0
  'has: ' + std.objectHas(m, 'k2'),
  'eq: ' + (m == { k2: 13, k1: 7 }),
]
