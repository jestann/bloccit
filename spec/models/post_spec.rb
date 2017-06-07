require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:name) { RandomData.random_sentence }
  let(:description) { RandomData.random_paragraph }
  let(:title) { RandomData.random_sentence }
  let(:body) { RandomData.random_paragraph }
  
  let(:topic) {Topic.create!(name: name, description: description) }
  let(:user) {User.create!(name: RandomData.random_name, email: RandomData.random_email, password: RandomData.random_password) }
  let(:post) { topic.posts.create!(title: title, body: body, user: user) }
  
  it { is_expected.to belong_to(:topic) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:votes) }
  it { is_expected.to have_many(:favorites) }
  
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:topic) }
  it { is_expected.to validate_presence_of(:user) }
  
  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:body).is_at_least(20) }

  # but we still need this one that tests for presence also?
  describe "attributes" do
    it "has title, body, user attributes" do
        expect(post).to have_attributes(title: title, body: body, user: user)
    end
  end
  
  describe "voting" do
    before do
      3.times { post.votes.create!(value: 1) }
      2.times { post.votes.create!(value: -1) }
      @up_votes = post.votes.where(value: 1).count
      @down_votes = post.votes.where(value: -1).count
    end
    
    describe "#up_votes" do
      it "counts the number of votes with value = 1" do
        expect(post.up_votes).to eq(@up_votes)
      end
    end
    
    describe "#down_votes" do
      it "counts the number of votes with value = -1" do
        expect(post.down_votes).to eq(@down_votes)
      end
    end
    
    describe "#points" do
      it "returns the sum of all down and up votes" do
        expect(post.points).to eq(@up_votes - @down_votes)
      end
    end
    
    describe "#update_rank" do
      it "calculates the correct rank" do
        post.update_rank
        expect(post.rank).to eq (post.points + (post.created_at - Time.new(1970,1,1)) / 1.day.seconds)
      end
      
      it "updates the rank when an up vote is created" do
        old_rank = post.rank
        post.votes.create!(value: 1)
        expect(post.rank).to eq (old_rank + 1)
      end
      
      it "updates the rank when a down vote is created" do
        old_rank = post.rank
        post.votes.create!(value: -1)
        expect(post.rank).to eq (old_rank - 1)
      end
    end
  end
  
  describe "#favorite_post" do
    
    it "creates a favorite for current user when a post is created" do
      new_post = topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
      expect(user.favorites.where(post: new_post).first).not_to be_nil
    end
    
    it "sends an email to notify user of new favorite" do
      new_post = topic.posts.new(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
      expect(FavoriteMailer).to receive(:new_post).with(user, new_post)
      new_post.save!
      # is it important to have this in reverse order like this?
    end
  end
  
end
