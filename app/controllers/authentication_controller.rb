class AuthenticationController < ApplicationController
  def authenticate
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
      render json: { token: token }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
