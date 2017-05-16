class PostsController < ApplicationController
  
  def show
    @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]
    # added below, topic_id is the params name, not id
    @topic = Topic.find(params[:topic_id])
    @post.topic = @topic
    # curious about the above syntax?
    # why not @post.topic_id = @topic.id?
    
    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to [@topic, @post]
      # this goes to @post, nested under @topic
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @topic = @post.topic
    # now edit has a @topic
  end
  
  def update
    @post = Post.find(params[:id])
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]
    # does @post.topic or @topic need defined here? Yes. Missing in curriculum.
    @topic = Topic.find(params[:topic_id])
    @post.topic = @topic
    
    if @post.save
      flash[:notice] = "Post was updated."
      redirect_to [@topic, @post]
      # @topic wasn't defined in this method yet in curriculum
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :edit
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    
    if @post.destroy
      flash[:notice] = "\"#{@post.title}\" was deleted successfully."
      redirect_to @post.topic
      # this is set in a diff method, and that's okay?
      # or maybe this was set above just to be used here?
      # because could just say @topic right? also set above?
    else
      flash.now[:alert] = "There was an error deleting the post."
      render :show
    end
  end
  
end
