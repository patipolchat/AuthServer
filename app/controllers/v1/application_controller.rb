module V1
  class ApplicationController < ::ApplicationController
    protected
    def authentication_user
      begin 
        auth_token = AuthToken.decode(access_token)
        if auth_token.token_type == "access"
          @current_user = User.find(auth_token.user_id)
        else
          render json: {error: "wrong token type"}, status: :unauthorized
          return
        end
      rescue JWT::ExpiredSignature
        render json: {error: "expire token"}, status: :unauthorized
        return
      end
    end

    private
    def access_token
      request.headers.fetch(:Authorization).try(:split, " ").try(:last)
    end
  end
end
