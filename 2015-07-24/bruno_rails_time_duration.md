# Magic behing rails' time intervals

- question: `3.days`, `2.years`
- also how `2.years + 3.days` works?

Rails source
------------
*files*
activesupport/lib/active_support/core_ext/numeric/time.rb
activesupport/lib/active_support/core_ext/integer/time.rb

*conclusion*
it's all about this `ActiveSupport::Duration` class

AS::Duration source
-------------------
- it's a "value object" (just like i.e. Money) that provides layer of logic
  around duration

*file*
activesupport/lib/active_support/duration.rb

look:
`new`, `+`, and `-` methods

conclusion: it just keeps the number of seconds of the duration.

question: why do we even need the "parts" state?

*example*

duration = 1.year + 3.days  # => 1 year and 3 days
duration.value              # => 31816800.0
duration.parts              # => [[:years, 1], [:days, 3]]

AS::Duration nice print
-----------------------
source for `inspect` method

`1.year + 3.years + 3.days + 1.second`
is printed `"4 years, 3 days, and 1 second"`
