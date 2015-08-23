# Ruby dictionary implementation

# About {{{
#
# Dictionary vs Hash vs Map
#
# Dictionary definition:
#   an abstract data type that maps (unique) keys to values
#
# Other names (from wikipedia):
#   map, associative array, symbol table
#
# HashTable:
#  - is a (one possible) dictionary implementation with good characteristics
#  - this is a data structure and an algorithm
#
# Hash:
#  - is the abbreviation of HashTable, and can mean other things,
#    e.g. hash function
#  - using "dictionary" would probably be correct
#
# Naming in languages:
# - ruby:         hash
# - python:       dictionary
# - javascript:   object
# - java:         map (?)
#
# }}}
# Interface (in ruby) {{{
#
# Create:
#
#   dict = Dictionary.new
#
# Insert:
#
#   dict["foo"] = "lorem ipsum"
#   dict["bar"] = 123
#   dict["baz"] = :book
#
# Querying:
#
#   dict["bar"]    # => 123
#   dict["baz"]    # => :book
#
# All other functions are built on top of this foundation.
#
# }}}
# Associative array implemenation {{{

# Example internal state:
# [
#   ... (10k parova)
#   ["foo", "lorem ipsum"],
#   ["bar", 123],
#   ["baz", :book],
# ]

class AssociativeArray

  def initialize
    @state = []
  end

  def []=(key, value)
    if (existing_pair = find(key))
      existing_pair[1] = value
    else
      state << [key, value]
    end
  end

  def [](key)
    find(key)[1]
  end

  private

  def state
    @state
  end

  def find(key)
    state.find { |pair| pair[0] == key }
  end

end

# Tests {{{

require "rspec"

RSpec.describe AssociativeArray do
  it "works" do
    dict = AssociativeArray.new
    dict["foo"] = "foo"
    dict["bar"] = 123
    dict["baz"] = :book
    dict["foo"] = "lorem ipsum"

    expect(dict["foo"]).to eq("lorem ipsum")
    expect(dict["bar"]).to eq(123)
    expect(dict["baz"]).to eq(:book)
  end
end

# }}}

# Problem: this is slow for many key-value pairs.

# }}}
# Hash table implementation {{{

# Example internal state:
# [
#   ...
#   [["foo", "lorem ipsum"], ["baz, :book]]  # index 1234
#   ...
#   [["bar", 123]]                           # index 6789
#   ...
# ]

class HashTable

  def initialize
    @state = []
  end

  def [](key)
    if (pair = find(key))
      pair[1]
    end
  end

  def []=(key, value)
    if (pair = find(key))
      pair[1] = value
    else
      insert(key, value)
    end
  end

  private

  def state
    @state
  end

  def find(key)
    if (bucket = state[hash(key)])
      bucket.find { |pair| pair[0] == key }
    end
  end

  def insert(key, value)
    hash = hash(key)
    state[hash] ||= []
    state[hash] << [key, value]
  end

  require 'digest/sha1'

  def hash(key)
    # converting a string to a mish-mash integer
    mishmash = key.each_byte.inject(0) do |memo, number|
      memo += number
      memo = (memo << 10)
      memo ^= (memo >> 6)
    end
    # more mish-mash-ing
    mishmash += (mishmash << 3)
    mishmash ^= (mishmash >> 11)
    mishmash += (mishmash << 15)
    # limiting first hash table array to 1k entries
    mishmash % 1000
  end

end

# Tests {{{

require "rspec"

RSpec.describe HashTable do
  it "works" do
    dict = HashTable.new
    dict["foo"] = "foo"
    dict["bar"] = 123
    dict["baz"] = :book
    dict["foo"] = "lorem ipsum"

    expect(dict["foo"]).to eq("lorem ipsum")
    expect(dict["bar"]).to eq(123)
    expect(dict["baz"]).to eq(:book)
  end
end

# }}}
# }}}
# Benchmarking 2 dictionary solutions {{{

# populating hash table and assoc array dictionary objects
require "securerandom"

number_of_pairs = 500

hash_table = HashTable.new
associative_array = AssociativeArray.new
real_hash = Hash.new

number_of_pairs.times do |key|
  value = SecureRandom.hex

  hash_table[key.to_s] = value
  associative_array[key.to_s] = value
  real_hash[key.to_s] = value
end

# check random entries
# puts hash_table["123"], associative_array["123"]

# number of buckets with more than 1 key-value pair
# hash_table.send(:state).select { |bucket| bucket && bucket.size > 1 }.count

# benchmarking
require "benchmark"

iterations = 500_000

# random keys used to query dictionaries
random_keys = Array.new(iterations) { rand(number_of_pairs).to_s }

GC.disable

Benchmark.bm(15) do |b|

  b.report("assoc array:") do
    iterations.times { |num| associative_array[random_keys[num]] }
  end

  b.report("hash table:") do
    iterations.times { |num| hash_table[random_keys[num]] }
  end

  b.report("real hash:") do
    iterations.times { |num| real_hash[random_keys[num]] }
  end

end

GC.enable

# }}}
# What we learned {{{
#
# - hash vs dictionary term disambiguation
# - hash basic implementation
# - hash benefits
#
# }}}

# vim: fdm=marker
