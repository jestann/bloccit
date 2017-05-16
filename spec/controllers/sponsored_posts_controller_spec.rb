require 'rails_helper'

RSpec.describe SponsoredPostsController, type: :controller do

  let(:a_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:a_spost) { a_topic.sponsored_posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, price: rand(50..1000)) }

  describe "GET #new" do
    it "returns http success" do
      get :new, topic_id: a_topic.id
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #new view" do
      get :new, topic_id: a_topic.id
      expect(response).to render_template :new
    end
    
    it "instantiates @sponsored_post" do
      get :new, topic_id: a_topic.id
      expect(assigns(:sponsored_post)).not_to be_nil
    end
  end

  describe "POST create" do
    it "increases the number of SponsoredPosts by 1" do
      a_title = RandomData.random_sentence
      a_body = RandomData.random_paragraph
      a_price = rand(50..1000)
      expect{post :create, topic_id: a_topic.id, sponsored_post: {title: a_title, body: a_body, price: a_price}}.to change(SponsoredPost, :count).by(1)
    end
    
    it "assigns the new sponsored post to @sponsored_post" do
      post :create, topic_id: a_topic.id, sponsored_post: {title: RandomData.random_sentence, body: RandomData.random_paragraph, price: rand(50..1000)}
      expect(assigns(:sponsored_post)).to eq SponsoredPost.last
    end
    
    it "redirects to the new sponsored post" do
      post :create, topic_id: a_topic.id, sponsored_post: {title: RandomData.random_sentence, body: RandomData.random_paragraph, price: rand(50..1000)}
      expect(response).to redirect_to [a_topic, SponsoredPost.last]
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, topic_id: a_topic.id, id: a_spost.id
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #show view" do
      get :show, topic_id: a_topic.id, id: a_spost.id
      expect(response).to render_template :show
    end
    
    it "assigns a_spost to @sponsored_post" do
      get :show, topic_id: a_topic.id, id: a_spost.id
      expect(assigns(:sponsored_post)).to eq(a_spost)
    end
  end

  describe "GET #edit" do
    
    it "returns http success" do
      get :edit, topic_id: a_topic.id, id: a_spost.id
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #edit view" do
      get :edit, topic_id: a_topic.id, id: a_spost.id
      expect(response).to render_template :edit
    end
    
    it "assigns sponsored post to be updated to @sponsored_post" do
      get :edit, topic_id: a_topic.id, id: a_spost.id
      spost_instance = assigns(:sponsored_post)
      expect(spost_instance.id).to eq a_spost.id
      expect(spost_instance.title).to eq a_spost.title
      expect(spost_instance.body).to eq a_spost.body
      expect(spost_instance.price).to eq a_spost.price
    end
  end

  describe "PUT update" do
    it "updates sponsored post with expected attributes" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      new_price = rand(50..1000)
      
      put :update, topic_id: a_topic.id, id: a_spost.id, sponsored_post: {title: new_title, body: new_body, price: new_price}
      
      updated_spost = assigns(:sponsored_post)
      expect(updated_spost.id).to eq a_spost.id
      expect(updated_spost.title).to eq new_title
      expect(updated_spost.body).to eq new_body
      expect(updated_spost.price).to eq new_price
    end

    it "redirects to the updated sponsored post" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      new_price = rand(50..100)
      
      put :update, topic_id: a_topic.id, id: a_spost.id, sponsored_post: {title: new_title, body: new_body, price: new_price}
      expect(response).to redirect_to [a_topic, a_spost]
    end
  end

  describe "DELETE destroy" do
    it "deletes the sponsored post" do
      delete :destroy, topic_id: a_topic.id, id: a_spost.id
      count = SponsoredPost.where({id: a_spost.id}).size
      expect(count).to eq 0
    end
    
    it "redirects to topic show" do
      delete :destroy, topic_id: a_topic.id, id: a_spost.id
      expect(response).to redirect_to a_topic
    end
  end

end
