# using Role tests to validate double (stub)

class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @wheel = args[:wheel]
  end

  def gear_inches
    ratio * wheel.width
  end

  def ratio
    chainring / cog.to_f
  end
end

### prod ###
class Wheel
  def width
    123
  end
end


def produkcija
  Gear.new(chainring: 52, cog: 11, wheel: Wheel.new)
end

############



require "minitest/autorun"

class DiameterDouble
  def width
    10
  end
end

# test the stub (double)
module DiameterizableInterfaceTest
  # proves that @object responds to `diameter`
  def test_implements_the_diameterizable_interface
    assert_respond_to(@object, :diameter)
  end
end


class WheelTest < Minitest::Test
  include DiameterizableInterfaceTest

  def setup
    @object = Wheel.new
  end
end


class DiameterDoubleTest < Minitest::Test
  include DiameterizableInterfaceTest

  def setup
    @object = DiameterDouble.new
  end
end

class GearTest < Minitest::Test
  def test_calculates_gear_inches
    gear = Gear.new(chainring: 52, cog: 11, wheel: DiameterDouble.new)
    assert_in_delta(47.27, gear.gear_inches, 0.01)
  end
end
