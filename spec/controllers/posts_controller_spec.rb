require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:a_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:my_post) { a_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }

  # no longer need an index view, displayed on topic's show view
  
  describe "GET #new" do
    it "returns http success" do
      get :new, topic_id: a_topic.id
      # why no brackets on this?
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #new view" do
      get :new, topic_id: a_topic.id
      expect(response).to render_template :new
    end
    
    it "instantiates @post" do
      get :new, topic_id: a_topic.id
      expect(assigns(:post)).not_to be_nil
    end
  end
  
  describe "POST create" do
    it "increases the number of Posts by 1" do
      a_title = RandomData.random_sentence
      a_body = RandomData.random_paragraph
      # needs to be all one line, testing the event of creating it, not the created instance, uses curly braces
      expect{post :create, topic_id: a_topic.id, post: {title: a_title, body: a_body}}.to change(Post, :count).by(1)
    end
    
    it "assigns the new post to @post" do
      post :create, topic_id: a_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
      expect(assigns(:post)).to eq Post.last
    end
    
    it "redirects to the new post" do
      post :create, topic_id: a_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
      expect(response).to redirect_to [a_topic, Post.last]
      # router goes to #show of final array item, nested under previous ones
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, topic_id: a_topic.id, id: my_post.id
      # why no brackets above anymore?
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #show view" do
      get :show, topic_id: a_topic.id, id: my_post.id
      expect(response).to render_template :show
    end
    
    it "assigns my_post to @post" do
      get :show, topic_id: a_topic.id, id: my_post.id
      expect(assigns(:post)).to eq(my_post)
    end
  end

  describe "GET #edit" do
    
    it "returns http success" do
      get :edit, topic_id: a_topic.id, id: my_post.id
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #edit view" do
      get :edit, topic_id: a_topic.id, id: my_post.id
      expect(response).to render_template :edit
    end
    
    it "assigns post to be updated to @post" do
      get :edit, topic_id: a_topic.id, id: my_post.id
      post_instance = assigns(:post)
      expect(post_instance.id).to eq my_post.id
      expect(post_instance.title).to eq my_post.title
      expect(post_instance.body).to eq my_post.body
    end
  end

  describe "PUT update" do
    it "updates post with expected attributes" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      
      put :update, topic_id: a_topic.id, id: my_post.id, post: {title: new_title, body: new_body}
      
      updated_post = assigns(:post)
      expect(updated_post.id).to eq my_post.id
      expect(updated_post.title).to eq new_title
      expect(updated_post.body).to eq new_body
    end
    
    it "redirects to the updated post" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      
      put :update, topic_id: a_topic.id, id: my_post.id, post: {title: new_title, body: new_body}
      # is it always important to list topic_id first above?
      expect(response).to redirect_to [a_topic, my_post]
    end
  end
  
  describe "DELETE destroy" do
    it "deletes the post" do
      delete :destroy, topic_id: a_topic.id, id: my_post.id
      # why not use Post.find here? What is Post.where?
      count = Post.where({id: my_post.id}).size
      expect(count).to eq 0
    end
    
    it "redirects to topic show" do
      delete :destroy, topic_id: a_topic.id, id: my_post.id
      expect(response).to redirect_to a_topic
      # redirects to topic show page
    end
  end
  
end