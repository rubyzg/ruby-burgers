# How to `tail` in ruby?
(calling `tail` shell command is out of scope :)

## Using gem
https://github.com/flori/file-tail  
or: https://github.com/jordansissel/ruby-filewatch

## Exploring stackoverflow.com
http://stackoverflow.com/questions/3024372/how-to-read-a-file-from-bottom-to-top-in-ruby?lq=1
http://stackoverflow.com/questions/754494/reading-the-last-n-lines-of-a-file-in-ruby

## Found samples

use a log file to tail:
`FILE = "production.log".freeze`

### The simplest possible solution
`puts File.readlines(FILE)[-25..-1]`

### A sample from stackoverflow
```ruby
class IO
  TAIL_BUF_LENGTH = 1 << 16
  def tail(n)
    return [] if n < 1

    seek -TAIL_BUF_LENGTH, SEEK_END

    buf = ""
    while buf.count("\n") <= n
      buf = read(TAIL_BUF_LENGTH) + buf
      seek 2 * -TAIL_BUF_LENGTH, SEEK_CUR
    end

    buf.split("\n")[-n..-1]
  end
end
```

`puts File.new(FILE).tail(25)`

### Extraction from gem 'file-tail'
```ruby
class IO
  def backward(n = 0, bufsize = nil)
    if n <= 0
      seek(0, File::SEEK_END)
      return self
    end
    bufsize ||= stat.blksize || 8192
    size = stat.size
    begin
      if bufsize < size
        seek(0, File::SEEK_END)
        while n > 0 and tell > 0 do
          start = tell
          seek(-bufsize, File::SEEK_CUR)
          buffer = read(bufsize)
          n -= buffer.count("\n")
          seek(-bufsize, File::SEEK_CUR)
        end
      else
        rewind
        buffer = read(size)
        n -= buffer.count("\n")
        rewind
      end
    rescue Errno::EINVAL
      size = tell
      retry
    end
    pos = -1
    while n < 0  # forward if we are too far back
      pos = buffer.index("\n", pos + 1)
      n += 1
    end
    seek(pos + 1, File::SEEK_CUR)
    self
  end
end
```

`puts File.new(FILE).backward(25).read`

## Comparison
```ruby
require 'benchmark/ips'
Benchmark.ips do |x|
  # Configure the number of seconds used during
  # the warmup phase (default 2) and calculation phase (default 5)
  x.config(:time => 5, :warmup => 2)

  x.report("#readlines") { File.readlines(FILE)[-25..-1] }
  x.report("#tail") { File.new(FILE).tail(25) }
  x.report("#backward") { File.new(FILE).backward(25).read }

  x.compare!
end


Calculating -------------------------------------
          #readlines    33.000  i/100ms
               #tail   641.000  i/100ms
           #backward     3.726k i/100ms
-------------------------------------------------
          #readlines    368.293  (± 3.0%) i/s -      1.848k
               #tail      6.546k (± 3.2%) i/s -     33.332k
           #backward     38.801k (± 2.0%) i/s -    197.478k

Comparison:
           #backward:    38800.9 i/s
               #tail:     6545.8 i/s - 5.93x slower
          #readlines:      368.3 i/s - 105.35x slower

```
