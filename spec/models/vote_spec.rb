require 'rails_helper'

RSpec.describe Vote, type: :model do
    let(:topic) { create(:topic) }
    let(:user) { create(:user) }
    let(:post) { create(:post) }
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
