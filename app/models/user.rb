class User < ActiveRecord::Base
    has_many :posts
    
    before_save { self.email = email.downcase if email.present? }
    
    validates :name, length: { minimum: 1, maximum: 100 }, presence: true
    
    # first validates a brand new user (pd is nil)
    # second validates updates, allowing changes without pw change
    validates :password, presence: true, length: { minimum: 6 }, if: "password_digest.nil?"
    validates :password, length: { minimum: 6 }, allow_blank: true    

    # why do we allow a 254 character email address?
    validates :email, presence: true, uniqueness: { case_sensitive: false }, length: {minimum: 3, maximum: 254 }
    
    has_secure_password
end
