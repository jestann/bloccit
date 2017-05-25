class Post < ActiveRecord::Base
    belongs_to :topic
    belongs_to :user
    # why is the way this is set up slightly diff in rails?
    has_many :comments, dependent: :destroy
    
    default_scope { order('created_at DESC') }
    # scopes allow queries to be method calls
    scope :ordered_by_title, -> { order('title') }
    scope :ordered_by_reverse_created_at, -> { order('created_at') }
    

    validates :title, length: {minimum: 5}, presence: true
    validates :body, length: {minimum: 20}, presence: true
    validates :topic, presence: true
    validates :user, presence: true
    
end