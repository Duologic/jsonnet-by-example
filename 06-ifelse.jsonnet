[
  (if 7 % 2 == 0
   then '7 is even'
   else '7 is odd'),

  (if 8 % 4 == 0
   then '8 is divisable by 4'),

  (if 9 % 4 == 0
   then '9 is divisable by 4'),

  (
    local num = 9;
    if num < 0
    then num + ' is negative'
    else if num < 10
    then num + ' has 1 digit'
    else num + ' has multiple digits'
  ),
]
