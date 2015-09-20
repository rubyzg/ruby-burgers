# Integer factorization

# Example {{{

# 10  => 2 5
# 18  => 2 3 3
# 600 => 5 5 3 2 2 2

# }}}
# Algorithm {{{

# finding integer factorization of number 18
# 1. initialize an array with length 18 + 1
#  - nil means a prime number
#  - mark index 0 and 1 as NOT prime (write 1 to them)
#
# 2. finding primes in an array via Erastothenes sieve
#  - for each prime find it's multipliers
#  - when a number is divisible, mark by which number

# index: 0  1   2   3  4   5  6   7  8  9  10
# value: 1  1 nil nil  2 nil  3 nil  2  3   5

# }}}
# Code {{{

class IntegerFactorization

  def self.call(number)
    new(number).call
  end

  def initialize(num)
    @number = num
    @prime_array = PrimeArray.new(num)
  end

  def call
    result = []
    index = number
    while prime_array[index] != nil do
      result << prime_array[index]
      index = index / prime_array[index]
    end
    result << index
    result
  end

  private

  def number
    @number
  end

  def prime_array
    @prime_array
  end

  class PrimeArray
    def initialize(number)
      @number = number
      @array = Array.new(number + 1) { nil }
      array[0] = array[1] = 1

      max = Math.sqrt(number).to_i
      2.upto(max) do |index|
        if array[index] == nil
          process_prime(index)
        end
      end
    end

    def [](index)
      @array[index]
    end

    private

    def process_prime(prime)
      (prime * 2).step(number, prime) do |index|
        array[index] = prime
      end
    end

    def array
      @array
    end

    def number
      @number
    end
  end

end

# }}}

IntegerFactorization.call(600) # => [5, 5, 3, 2, 2, 2]

# vim: fdm=marker
