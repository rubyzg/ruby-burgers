# ERROR HANDLING AND EXCEPTIONS
#
# What is an exception?
# -> unacceptable behaviour in a program
#
# Exception:
#  -> is an object (a special kind)
#  -> instance of the class Exception, or a class of one of its descendants
#
# Raising (an exception):
#  -> means stopping normal execution of the program, and either dealing with an exception or exiting
#     the entire program
#  -> we deal with exceptions by providing a program with a |rescue| clause
#
# -> common exceptions:
#  * RuntimeError - default error raise using the method |raise|
#  * NoMethodError - object can't resolve a name of the message it receives to a method.
#  * NameError - interpreter comes across an identifier it can't resolve. It can be variable name,
#     method name.
#  * IOError - error caused by trying to read a closed file, write to a read-only file etc.
#  * TypeError - method receives an argument with the wrong type.
#  * ArgumentError - method receives incorrect number of arugments.
# -> they are all descendants of the class Exception
#
# Rescuing with a *rescue block*:
#  -> begin > rescue > end

# 9 - creating custom error classes
#class HeroError < Exception; end
HeroError = Class.new(Exception)

class SuperHero
  attr_accessor :special_power, :name

  def initialize(name)
    @name = name
    @special_power = true
  end

  def save_person(name)
    puts "I have saved #{name}."
  end

  # 2 - rescue in method definition
  def try_to_kill_villain(name)
    kill_villain(name)
  rescue 
    puts "I don't kill people."
  end

  # 3 - raise keyword
  def have_a_special_power?
    raise RuntimeError, "#{name} doesn't have a special power!" unless special_power
    raise HeroError, "#{name} doesn't have a special power!" unless special_power
  end
end
sh = SuperHero.new("Batman")

# 1 - usual rescuing
#begin
  #sh.save_person("John Doe")
  #sh.kill_villain("Bane")
#rescue
  #puts "True superheroes don't kill people."
#end

# 2 - rescue in method definition
#sh.try_to_kill_villain("Joker")

# 3 - explicitly raising an exception
# 4 - raising with arguments
#sh.special_power = false
#sh.have_a_special_power?

# 5 - capturing an exception in an object
#  - it can respond to messages, it is an object
#begin
  #nil + 5
#rescue NoMethodError => ex
  ## gives an array of strings representing the call stack
  #puts "Here comes backtrace:"
  #p ex.class
  #puts ex.backtrace
#end

# 6 - What gets raised, an exception or an exception class?
# 7 - reraise an exception
# 8 - ensure clause
# When writing, class names are used [raise NoMethodError], but what gets raised is an instance
# of that class [NoMethodError.new]
#begin
  #sh.some_method
  #sh.have_a_special_power?
#rescue => ex
  #p ex.class, ex
  # 7 - reraise
  #puts "do something..."
#ensure
  #puts "WILL BE RUN"
#end

# 9 - namespacing an exception class is a good idea to avoid name clashes
