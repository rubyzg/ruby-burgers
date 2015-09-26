# several different classes acts as a `Preparer`

class Mechanic
  def prepare_trip(trip)
    trip.bicycles.each { |b| prepare_bicycle(b) }
  end
end

class TripCoordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end
end


require "minitest/autorun"

# Minitest suports sharing test via Ruby modules
module PreparerInterfaceTest
  # proves that @object responds to `prepare_trip`
  def test_implements_the_preparer_interface
    assert_respond_to(@object, :prepare_trip)
  end
end

class MechanicTest < Minitest::Test
  include PreparerInterfaceTest

  def setup
    @object = Mechanic.new
  end
end

class TripCoordinatorTest < Minitest::Test
  include PreparerInterfaceTest

  def setup
    @object = TripCoordinator.new
  end
end
