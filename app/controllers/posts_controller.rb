class PostsController < ApplicationController
  
  before_action :require_sign_in, except: :show
  # requires sign in for all actions but show
  
  def show
    @post = Post.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end

  def create
    # mass assignment and strong parameters
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.user = current_user
    
    # OLD WAY
    # @post = Post.new
    # @post.title = params[:post][:title]
    # @post.body = params[:post][:body]
    # added below, topic_id is the params name, not id
    # @topic = Topic.find(params[:topic_id])
    # @post.topic = @topic
    # curious about the above syntax: why not @post.topic_id = @topic.id?
    # @post.user = current_user
    # doesn't fail with this commented out... why?
    
    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to [@post.topic, @post]
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
    @post.assign_attributes(post_params)
    
    # OLD WAY
    # @post.title = params[:post][:title]
    # @post.body = params[:post][:body]
    # does @post.topic or @topic need defined here? Yes. Missing in curriculum.
    # @topic = Topic.find(params[:topic_id])
    # @post.topic = @topic
    
    if @post.save
      flash[:notice] = "Post was updated."
      redirect_to [@post.topic, @post]
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
  
  private
  # anything below is private, so add at bottom of file
  def post_params
    params.require(:post).permit(:title, :body)
  end
  
end
