### README

```ruby
rails new blog_ajax --skip-turbolinks

rails g scaffold blog_post title body:text draft:boolean

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
```

Edit `views/blog_posts/index.html.erb`

1. `<tr data-id="<%= blog_post.id %>">`
2. `<%= check_box_tag "blog_post_draft_#{blog_post.id}", true, blog_post.draft, class: "js-draft" %>`


### In place editing of Title with Jeditable jQuery plugin
http://www.appelsiini.net/projects/jeditable

1. download http://www.appelsiini.net/download/jquery.jeditable.js to `vendors/javascripts/`
2. add `//= require jquery.jeditable` in `application.js`
3. add `js-title` css class in view: `<%= content_tag :span, blog_post.title, class: "js-title" %>`
4. add some more javascript see: `app/assets/javascripts/blog_posts.js`
https://github.com/zmajstor/blog_ajax/blob/master/app/assets/javascripts/blog_posts.js
