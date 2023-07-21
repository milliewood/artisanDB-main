# app/models/user.rb
class User < ApplicationRecord
  before_create :generate_api_key

  # Include default Devise modules. Others available are: :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :email, type: String
  field :password, type: String
  field :businessName, type: String
  field :phoneNumber, type: String
  field :portNumber, type: Integer
  field :api_key, type: String # New field for API key

  # Validations
  validates :name, :email, :password, :businessName, :phoneNumber, :portNumber, presence: true
  validates :email, uniqueness: true

  private

  def generate_api_key
    loop do
      self.api_key = SecureRandom.uuid
      break unless User.exists?(api_key: api_key)
    end
  end
end

