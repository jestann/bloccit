require 'rails_helper'
include SessionsHelper

RSpec.describe FavoritesController, type: :controller do
    let(:user) { create(:user) }
    let(:topic) { create(:topic) }
    let(:post1) { create(:post, topic: topic, user: user) }

    context 'guest user' do
        describe 'POST create' do
            it 'redirects to the sign in view' do
                post :create, { post_id: post1.id }
                expect(response).to redirect_to new_session_path
            end
        end
        
        describe 'DELETE destroy' do
            it 'redirects to the sign in view' do
                favorite = user.favorites.where(post: post1).create
                delete :destroy, { post_id: post1.id, id: favorite.id }
                expect(response).to redirect_to new_session_path
            end
        end
    end
    
    context 'signed-in user' do
        before do
            create_session(user)
        end
        
        describe 'POST create' do
            it 'redirects to the posts show view' do
                post :create, { post_id: post1.id }
                expect(response).to redirect_to [topic, post1]
            end
            
            it 'creates a favorite for current user and correct post' do
                expect(user.favorites.where(post: post1).first).to be_nil
                post :create, { post_id: post1.id }
                expect(user.favorites.where(post: post1).first).not_to be_nil
                # before was expect user.favorites.find_by_post_id(post1.id)
            end
        end
        
        describe 'DELETE destroy' do
            before do
                @favorite = user.favorites.where(post: post1).create
            end
            
            it 'redirects to the post show view' do
                delete :destroy, { post_id: post1.id, id: @favorite.id }
                expect(response).to redirect_to [topic, post1]
            end
            
            it 'destroys the favorite for the user and post' do
                expect(user.favorites.where(post: post1).first).not_to be_nil
                delete :destroy, { post_id: post1.id, id: @favorite.id }
                expect(user.favorites.where(post: post1).first).to be_nil
                # same as above. Don't forget where returns an array
            end
        end
    end
            
end
