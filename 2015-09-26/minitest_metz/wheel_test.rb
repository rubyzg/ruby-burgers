class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end
end


require "minitest/autorun"

# class WheelTest < Minitest::Test
#
#   def test_calculates_diameter
#     wheel = Wheel.new(26, 1.5)
#     assert_in_delta(29, wheel.diameter, 0.01)
#   end
#
# end



class WheelTest < Minitest::Test

  def setup
    @wheel = Wheel.new(26, 1.5)
  end

  # prove that Wheel acts like a Diameterizable that implements `diameter`
  def test_implements_the_diameterizable_interface
    assert_respond_to(@wheel, :diameter)
  end

  def test_calculates_diameter
    assert_in_delta(29, @wheel.diameter, 0.01)
  end

end
