class Post < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user
    # why is the way this is set up slightly diff in rails?
    has_many :comments, dependent: :destroy
    has_many :votes, dependent: :destroy
    has_many :favorites, dependent: :destroy
    
    default_scope { order('rank DESC') }
    # scopes allow queiries to be method calls
    scope :visible_to, -> (user) { user ? all : joins(:topic).where('topics.public' => true) }
    # this uses a lambda "->" to ensure a user is signed in
    # if a user is present, return all
    # if not we use ActiveRecord joins to retrieve all posts from public topics
    # this query uses a SQL inner join to query a collection's relations in one query

    validates :title, length: {minimum: 5}, presence: true
    validates :body, length: {minimum: 20}, presence: true
    validates :topic, presence: true
    validates :user, presence: true
    
    def up_votes
        votes.where(value: 1).count
        # implied self.votes
    end
    
    def down_votes
        votes.where(value: -1).count
    end
    
    def points
        votes.sum(:value)
        # ActiveRecord's sum method, passing value
        # that tells it what to sum in the collection
    end
    
    def update_rank
        age_in_days = (created_at - Time.new(1970,1,1)) / 1.day.seconds
        new_rank = points + age_in_days
        update_attribute(:rank, new_rank)
    end
    
end
