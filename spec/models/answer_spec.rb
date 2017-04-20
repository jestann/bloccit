require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { Question.create!(title: "Title", body: "Body", resolved: false) }
  let (:answer) { Answer.create!(body: "Body", question: question) }
  
  describe "attributes" do
    it "has a body attribute" do
        expect(answer).to have_attributes(body: "Body")
    end
  end
end
