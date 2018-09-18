class AuthToken
  attr_accessor :user_id, :expire_date, :token_type, :payload, :header, :user

  def initialize(decode_token)
    @user_id = decode_token[0]["sub"]
    @user = User.find(@user_id)
    @expire_date = Time.at(decode_token[0]["exp"])
    @token_type = decode_token[0]["typ"]
    @payload = decode_token[0]
    @header = decode_token[1]
  end

  class << self
    def encode(user_id, expire_date, token_type = "access")
      payload = {
        sub: user_id,
        typ: token_type,
        exp: expire_date.to_i,
        nbf: -1.second.from_now.to_i,
        iat: DateTime.now.to_i,
        jti: SecureRandom.uuid
      }
      JWT.encode(payload, "T-Dedsoft",'HS256')
    end

    def decode(token)
      AuthToken.new(JWT.decode(token, "T-Dedsoft", true, { algorithm: 'HS256' }))
    end
  end
end