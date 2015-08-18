class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title, null: false
      t.text :body
      t.boolean :draft, default: true, null: false

      t.timestamps null: false
    end
  end
end
