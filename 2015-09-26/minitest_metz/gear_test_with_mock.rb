# testing outgoing messages (to observer)

# to prove that Gear sends `changed` to `observer` --> mock (test of behaviour)
# mock define an expectation that a message will get sent

class Gear
  attr_reader :chainring, :cog, :wheel, :observer

  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @wheel = args[:wheel]
    @observer = args[:observer]
  end

  def gear_inches
    ratio * wheel.diameter
  end

  def ratio
    chainring / cog.to_f
  end

  def set_cog(new_cog)
    @cog = new_cog
    changed
  end

  def set_chainring(new_chainring)
    @chainring = new_chainring
    changed
  end

  def changed
    observer.changed(chainring, cog)
    observer.foo
  end
end


require "minitest/autorun"
class GearTest < Minitest::Test

  def setup
    @observer = Minitest::Mock.new # can verify receiving `chanaged`
    @gear     = Gear.new(chainring: 52, cog: 11, observer: @observer)
  end

  def test_notifies_observers_when_cogs_change
    @observer.expect(:changed, nil, [52, 27])
    @observer.expect(:foo, nil, [])
    @gear.set_cog(27)
    @observer.verify
  end

  # def test_notifies_observers_when_chainrings_change
  #   @observer.expect(:changed, true, [42,11])
  #   @gear.set_chainring(42)
  #   @observer.verify
  # end

end
