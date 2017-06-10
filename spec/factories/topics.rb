FactoryGirl.define do
    factory :topic do
        name RandomData.random_sentence
        description RandomData.random_paragraph
    end
end