class User < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  has_secure_password 

  before_save :downcase_email, :set_remember_token
  has_many :microposts, dependent: :destroy


  def feed
    Micropost.where('user_id = ?', id)
  end
  private

    def downcase_email
      self.email.downcase! 
    end

    def set_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
