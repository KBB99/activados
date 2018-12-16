class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
        @user = User.from_omniauth(request.env["omniauth.auth"])

        if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to conversations_path
        end
    end

    def google_oauth2
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env['omniauth.auth'])
  
        if @user.persisted?
          flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
          sign_in_and_redirect @user, event: :authentication
        else
          session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
          redirect_to conversations_path, alert: @user.errors.full_messages.join("\n")
        end
    end


    def google
        @user = User.find_or_create_from_auth_hash(env["omniauth.auth"])
        session[:user_id] = @user.id
        redirect_to :me
    end

    def failure
        redirect_to root_path
    end
end