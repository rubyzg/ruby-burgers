#Ranges

Semantics:
 + **Inclusion** - you can always test Range for an inclusion?
 + **Enumeration** - you can iterate only on Ranges with definite set of values. It *includes Enumerable*!

How would you create an array:
 + of alphabetic characters?
 + numbers from N1 to N2?

## Constructor(s)
 + with #new constructor: Range.new(1, 100)             :-1:
 + with literal constructor, such as 1..100 or 1...100 :+1:

## Types of ranges
 + **inclusive** - syntax with two dots, like 1..10 (ten is included)
 + **exclusive** - with three dots, like 1...10 (ten is excluded)
  - exlusive ranges can be created with #new(1,10,true). Here, third positional arguments gives us back an exclusive Range.

 True or false?

 + (1...10).to_a == (1..9).to_a
 + (1..9) == (1...10)

Some useful instance methods:
 + **#cover**?
  - tests are perfomred using boolean tests (arg >= start_point && arg <= end_point)

 + **#include**?
  - treated as pseudo array

## Backwardness
Don't create backward ranges such as (100..1)! *Why*?

"Unexpected" beavior. What is the result of *(100..1).include? 10*? **Why**?
