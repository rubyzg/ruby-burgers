require "./config/variables"
require "./config/sequel"

require "./app/models/post"
require "./app/models/comment"

require "roda"
require "tilt/erb"
require "kramdown"

module Blog
  class App < Roda
    plugin :all_verbs
    plugin :render
    plugin :partials
    plugin :indifferent_params
    plugin :static, ["/assets"]
    plugin :not_found
    plugin :error_handler

    use Rack::MethodOverride

    route do |r|
      r.root do
        r.redirect "/posts"
      end

      r.get "posts" do
        @posts = Post.reverse(:created_at).all
        view "posts/index"
      end

      r.get "posts/new" do
        @post = Post.new
        view "posts/new"
      end

      r.post "posts" do
        @post = Post.new(params[:post])
        if @post.valid?
          @post.save
          r.redirect "/posts/#{@post.id}"
        else
          view "posts/new"
        end
      end

      r.get "posts/:id" do |id|
        @post = Post.with_pk!(id)
        @comments = @post.comments.dup
        @new_comment = Comment.new(post: @post)
        view "posts/show"
      end

      r.get "posts/:id/edit" do |id|
        @post = Post.with_pk!(id)
        view "posts/edit"
      end

      r.put "posts/:id" do |id|
        @post = Post.with_pk!(id)
        @post.set(params[:post])
        if @post.valid?
          @post.save
          r.redirect "/posts/#{@post.id}"
        else
          view "posts/edit"
        end
      end

      r.delete "posts/:id" do |id|
        @post = Post.with_pk!(id)
        @post.destroy
        r.redirect "/posts"
      end

      r.post "posts/:id/comments" do |id|
        @post = Post.with_pk!(id)
        @post.add_comment(params[:comment])
        r.redirect "/posts/#{@post.id}"
      end
    end

    def markdown(text)
      Kramdown::Document.new(text).to_html
    end

    not_found { view "404" }

    error do |error|
      if error.is_a?(Sequel::NoExistingObject)
        view "404"
      else
        raise
      end
    end
  end
end
