## Creating your Ruby gem - Basics

#### What is "RubyGems"?

In short:

* it is a Ruby package manager. Its purpose is to ease a distribution and fetching of Ruby libraries.
* the command for its usage is __gem__ and it comes installed with Ruby.

#### What is a Ruby gem?

A __gem__ is a synonym for a library written in Ruby.

#### Ruby gem structure

The following is the _standard file structure_ for a Ruby gem.

+ cool_sfuff/
  + bin/
     + cool_stuff
  + lib/
     + cool_stuff.rb
     + cool_stuff/
         + cool\_class\_1.rb
         + cool\_class\_2.rb
         + cool\_module\_1.rb
         + ...
 + test/
   + text\_cool\_stuff.rb
 + README.md
 + Rakefile
 + cool_stuff.gemspec

#### Description of the structure

* __cool\_stuff\_stuff.gemspec__: all information about a gem is provided by a developer in this file. This information is used to build gems specification. It is done so using Specification class.
See more about its usage in its [official documentation](http://ruby-doc.org/stdlib-2.2.2/libdoc/rubygems/rdoc/Gem/Specification.html).
* __bin/__: contains one or more executables.
* __bin/cool_stuff__: an executable itself.
* __lib/__: all files written by an author are placed in this folder.
* __lib/cool_stuff.rb__: main file responsible for envoking code from files placed in _lib/cool\_stuff/_.
* __lib/cool\_stuff/__: directory containing all files that create a gem itself. That means files containing classes, modules etc.
* __test/__: testing files are placed in this directory.
* __test/test\_cool\_stuff.rb__: file that contains tests for the main app file, namely "lib/cool_stuff.rb".
* __README.md__
* __Rakefile__

#### How to create an executable

Follow these steps to create an executable:

1. create a __bin__ directory
2. create an executable file using your gem name
3. change mode of a file to be an executable: _chmod a+x bin/cool\_stuff.rb_
4. write a shebang line in the executable: _#!/usr/bin/env ruby_, so that system knows which program to use. In this case we tell it to use our Ruby interpreter - _ruby_.
5. require your gems _main file from 'lib/cool\_stuff.rb'_.

#### Testing a gem

From [RubyGems guides](http://guides.rubygems.org/make-your-own-gem/):

> In short: TEST YOUR GEM! Please!

Ruby by ships with preinstalled testing utiliy TestUnit. But any _testing framework can be used_ (MiniTest, RSpec).

#### Documenting a gem

Documentation can be generated using RDoc* or Yard*. Yard is a standalone gem and it has to be installed locally __gem install yard__.

#### How to build and distribute a gem?

1. create an account on [RubyGems website](https://rubygems.org/sign_up).
2. build a gem with the command __gem build cool_stuff.gemspec__.
3. install it locally with gem install __cool\_stuff\_built\_name__.
4. Two ways:
  * if it is your first time pushing a gem, use the following command (you will have to have curl installed for this one): __curl -u YourUsername https://rubygems.org/api/v1/api_key.yaml >
~/.gem/credentials; chmod 0600 ~/.gem/credentials__
  * otherwise, you can use __gem push GemName__.

#### Distribute your gem from a source code as well

Alongside of building your gem, push your code to an online Git repo so that your gem can be fetched from a Gemfile as well.

__Resources:__

* [Official RubyGems site](https://rubygems.org/)
* [RDoc](https://rubygems.org/gems/rdoc/versions/4.2.0) and [Yard](http://yardoc.org/)
* [curl](https://en.wikipedia.org/wiki/CURL)'
