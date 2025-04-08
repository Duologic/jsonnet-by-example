local fact(n) =
  if n == 0
  then 1
  else n * fact(n - 1);


{
  fact: fact(7),

  fib(n)::
    if n < 2
    then n
    else self.fib(n - 1) + self.fib(n - 2),

  fib_exec: self.fib(7),
}
