# Pretty XML builder

# Goals {{{
#
# 1. Learn building pretty interfaces using ruby's method_missing
# 2. Explore ruby's BasicObject (and it's issues)
#
# }}}
# What we want {{{

# Ruby interface:
#
#   user do
#     name "Foobar"
#     male
#     age 20
#     money 1000
#   end
#
#   account "active"
#
#   send do
#     tshirts 1
#     paid true
#     method "snail mail"
#     address do
#       street "Quux 123"
#       town "Springfield"
#       country "USA"
#     end
#   end


# Xml output:
#
#  <user>
#    <name>Foobar</name>
#    <male/>
#    <age>20</age>
#    <money>1000</money>
#  </user>
#  <account>active</account>
#  <send>
#    <tshirts>1</tshirts>
#    <paid>true</paid>
#    <method>snail mail</method>
#    <address>
#      <street>Quux  123</street>
#      <town>Springfield</town>
#      <country>USA</country>
#    </address>
#  </send>

# }}}
# Code {{{

# Notes:
# - It's using BasicObject inheritance. Methods like `send` or `method` are not
#   implicitly defined for this class.
#
# - BasicObject problems (and solutions):
#   - No `block_given?` method, using just `block` instead.
#   - No `puts` method, using `::Kernel.puts`.
#   - No `inspect` method 'seeing is believing' gem is using this one.
#   - Constant lookup is not that smooth, must use `::Xml` (to indicate toplevel namespace)

class Xml < BasicObject

  attr_accessor :__name__, :__value__, :__children__, :__nesting__

  def initialize(nesting = 0, &block)
    self.__nesting__ = nesting
    self.__children__ = []
    instance_eval(&block) if block
  end

  def __make__
    if __name__.nil? && __children__.any?
      __children__.each(&:__make__)
    elsif __children__.any?
      ::Kernel.print __nesting_space__
      ::Kernel.puts __open_tag__
      __children__.each(&:__make__)
      ::Kernel.print __nesting_space__
      ::Kernel.puts __close_tag__
    elsif __name__ && __value__
      ::Kernel.print __nesting_space__
      ::Kernel.puts "#{__open_tag__}#{__value__}#{__close_tag__}"
    elsif __name__
      ::Kernel.print __nesting_space__
      ::Kernel.puts "<#{__name__}/>"
    end
  end

  # handles issue from "seeing_is_believing" ruby<->vim integration
  def inspect
  end

  private

  def method_missing(name, *args, &block)
    node = ::Xml.new(__nesting__ + 2, &block)
    node.__name__ = name
    node.__value__ = args[0] if args
    self.__children__ << node
  end

  def __open_tag__
    "<#{__name__}>"
  end

  def __close_tag__
    "</#{__name__}>"
  end

  def __nesting_space__
    " " * __nesting__
  end

end

# }}}
# Usage {{{

xml = Xml.new do

  user "foo"

  user do
    name "Foobar"
    male
    age 20
    money 1000
  end

  account "active"

  send do # !!!
    tshirts 1
    paid true
    method "snail mail" # !!!
    address do
      street "Quux 123"
      town "Springfield"
      country "USA"
    end
  end

  make "foo"

end

xml.__make__

# }}}
# Clarification {{{

# Example usage:
#
# user do
#   first_name "Foo"
#   age 50
# end

# Object hierarchy for the above example:
#
# - top xml object, name: nil, value: nil, nesting: 0
#   - name: :user, value: nil, nesting: 2
#     - name: :first_name, value: "Foo", nesting: 4
#     - name: :age, value: 50, nesting: 4

# }}}
# Conclusion {{{
#
# - using BasicObject is not hard, but does have some limitations
# - building apis with method_missing is fun!
#
# }}}

# vim: fdm=marker
