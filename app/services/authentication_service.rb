require 'jwt'

class AuthenticationService
  def initialize(username, password)
    @username = username
    @password = password
    @service_errors = {}
  end

  def call
    if user.present?
      payload = {
        username: user.username,
        exp: 1.hours.from_now
      }
     JWT.encode(payload, "T-Dedsoft",'HS256') 
    else 
      nil
    end
  end

  def errors
    service_errors
  end

  private

  attr_accessor :username, :password, :service_errors

  def user
    user = User.find_by(username: username)
    return user if user && user.authenticate(password)

    service_errors["user_auth"] = 'invalid credentials'
    nil
  end
end