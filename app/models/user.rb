class User < ApplicationRecord
    has_many :fotitos, dependent: :destroy
    has_and_belongs_to_many :subjects
    has_and_belongs_to_many :microposts, dependent: :destroy
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    before_save { self.email = email.downcase }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    attr_accessor :validation_code, :flash_notice
    # validate :nyu_edu
    mount_uploader :picture, PictureUploader
    has_many :likes
    has_many :liked_notes, through: :likes, source: :note
    devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

    class << self
    # Returns the hash digest of the given string.
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                            BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end

        def new_token
            SecureRandom.urlsafe_base64
        end
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

  # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

      # Activates an account.
    def activate
        update_attribute(:activated,    true)
        update_attribute(:activated_at, Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    # Returns true if a password reset has expired.
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    def feed
      Micropost.where("user_id = ?", id)
    end

    def self.search(search)
        User.where("first_name LIKE ? OR last_name LIKE ? OR technical LIKE ? OR spoken_languages LIKE ? OR other LIKE ? or connections LIKE ? or internships LIKE ? or campus LIKE ? or major LIKE ? or experience LIKE ? or interests LIKE ? or minor LIKE ? or position LIKE ?","%#{search}%","%#{search}%","%#{search}%","%#{search}%","%#{search}%","%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%","%#{search}%","%#{search}%","%#{search}%") 
    end

    # Makes sure it's an NYU Email

    #Push Notifications

    def push_notification
        UserMailer.new_message(self).deliver_now
    end

    private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def self.new_with_session(params, session)
        super.tap do |user|
          if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
            user.email = data["email"] if user.email.blank?
          end
        end
    end
      
    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
            user.email = auth.info.email
            user.password = Devise.friendly_token[0,20]
            name = auth.info.name.split()
            user.first_name = name[0]
            user.last_name = name[1]   # assuming the user model has a name
            user.picture = auth.info.image # assuming the user model has an image
        end
    end

  end