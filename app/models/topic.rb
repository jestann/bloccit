class Topic < ActiveRecord::Base
    has_many :posts, dependent: :destroy
    # when a topic is destroyed, its associated posts should die
    
    validates :name, length: {minimum: 5}, presence: true
    validates :description, length: {minimum: 15}, presence: true
    # validates :public, presence: true
    # this uses a checkbox which will always supply "public"
    # validating its presence forces it to never be unchecked
end
