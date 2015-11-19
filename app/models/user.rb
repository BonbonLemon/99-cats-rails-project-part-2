class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  after_initialize :ensure_session_token

  has_many(
    :cats,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "Cat",
    dependent: :destroy
  )

  has_many(
    :requests,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "CatRentalRequest",
    dependent: :destroy
  )

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password_digest = BCrypt::Password.new(self.password_digest)
    password_digest.is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
