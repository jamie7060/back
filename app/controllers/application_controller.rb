class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    if User.find(auth_token[:user][:id]).remember_created_at.blank?
      @current_user = User.find(auth_token[:user][:id])
    else
      # 비밀번호 변경되었는지 확인 token issue 시간이 비번 변경 시간보다 뒤처지면 다시 로그인
      if User.find(auth_token[:user][:id]).remember_created_at.to_i > auth_token[:iat].to_i
        render json: {errors: ['비밀번호가 변경되었습니다. 다시 로그인 해주세요.']}, status: :unauthorized
      else
        @current_user = User.find(auth_token[:user][:id])
      end
    end
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def check_token!
    if user_id_in_token?
      if User.find(auth_token[:user][:id]).remember_created_at.blank?
        @current_user = User.find(auth_token[:user][:id])
      else
        # 비밀번호 변경되었는지 확인 token issue 시간이 비번 변경 시간보다 뒤처지면 다시 로그인
        if User.find(auth_token[:user][:id]).remember_created_at.to_i > auth_token[:iat].to_i
          render json: {errors: ['비밀번호가 변경되었습니다. 다시 로그인 해주세요.']}, status: :unauthorized
        else
          @current_user = User.find(auth_token[:user][:id])
        end
      end
    end
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
    begin
      http_token && auth_token && auth_token[:user][:id].to_i
    rescue
      return false
    end
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
