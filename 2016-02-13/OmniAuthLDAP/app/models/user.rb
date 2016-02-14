class User # dummy User model

  attr_accessor :id, :name, :email

  def initialize(args)
    @id    = args[:id]
    @name  = args[:name]
    @email = args[:email]
  end

  def self.find_by(id: nil, email: nil)
    User.new(id: 1, name: "Dummy User")
  end

  def to_s
    name
  end

end
