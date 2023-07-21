class ApiKey < ApplicationRecord
  before_create :generate_keys

  include Mongoid::Document
  include Mongoid::Timestamps
  field :key, type: String
  field :secret, type: String

  private
  def generate_keys 
    self.key = SecureRandom.hex(16)
    self.secret = SecureRandom.hex(32)
  end
end
