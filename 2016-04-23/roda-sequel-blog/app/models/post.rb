module Blog
  class Post < Sequel::Model
    one_to_many :comments
    add_association_dependencies :comments => :destroy

    def validate
      validates_presence [:title, :body]
    end
  end
end
