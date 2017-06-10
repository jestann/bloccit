require 'rails_helper'

RSpec.describe UsersController, type: :controller do

    let(:new_user) do
        {
            name: "Bloc",
            email: "bloc@bloc.io",
            password: "blocpass",
            password_confirmation: "blocpass"
        }
    end
    
    describe "GET new" do
        it "returns http success" do
            get :new
            expect(response).to have_http_status(:success)
        end
        
        it "instantiates a new user" do
            get :new
            expect(assigns(:user)).to_not be_nil
        end
    end
    
    describe "POST create" do
        it "returns http redirect" do
            post :create, user: new_user
            expect(response).to have_http_status(:redirect)
        end
        # it only returns a redirect if it doesn't rollback due to validations
        
        it "creates a new user" do
            expect{ post :create, user: new_user }.to change(User, :count).by(1)
        end
        # this will fail / rollback for validations issues
        
        it "sets user name properly" do
            post :create, user: new_user
            expect(assigns(:user).name).to eq new_user[:name]
        end
        
        it "sets user email properly" do
            post :create, user: new_user
            expect(assigns(:user).email).to eq new_user[:email]
        end
        
        it "sets user password properly" do
            post :create, user: new_user
            expect(assigns(:user).password).to eq new_user[:password]
        end
        
        it "sets user password confirmation properly" do
            post :create, user: new_user
            expect(assigns(:user).password_confirmation).to eq new_user[:password_confirmation]
        end
        
        it "logs the user in after sign up" do
            post :create, user: new_user
            expect(session[:user_id]).to eq assigns(:user).id
        end
    end
    
    describe "not signed in" do
        let(:factory_user) { create(:user) }
        
        before do
            post :create, user: new_user
        end
        
        it "returns http success" do
            get :show, {id: factory_user.id}
            expect(response).to have_http_status(:success)
        end
        
        it "renders the #show view" do
            get :show, {id: factory_user.id}
            expect(response).to render_template :show
        end
        
        it "assigns factory_user to @user" do
            get :show, {id: factory_user.id}
            expect(assigns(:user)).to eq factory_user
        end
    end

end
