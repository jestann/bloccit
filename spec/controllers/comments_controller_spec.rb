require 'rails_helper'
include SessionsHelper

RSpec.describe CommentsController, type: :controller do
    let(:user) { create(:user) }
    let(:topic) { create(:topic) }
    let(:other_user) { create(:user) }
    
    # why is this the first time it matters to list create with parameters?
    let(:post1) { create(:post, topic: topic, user: user) }
    # cannot name this "post" as this creates a method called post that takes 0 arguments
    # it doesn't actually create a variable, and this confuses rspec when it sees "post :create"
    # it returns an error "too many arguments, should be 0 but is 2"

    let(:body) { RandomData.random_paragraph }
    let(:comment) { create(:comment, user: user, post: post1) }

    context "guest" do
        describe "POST create" do
            it "returns http redirect" do
                post :create, post_id: post1.id, comment: {body: body}
                expect(response).to redirect_to new_session_path
            end
        end
            
        describe "DELETE destroy" do
            it "returns http redirect" do
                delete :destroy, post_id: post1.id, id: comment.id
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
                expect{post :create, post_id: post1.id, comment: {body: body}}.to change(Comment, :count).by 1
            end
            
            it "redirects to post show view" do
                post :create, post_id: post1.id, comment: {body: body}
                expect(response).to redirect_to [topic, post1]
            end
        end
        
        describe "DELETE destroy" do
            it "returns http redirect" do
                delete :destroy, post_id: post1.id, id: comment.id
                expect(response).to redirect_to [topic, post1]
            end
        end
    end
    
    context "member on comment they own" do
        before do
            create_session(user)
        end
        
        describe "POST create" do
            it "increases the number of comments by 1" do
                expect{post :create, post_id: post1.id, comment: {body: body}}.to change(Comment, :count).by 1
            end
            
            it "redirects to post show view" do
                post :create, post_id: post1.id, comment: {body: body}
                expect(response).to redirect_to [topic, post1]
            end
        end
        
        describe "DELETE destroy" do
            it "deletes the comment" do
                delete :destroy, post_id: post1.id, id: comment.id
                expect(Comment.where({id: comment.id}).count).to eq 0
            end
            
            it "redirects to post show view" do
                delete :destroy, post_id: post1.id, id: comment.id
                expect(response).to redirect_to [topic, post1]
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
                expect{post :create, post_id: post1.id, comment: {body: body}}.to change(Comment, :count).by 1
            end
            
            it "redirects to post show view" do
                post :create, post_id: post1.id, comment: {body: body}
                expect(response).to redirect_to [topic, post1]
            end
        end
        
        describe "DELETE destroy" do
            it "deletes the comment" do
                delete :destroy, post_id: post1.id, id: comment.id
                expect(Comment.where({id: comment.id}).count).to eq 0
            end
            
            it "redirects to post show view" do
                delete :destroy, post_id: post1.id, id: comment.id
                expect(response).to redirect_to [topic, post1]
            end
        end
    end
end