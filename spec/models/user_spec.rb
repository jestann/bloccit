require 'rails_helper'


RSpec.describe User, type: :model do
    let(:user) { create(:user) }
    # why just "password" not "password_digest" ?
    # it's a BCrypt thing.
    
    it { is_expected.to have_many(:posts) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:votes) }
    it { is_expected.to have_many(:favorites) }
    
    # Shoulda tests for name
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(1) }
    # I don't know how to write a regex text at present.

    # Shoulda tests for email
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_least(3) }
    it { is_expected.to allow_value("test@test.com").for(:email) }
    # this last one tests a true positive. it should pass this example.
    
    # Shoulda tests for password
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to have_secure_password }
    # uses a BCrypt method above to hash passwords
    
    describe "attributes" do
        it "should have name and email attributes" do
            expect(user).to have_attributes(name: user.name, email: user.email)
            # tests only name and email
        end
        
        it "responds to role" do
            expect(user).to respond_to(:role)
        end
        
        it "respondes to #admin?" do
            expect(user).to respond_to(:admin?)
        end
        
        it "responds to #member?" do
            expect(user).to respond_to(:member?)
        end
    end
    
    describe "roles" do
        it "is member by default" do
            expect(user.role).to eql("member")
        end
        
        context "member user" do
            it "returns true for #member?" do
                expect(user.member?).to be_truthy
            end
            
            it "returns false for #admin?" do
                expect(user.admin?).to be_falsey
            end
        end
        
        context "admin user" do
            before do
                user.admin!
            end
            
            it "returns false for #member?" do
                expect(user.member?).to be_falsey
            end
            
            it "returns true for #admin?" do
                expect(user.admin?).to be_truthy
            end
        end
    end
            
    describe "invalid user" do
        # this tests a true negative. it should not allow these examples.
        # why the different style?
        # is this just redundancy for the sake of being safe?
        
        let(:user_with_invalid_name) { build(:user, name: "") }
        let(:user_with_invalid_email) { build(:user, email: "") }
        
        it "should be an invalid user due to blank name" do
            expect(user_with_invalid_name).to_not be_valid
        end
        
        it "should be an invalid user due to blank email" do
            expect(user_with_invalid_email).to_not be_valid
        end
    end
    
    describe "#favorite_for(post)" do
        before do
            topic = Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)
            @post = topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)
        end
        
        it "returns nil if the user has not favorited the post" do
            expect(user.favorite_for(@post)).to be_nil
        end
        
        it "returns the appropriate favorite if it exists" do
            favorite = user.favorites.where(post: @post).create
            # why this syntax? 
            # why not just user.favorites.create!(post: post)?
            expect(user.favorite_for(@post)).to eq(favorite)
        end
    end
    
    describe ".avatar_url" do
        let(:known_user) { create(:user, email: "blochead@bloc.io") }
        
        it "returns the proper Gravatar url for a known email entity" do
            expected_gravatar = "http://gravatar.com/avatar/bb6d1172212c180cfbdb7039129d7b03.png?s=48"
            expect(known_user.avatar_url(48)).to eq(expected_gravatar)
            # the s=48 parameter means a 48x48 image
        end
    end
    
    describe "#has_posts?" do
        let(:user2) { create(:user) }
        let(:topic) { create(:topic) }

        it "returns true if user has posts" do
            user2.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, topic: topic) 
            expect(user2.has_posts?).to be true
        end

        it "returns false if user has no posts" do
           expect(user2.has_posts?).to be false
       end
    end

    describe "#has_comments?" do
        let(:user2) { create(:user) }
        let(:post1) { create(:post) }
        
        it "returns true if user has comments" do
            user2.comments.create!(body: RandomData.random_paragraph, post: post1)
            expect(user2.has_comments?).to be true
        end
        
        it "returns nil if user has no posts or comments" do
           expect(user2.has_comments?).to be false
       end
    end

    describe "#has_favorites?" do
        let(:user2) { create(:user) }
        let(:post1) { create(:post) }
        
        it "returns true if user has favorites" do
            user2.favorites.create!(post: post1) 
            expect(user2.has_favorites?).to be true
        end
        
        it "returns false if user has no favorites" do
           expect(user2.has_favorites?).to be false
       end
    end
    
end