class AuthToken
  attr_accessor :username, :expire_date, :token_type, :payload, :header

  def initialize(decode_token)
    @username = decode_token[0]["sub"]
    @expire_date = Time.at(decode_token[0]["exp"])
    @token_type = decode_token[0]["typ"]
    @payload = decode_token[0]
    @header = decode_token[1]
  end

  class << self
    def encode(username, expire_date, token_type = "access")
      payload = {
        sub: username,
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