require 'rails_helper'

RSpec.describe Vote, type: :model do
    let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
    let(:user) { User.create!(name: RandomData.random_name, email: RandomData.random_email, password: RandomData.random_password) }
    let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }
    let(:vote) { Vote.create!(value: 1, post: post, user: user) }
    
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }
    # vote must be either -1 a down vote or 1 an up vote
   
   describe "update_post callback" do
       it "triggers update_post on save" do
           expect(vote).to receive(:update_post).at_least(:once)
           vote.save!
       end
       
       it "should call update_rank on post" do
           expect(post).to receive(:update_rank).at_least(:once)
           vote.save!
       end
   end
    
end
