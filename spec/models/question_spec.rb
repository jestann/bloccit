require 'rails_helper'

RSpec.describe Question, type: :model do
  let (:question) { Question.create!(title: "Title", body: "Body", resolved: false) }
  
  describe "attributes" do
    it "has title, body, resolved attributes" do
        expect(question).to have_attributes(title: "Title", body: "Body", resolved: false)
    end
  end
end
