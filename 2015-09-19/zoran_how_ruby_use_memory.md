samples from http://www.sitepoint.com/ruby-uses-memory/

```ruby
def make_an_array
  array = []
  foo = "1"
  10_000_000.times do
    array << foo
  end
end

# sample 1
make_an_array
sleep 3

# sample 2
require 'memory_profiler'
report = MemoryProfiler.report do
  make_an_array
end

report.pretty_print


# sample 3
p $"
GC.start
before = GC.stat(:total_freed_objects)
total = GC.stat(:total_allocated_objects)
puts "total_allocated_objects: #{total}"

retained = []
100_000.times do
  retained << "a string"
end

retained = nil

GC.start
after = GC.stat(:total_freed_objects)
puts "Objects Freed: #{after - before}"

total = GC.stat(:total_allocated_objects)
puts "total_allocated_objects: #{total}"


# sample 4
GC.start
before = GC.stat(:total_freed_objects)

RETAINED = []
100_000.times do
  RETAINED << "a string".freeze
end

GC.start
after = GC.stat(:total_freed_objects)
puts "Objects Freed: #{after - before}"

total = GC.stat(:total_allocated_objects)
puts "total_allocated_objects: #{total}"
```

execute examples with or without gemsets:

```shell
$ ruby how_ruby_use_memory.rb
$ ruby --disable-gems how_ruby_use_memory.rb
```


Appendix: timing ruby start by @mislav

```shell
$ rbenv which ruby
/usr/local/var/rbenv/versions/2.2.3/bin/ruby

$ time /usr/local/var/rbenv/versions/2.2.3/bin/ruby -e0

real	0m0.034s
user	0m0.027s
sys	0m0.006s

$ rbenv version
2.2.3 (set by /usr/local/var/rbenv/version)

$ rbenv --version
rbenv 0.4.0

$ which -a rbenv
/usr/local/bin/rbenv

$ rbenv root
/usr/local/var/rbenv

$ time /usr/local/var/rbenv/versions/2.2.3/bin/ruby -e0

real	0m0.034s
user	0m0.027s
sys	0m0.006s

$ time /usr/local/var/rbenv/versions/2.2.3/bin/ruby --disable-gems -e0

real	0m0.011s
user	0m0.006s
sys	0m0.003s

$ time /usr/bin/ruby --disable-gems -e0

real	0m0.040s
user	0m0.005s
sys	0m0.021s

$ time /usr/bin/ruby --disable-gems -e0

real	0m0.010s
user	0m0.006s
sys	0m0.003s

$ time /usr/bin/ruby --disable-gems -e0

real	0m0.010s
user	0m0.006s
sys	0m0.004s
```
