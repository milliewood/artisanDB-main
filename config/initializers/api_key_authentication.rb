# config/initializers/api_key_authentication.rb

require 'middleware/api_key_authentication'
Rails.application.config.middleware.use ApiKeyAuthentication
