class Gear
  attr_reader :chainring, :cog, :wheel

  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @wheel = args[:wheel]
  end

  def gear_inches
    ratio * wheel.diameter
  end

  def ratio
    chainring / cog.to_f
  end
end

require "minitest/autorun"

# stub (test of state)
class DiameterDouble
  def diameter
    10
  end
end

class GearTest < Minitest::Test

  def test_calculates_gear_inches
    gear = Gear.new(chainring: 52, cog: 11, wheel: DiameterDouble.new)
    assert_in_delta(47.27, gear.gear_inches, 0.01)
  end

end
