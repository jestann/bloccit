require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:q) { Question.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: false ) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    
    it "assigns [q] to @questions" do
      get :index
      expect(assigns(:questions)).to eq([q])
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #new view" do
      get :new
      expect(response).to render_template :new
    end
    
    it "instantiates @question" do
      get :new
      expect(assigns(:question)).not_to be_nil
    end
  end
  
  describe "POST create" do
    it "increases the number of questions by 1" do
      a_title = RandomData.random_sentence
      a_body = RandomData.random_paragraph
      # needs to be all one line, testing the event of creating it, not the created instance, uses curly braces
      expect{post :create, question: {title: a_title, body: a_body, resolved: false}}.to change(Question, :count).by(1)
    end
    
    it "assigns the new question to @question" do
      post :create, question: {title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: false}
      expect(assigns(:question)).to eq Question.last
    end
    
    it "redirects to the new question" do
      post :create, question: {title: RandomData.random_sentence, body: RandomData.random_paragraph, resolved: false}
      expect(response).to redirect_to Question.last
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, {id: q.id}
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #show view" do
      get :show, {id: q.id}
      expect(response).to render_template :show
    end
    
    it "assigns q to @question" do
      get :show, {id: q.id}
      expect(assigns(:question)).to eq(q)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, {id: q.id}
      expect(response).to have_http_status(:success)
    end
    
    it "renders the #edit view" do
      get :edit, {id: q.id}
      expect(response).to render_template :edit
    end
    
    it "assigns question to be updated to @question" do
      get :edit, {id: q.id}
      q_instance = assigns(:question)
      expect(q_instance.id).to eq q.id
      expect(q_instance.title).to eq q.title
      expect(q_instance.body).to eq q.body
      expect(q_instance.resolved).to eq q.resolved
    end
  end

  describe "PUT update" do
    it "updates question with expected attributes" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, id: q.id, question: {title: new_title, body: new_body, resolved: true}
      
      updated_q = assigns(:question)
      expect(updated_q.id).to eq q.id
      expect(updated_q.title).to eq new_title
      expect(updated_q.body).to eq new_body
      expect(updated_q.resolved).to eq true
    end
    
    it "redirects to the updated post" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      
      put :update, id: q.id, question: {title: new_title, body: new_body, resolved: true}
      expect(response).to redirect_to q
    end
  end
  
  describe "DELETE destroy" do
    it "deletes the question" do
      delete :destroy, {id: q.id}
      count = Question.where({id: q.id}).size
      expect(count).to eq 0
    end
    
    it "redirects to question index" do
      delete :destroy, {id: q.id}
      expect(response).to redirect_to questions_path
    end
  end
  
end
