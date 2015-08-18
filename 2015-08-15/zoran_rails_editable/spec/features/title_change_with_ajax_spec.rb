require 'rails_helper'

RSpec.feature "TitleChangeWithAjax", type: :feature, js: true do

  scenario "Create Blog Post and change title on index page" do
    # visit "/blog_posts"
    # click_link 'New Blog post'
    # fill_in('Title', with: 'foo')
    # click_button('Create Blog post')

    # fetch id from URL "/blog_posts/1"
    blog_post = BlogPost.order(:id).first


    visit "/blog_posts"
    # click title, change and hit Enter
    first(:css, ".title").click
    binding.pry
    # fill_in ?, :with => 'Bob'
    # hit :enter
    expect(page).to have_text("saved")
    expect(blog_post.reload.title).to be eq('Bob')
  end
end
