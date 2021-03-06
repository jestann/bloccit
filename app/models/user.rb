class User < ActiveRecord::Base
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :votes, dependent: :destroy
    has_many :favorites, dependent: :destroy
    
    before_save { self.email = email.downcase if email.present? }
    before_save { self.role ||= :member }
    
    validates :name, length: { minimum: 1, maximum: 100 }, presence: true
    
    # first validates a brand new user (pd is nil)
    # second validates updates, allowing changes without pw change
    validates :password, presence: true, length: { minimum: 6 }, if: "password_digest.nil?"
    validates :password, length: { minimum: 6 }, allow_blank: true    

    # why do we allow a 254 character email address?
    validates :email, presence: true, uniqueness: { case_sensitive: false }, length: {minimum: 3, maximum: 254 }
    
    has_secure_password
    # is user.authenticate in here?
    
    enum role: [:member, :admin]
    
    def favorite_for(post)
        favorites.where(post_id: post.id).first
        # why not post: post like in test?
    end
    
    def avatar_url(size)
        gravatar_id = Digest::MD5::hexdigest(self.email).downcase
        "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    end
    
    def has_posts?
        self.posts.first ? true : false
    end
    
    def has_comments?
        self.comments.first ? true : false
    end

    def has_favorites?
        self.favorites.first ? true : false
    end

end
