# lib/middleware/api_key_authentication.rb

class ApiKeyAuthentication
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    api_key = request.env['HTTP_API_KEY']

    if api_key.nil?
      return unauthorized_response
    end

    user = User.find_by(api_key: api_key)

    if user.nil?
      return unauthorized_response
    end

    env['current_user'] = user
    @app.call(env)
  end

  private

  def unauthorized_response
    [401, { 'Content-Type' => 'application/json' }, [{ error: 'Unauthorized' }.to_json]]
  end
end

