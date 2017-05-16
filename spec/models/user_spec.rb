require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { User.create!(name: "Test", email: "test@test.com", password_digest: "password") }
    # why just "password" not "password_digest" ?
    # it's a BCrypt thing.
    
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(1) }
    
    # Shoulda tests for email
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_least(3) }
    it { is_expected.to allow_value("test@test.com").for(:email) }
    # what does this last one mean?
    
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
    end
    
    describe "invalid user" do
        # this tests a true negative. is the previous a true positive?
        
        let(:user_with_invalid_name) { User.new(name: "", email: "test@test.com") }
        let(:user_with_invalid_email) { User.new(name: "Test", email: "") }
        
        it "should be an invalid user due to blank name" do
            expect(user_with_invalid_name).to_not be_valid
        end
        
        it "should be an invalid user due to blank email" do
            expect(user_with_invalid_email).to_not be_valid
        end
        
        # is this just redundancy for the sake of being safe?
    end
    
end