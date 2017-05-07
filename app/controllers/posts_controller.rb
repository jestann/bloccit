class PostsController < ApplicationController
  def index
    @posts = Post.all
    
    # censor every fifth post
    count = 1
    @posts.each do |post|
      if count % 5 == 0
        post.title = "SPAM"
      end
      count += 1
    end
    
  end

  def show
  end

  def new
  end

  def edit
  end
end
