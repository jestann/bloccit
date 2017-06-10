FactoryGirl.define do
    pw = RandomData.random_password
    factory :user do
        name RandomData.random_name
        sequence(:email) {|n| "user#{n}@factory.com" }
        # sequence generates unique values in a specific format
        password pw
        password_confirmation pw
        role :member
    end
end