# Ruby constant lookup
# A classic problem with constant lookup {{{

# lib/foo.rb
module Foo
  BAR = 5
end

# lib/foo/baz.rb, example 1
class Foo::Baz
  # BAR
end

# lib/foo/baz.rb, example 2
module Foo
  class Baz
    BAR
  end
end

# Questions: what is the difference in the above examples?
# Answer: learn Ruby constant lookup first!

# TL;DR: always, ALWAYS use nested module/class definition like in example 2

# }}}
# Why is this relevant: composition idiom {{{

class Order # < ActiveRecord::Base

  # ...

  # delegate :total, to: :payment
  def total
    payment.total
  end

  private

  def payment
    @payment ||= Payment.new(self)
  end

end

# Payment can be in global namespace:
class Payment
  def initialize(*)
  end

  def total
    "global"
  end
end

# OR nested under Order namespace:
class Order
  class Payment
    def initialize(*)
    end

    def total
      "nested"
    end
  end
end

# Q: which Payment will be used? And why?
# A: ?, because of the way how constant lookup works (smart looks: "lexical scope")
Order.new.total

# }}}
# Ruby constant lookup explained {{{

# 1. Search in scopes from `Module.nesting`.
#    This is called "lexical lookup".

# 2. Search in scopes of `self.ancestors` of the class or module that referred
#    to the constant. This is a classic inheritance hierarchy chain.

# 3. For a module OR when `Module.nesting.first` is nil (for top level namespace),
#    constant is searched in `Object.ancestors`.

# 4. `const_missing`

# }}}
# Classic problem revised {{{

module Foo
  # BAR = 5
end

# lib/foo/baz.rb, example 1
class Foo::Baz

  Module.nesting
  self.ancestors
  # module `Foo` is NOT in the constant lookup chain!

end


# lib/foo/baz.rb, example 2
module Foo
  class Baz

    Module.nesting
    self.ancestors
    # module `Foo` is in `Module.nesting` array!

    # BAR # => 5
  end
end

# Conclusion: always, ALWAYS use nested module/class definition like in
#             example 2 to get "expanded" `Module.nesting` output.

# }}}
# Quiz {{{

# Fun time!

# Question 1 {{{

class Troll
  def self.foo
    "foo"
  end
end

class Post
  Post::Troll.foo
end

# will it raise an error?

# }}}
# Explanation 1 {{{

# Rule #2, searching for `Troll` in `self.ancestors`
class Post
  self.ancestors
  # constains Object
end

Object::Troll == Post::Troll

# }}}
# Question 2 {{{

class Troll
  def self.foo
    "foo"
  end
end

module User
  # User::Troll.foo
end

# will it raise an error?

# }}}
# Explanation 2 {{{

# Rule #3 is performed (search in top-level `Object.ancestors`) but constant is
# not found:

(User::Troll rescue false) != Troll

# }}}
# Question 3 {{{

class Troll
  def self.foo
    "foo"
  end
end

module User
  Troll.foo
end

# will A raise an error?

# }}}
# Explanation 3 {{{

# Rule #3 is performed (search in top-level `Object.ancestors`) and the constant
# is found:

Troll == Troll

# }}}
# }}}
# Conclusion {{{

# Ruby constant lookup is badly documented (in books too!) and no source
# provides a thorough explanation.

# Beware: Rails has its own constant loading mechanism.
# Problems in Rails NOT mentioned! (Are there are problems)

# TL;DR

# 1. ALWAYS define modules / classes in a nested way, e.g.:
# module A
#   class B
#     class C
#       .. stuff
#     end
#   end
# end

# 2. Remember that constants are looked up via `Module.nesting`.
#    When some constant lookup breaks, then look into it.

# }}}
# Reference {{{

# - Ruby under the microscope book, chapter 6: missing rule 3
# - Ruby Tapas, ep 158: good intro missing many details
# - The Ruby Programming Language, chapter 7.9
# - stackoverflow question about edge cases:
#   http://stackoverflow.com/questions/29324535/constant-lookup

# }}}

# vim: fdm=marker
