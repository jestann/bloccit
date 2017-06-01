require 'rails_helper'
include SessionsHelper

RSpec.describe CommentsController, type: :controller do
    let(:user) { User.create!(name: "Test User", email: "user@u.com", password: RandomData.random_password) }
    let(:other_user) { User.create!(name: RandomData.random_name, email: RandomData.random_email, password: RandomData.random_password) }
    let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
    let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }
    let(:body) { RandomData.random_paragraph }
    let(:comment) { Comment.create!(body: body, post: post, user: user) }

    context "guest" do
        describe "POST create" do
            it "returns http redirect" do
                post :create, post_id: post.id, comment: {body: body}
                expect(response).to redirect_to new_session_path
            end
        end
            
        describe "DELETE destroy" do
            it "returns http redirect" do
                delete :destroy, post_id: post.id, id: comment.id
                expect(response).to redirect_to new_session_path
            end
        end
    end
    
    context "member on comment they don't own" do
        before do
            create_session(other_user)
        end
        
        describe "POST create" do
            it "increases the number of comments by 1" do
                expect{post :create, post_id: post.id, comment: {body: body}}.to change(Comment, :count).by 1
            end
            
            it "redirects to post show view" do
                post :create, post_id: post.id, comment: {body: body}
                expect(response).to redirect_to [topic, post]
            end
        end
        
        describe "DELETE destroy" do
            it "returns http redirect" do
                delete :destroy, post_id: post.id, id: comment.id
                expect(response).to redirect_to [topic, post]
            end
        end
    end
    
    context "member on comment they own" do
        before do
            create_session(user)
        end
        
        describe "POST create" do
            it "increases the number of comments by 1" do
                expect{post :create, post_id: post.id, comment: {body: body}}.to change(Comment, :count).by 1
            end
            
            it "redirects to post show view" do
                post :create, post_id: post.id, comment: {body: body}
                expect(response).to redirect_to [topic, post]
            end
        end
        
        describe "DELETE destroy" do
            it "deletes the comment" do
                delete :destroy, post_id: post.id, id: comment.id
                expect(Comment.where({id: comment.id}).count).to eq 0
            end
            
            it "redirects to post show view" do
                delete :destroy, post_id: post.id, id: comment.id
                expect(response).to redirect_to [topic, post]
            end
        end
    end

    context "admin user on comment they don't own" do
        before do
            other_user.admin!
            create_session(other_user)
        end
        
        describe "POST create" do
            it "increases the number of comments by 1" do
                expect{post :create, post_id: post.id, comment: {body: body}}.to change(Comment, :count).by 1
            end
            
            it "redirects to post show view" do
                post :create, post_id: post.id, comment: {body: body}
                expect(response).to redirect_to [topic, post]
            end
        end
        
        describe "DELETE destroy" do
            it "deletes the comment" do
                delete :destroy, post_id: post.id, id: comment.id
                expect(Comment.where({id: comment.id}).count).to eq 0
            end
            
            it "redirects to post show view" do
                delete :destroy, post_id: post.id, id: comment.id
                expect(response).to redirect_to [topic, post]
            end
        end
    end
end