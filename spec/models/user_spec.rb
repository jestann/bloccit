require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { User.create!(name: "Test", email: "test@test.com", password_digest: "password") }
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
            expect(user).to have_attributes(name: "Test", email: "test@test.com")
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
        
        let(:user_with_invalid_name) { User.new(name: "", email: "test@test.com") }
        let(:user_with_invalid_email) { User.new(name: "Test", email: "") }
        
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
            @post = topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph)
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
end