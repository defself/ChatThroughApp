class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :chat_rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :oauth

  delegate :bot_access_token, to: :oauth

  validates :user_name, uniqueness: true

  def name
    "#{first_name} #{last_name}"
  end

  def channel_title
    "chat_with_#{user_name}".downcase
  end

  def slack_authorized?
    oauth&.access_token && oauth.bot_access_token
  end
end
