class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user][:id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  private
  
  def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
  end

  def auth_token
      @auth_token ||= HashWithIndifferentAccess.new(JWTWrapper.decode(http_token))
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user][:id].to_ia
  end

  # #Override Devise's authenticate_user! method
  # def authenticate_user!(options = {})
  #   head :unauthorized unless signed_in?
  # end

  # def current_user
  #   @current_user ||= super || User.find(@current_user_id)
  # end

  # def signed_in?
  #   @current_user_id.present?
  # end
end
