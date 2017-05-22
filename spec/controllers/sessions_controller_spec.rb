require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
    let(:user1) { User.create!(name: "Test", email: "test@t.com", password: "password") }
    
    describe "GET new" do
        it "returns http success" do
            get :new
            expect(response).to have_http_status(:success)
        end
    end
    
    describe "POST create sessions" do
        it "returns http success" do
            post :create, session: {email: user1.email}
            expect(response).to have_http_status(:success)
        end
        
        it "initializes a session" do
            post :create, session: {email: user1.email, password: user1.password}
            expect(session[:user_id]).to eq user1.id
        end
        
        it "does not add a user id to session if missing password" do
            post :create, session: {email: user1.email}
            expect(session[:user_id]).to be_nil
        end
        
        it "flashes #error with bad email address" do
            post :create, session: {email: "does not exist"}
            expect(flash.now[:alert]).to be_present
        end
        
        it "renders #new with bad email address" do
            post :create, session: {email: "does not exist"}
            expect(response).to render_template :new
        end
        
        it "redirects to the root view" do
            post :create, session: {email: user1.email, password: user1.password}
            expect(response).to redirect_to(root_path)
        end
    end
    
    describe "DELETE destroy sessions/id" do
        it "redirects to the root view" do
            delete :destroy, id: user1.id
            expect(response).to redirect_to root_path
        end
        
        it "deletes the user's session" do
            delete :destroy, id: user1.id
            expect(assigns(:session)).to be_nil
        end
        
        it "flashes #notice" do
            delete :destroy, id: user1.id
            expect(flash[:notice]).to be_present
        end
    end
    
end
