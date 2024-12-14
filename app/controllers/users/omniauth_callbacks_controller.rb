class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
        if (@user.class == User && @user.persisted?)
          sign_in(@user, store: false)
          @token = JWT.encode(payload(@user), ENV['SECRET_KEY_BASE'], 'HS256')
          if @user.sign_in_count == 1
            uri = URI("https://twoyak.com/add-info")
            uri.query = URI.encode_www_form(:token => @token)
            redirect_to uri.to_s
            return
          else
            uri = URI("https://twoyak.com/login")
            uri.query = URI.encode_www_form(:token => @token)
            redirect_to uri.to_s
            return
          end
        else

          uri = URI("https://twoyak.com/login-error")
          if @user.class != User
            #에러 url에 포함해서 리턴
            uri.query = URI.encode_www_form(@user)
          end
          redirect_to uri.to_s
          return
        end
      end
    }
  end

  [:facebook, :google_oauth2, :naver].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    return
  end

  def payload(user)
    return nil unless user and user.id
    {
                :iss => "twoyak.com",
                :user => {id: user.id, email: user.email, sub_users: user.sub_users.select(:id, :user_name).as_json },
                :iat => Time.now.to_i
    }
  end

  def flash
    super
  end
  
end