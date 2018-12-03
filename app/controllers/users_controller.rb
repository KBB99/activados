class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :details]
  before_action :admin_user, only: :destroy
  include SessionsHelper
  def index
    if logged_in?
      # byebug
      @subjects = Subject.all
      @users = User.order(:name).paginate(page: params[:page])
      @user = User.find(current_user.id)
      @project = current_user.microposts.build(micropost_params)
      if @project.save
        @user.microposts << @project
        flash[:success] = "Project created succesfully!"
        redirect_to current_user
      else
        render 'index'
      end
    else
      redirect_to login_url
    end
  end


  def all_projects
    if logged_in?
      @user = User.find(current_user.id)
      @projects = Micropost.all
    else
      redirect_to login_url
    end
  end



  def create_project
    @users = User.order(:name).paginate(page: params[:page])
    @user = User.find(current_user.id)
    @project = current_user.microposts.build(micropost_params)
    if logged_in?
      @users = User.order(:name).paginate(page: params[:page])
      @user = User.find(current_user.id)
      @project = current_user.microposts.build(micropost_params)
      
      if @project.save
        @user.microposts << @project
        
        # @project.users << @user.microposts
        # @project.users.each do |s|
          
          # @project << s
          # s << @project

        # end
        flash[:success] = "Project created succesfully!"
        render 'index'
      else
        render 'microposts#create_project'
      end
    else
      redirect_to login_url
    end
  end
  
  def show
    @user = User.find(params[:id])
    @projects = @user.microposts
  end

  def profile
    @user = User.find(params[:id])
    render 'profile'
  end

  def new
    @user = User.new
  end

  def details
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    # byebug
    if @user.update_attributes(update_params)
      # flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end 
  end

  def search_params
    params.permit(:campus, :major, :experience,
      :year, :interests)
    @search_params = params
  end

  def new_project
    @user = User.find(current_user.id)
    @micropost  = current_user.microposts.build
  end

  def edit
    # include FotitosController
    # byebug
    @user = User.find(params[:id])
    # if @user.update_attributes(user_params)
    #   # flash[:success] = "Profile updated"
    #   redirect_to @user
    # else
    #   render 'edit'
    # end
  end

  def profile_picture
    # @picture = 
  end


  def JoinClass
    @class = Subject.find(params[:subject])
    unless @class.users.include?(current_user)
      current_user.subjects << @class
    end
    redirect_to request.referrer
  end
  private

    # def nyu_edu?
    #   @domain = @user.email.split('@')[1]
    #   if @domain != 'nyu.edu'
    #       return true
    #   # end
    #   else
    #       flash[:danger] = "At the moment we only support members of NYU"
    #       return false
    #   end
    # end

    def fotito_params
      params.require(:fotito).permit(:content, :picture)
    end


    def details_params
      params.require(:id).permit(:interests,:technical,:spoken_languages,:other,:connections)
    end

    def user_params
      params.require(:user).permit(:recommendations,:id,:name,:utf8, :authenticity_token, :commit,:first_name,:last_name, :minor, :position, :technical,:spoken_languages,:other,:connections,:internships, :email, :password, :password_confirmation, :campus, :major, :experience,
                                    :year, :interests, :content, :picture, :micropost)
    end

    def update_params
      # byebug
      params.require(:user).permit(:recommendations,:first_name, :last_name, :email, :campus, :other, :interests, :technical, :connections, :spoken_languages, :position, :major, :minor, :year, :internships)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end

    def micropost_params
      params.require(:micropost).permit(:name,:content,:user_id,:public)
    end

    
end