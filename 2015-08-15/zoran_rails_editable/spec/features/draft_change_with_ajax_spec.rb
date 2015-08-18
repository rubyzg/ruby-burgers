require 'rails_helper'

RSpec.feature "DraftChangeWithAjax", type: :feature, js: true do

  scenario "Create Blog Post and change draft check_box on index page" do
    visit "/blog_posts"
    click_link 'New Blog post'
    fill_in('Title', with: 'foo')
    click_button('Create Blog post')

    # fetch id from URL "/blog_posts/1"
    blog_post = BlogPost.order(:id).last
    expect(blog_post.draft).to be true

    visit "/blog_posts"
    # Uncheck draft field
    page.uncheck("blog_post_draft_#{blog_post.id}")
    # find(:css, "#blog_post_draft_1[value='true']").set(false)

    expect(page).to have_text("saved")
    expect(blog_post.reload.draft).to be false
  end
end
