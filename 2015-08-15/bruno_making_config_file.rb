# Goal: we want to make a config file for a hacker's computer.
#
# Description {{{
#
# File: ~/.hackerc
# Example config options in the file ~/.hackerc:
#   editor "vim"         # or "sublime" or "textmate"
#   language "ruby"      # or "javascript"
#   environment "tmux"   # or "desktop"
#
# Work:
#
# if editor == "vim"
#   puts "hacker!"
# else
#   puts "meh"
# end
#
# }}}
# Solution 1 {{{
# - read a file
# - use regexes to parse lines
# - do something with parsed strings
# - then do the work
#
# This is quite some work. Regex can get complex and can be buggy.
# }}}
# Solution 2 {{{
#
# Use ruby's amazing built-in DSL making capabilities with instance_eval.
#
# }}}
# Code {{{

class Hacker

  DEFAULT_CONFIG_FILE="~/.hackerc"

  def self.evaluate(*args, &block)
    new(*args, &block).evaluate
  end

  def initialize(path=DEFAULT_CONFIG_FILE, &block)
    if block_given?
      instance_eval(&block)
    else
      file = File.expand_path(path)
      instance_eval(File.read(file))
    end
  end

  def evaluate
    if hacker?
      "hacker!"
    else
      "meh"
    end
  end

  private

  def hacker?
    language == "ruby"
  end

  # these are both the "setter" and "getter" methods in one
  def editor(ed=nil)
    ed ? @editor=ed : @editor.to_s
  end

  def language(lang=nil)
    lang ? @language=lang : @language.to_s
  end

  def environment(env=nil)
    env ? @environment=env : @environment.to_s
  end

end

# }}}
# Usage with block {{{

hacker = Hacker.new do
  editor "sublime"
  language "java"
end

hacker.evaluate

# }}}
# Usage with config file {{{

hacker = Hacker.new
hacker.evaluate

# }}}
# Lessons learned {{{

# 1. instance_eval
# - good for working with files
# - can take block as well
#
# 2. "double accessor" methods

# }}}
