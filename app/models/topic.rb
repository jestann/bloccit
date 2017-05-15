class Topic < ActiveRecord::Base
    has_many :posts, dependent: :destroy
    # when a topic is destroyed, its associated posts should die
end
