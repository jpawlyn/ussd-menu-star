module AuthenticationHelpers
  # see https://github.com/rails/rails/pull/53708/files#r1964116185
  def sign_in_as(user)
    session = user.sessions.create!
    Current.session = session
    request = ActionDispatch::Request.new(Rails.application.env_config)
    cookies = request.cookie_jar
    cookies.signed[:session_id] = { value: session.id, httponly: true, same_site: :lax }
  end

  def sign_out
    Current.session&.destroy!
    cookies.delete(:session_id)
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :system
end
