class User < ApplicationRecord
  PASSWORD_LENGTH = (5..20)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  
  validates_presence_of :username,uniqueness: { case_sensitive: false }, 
  length: { minimum: 3, maximum: 25 }

  validates :email, presence: true, 
                      uniqueness: { case_sensitive: false }, 
                      length: { maximum: 105 },
                      format: { with: VALID_EMAIL_REGEX }


  validates :password, length: PASSWORD_LENGTH , allow_nil: true

  has_many :bookmarks
  
  attr_reader :password

  
  def self.find_from_credentials(username, password)
    user = User.find_by(username: username)
    return nil unless user
    user if user.is_password?(password)
  end

  
  def is_password?(password_attempt)
    BCrypt::Password.new(password_digest).is_password?(password_attempt)
  end

  
  def password=(raw_password)
    self.password_digest = BCrypt::Password.create(raw_password)
  end
end