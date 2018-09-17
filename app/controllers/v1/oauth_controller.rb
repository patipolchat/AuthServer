module V1
  class OauthController < ApplicationController
    def token
      case params["grant_type"]
      when "password"
        password_auth(params["username"], params["password"])
      when "refresh_token"
        refresh_token_auth(params["refresh_token"])
      else
        render json: { error: "wrong grant_type" }, status: :unauthorized
      end
    end

    private 
    def password_auth(username, password)
      user = User.find_by(username: username).try(:authenticate, password)
      if user.present?
        reponse_template(user.id)
      else
        render json: { error: "wrong username or password" }, status: :unauthorized
      end
    end

    def refresh_token_auth(refresh_token)
      begin 
        auth_token = AuthToken.decode(refresh_token)
        if auth_token.token_type == "refresh"
          reponse_template(auth_token.user_id)
        else
          render json: {error: "wrong token type"}, status: :unauthorized
        end
      rescue JWT::ExpiredSignature
        render json: {error: "expire token"}, status: :unauthorized
      end
    end

    def reponse_template(user_id)
      access_token = AuthToken.encode(user_id, 15.minutes.from_now, "access")
      refresh_token = AuthToken.encode(user_id, 14.days.from_now, "refresh")
      render json: {
        token_type: "bearer",
        access_token: access_token,
        refresh_token: refresh_token
      }
    end
  end
end