class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z0-9-]+(\.[a-z0-9-]+)*\.[a-z]{2,4}\z/i
  VALID_LOGIN_REGEX = /\A[a-zA-Z0-9\-._]+\z/i
  VALID_NAME_REGEX = /\A([[:alpha:]'.\-]+( [[:alpha:]'.\-]+)*)?\z/i
  has_secure_password
  has_many :accounts, dependent: :destroy

  validates :name     , presence: true, length: {maximum: 50},
          format: {with: VALID_NAME_REGEX}
  validates :email    , presence: true, length: {maximum: 254},
          format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password , length: {minimum: 6}
  validates :password_confirmation, presence: true

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
