local person = {
  local validate(p) =
    assert std.isString(p.name) : 'name: Unexpected type %s, expected string.' % std.type(p.name);
    assert !std.objectHas(p, 'age') || std.isNumber(p.age) : 'age: Unexpected type %s, expected number.' % std.type(p.age);
    true,
  new(name): {
    assert validate(self),
    name: name,
  },
  withAge(age): {
    age: age,
  },
};

[
  person.new('John')
  + person.withAge(30),

  person.new('Alice'),
]
