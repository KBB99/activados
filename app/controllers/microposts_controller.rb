class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy
  
    def create
      @micropost = current_user.microposts.build(micropost_params)
      if @micropost.save
        flash[:success] = "Project created!"
        redirect_to projects_url
      else
        @feed_items = []
        render 'static_pages/home'
      end
    end
  
    def destroy
        @micropost.destroy
        flash[:success] = "Project deleted"
        redirect_to request.referrer
    end

    def show
      @project = Micropost.find(params[:id])
      @users = User.all
      @message = @project.messages.new
    end

    def TeamUpdate
      @project = Micropost.find(params[:project])
      @users = User.all
      @users.each do |u|
        

        if (team_params(String(u.id)).values[0] == "1") && @project.users.exclude?(u)
            @project.users << u
          

        elsif @project.users.include?(u) && (team_params(String(u.id)).values[0] == "0")

            @project.users.delete(u)
          
        end
      end
      redirect_to request.referrer
    end

    def NewNote
      @project = Micropost.find(params[:project])
      @new = @project.notes.new
      @new.user = current_user.id
      @new.content = params["note-description"]
      @new.title = params["note-name"]
      # @new.microposts_id = params[:user]
      @new.save
      redirect_to request.referrer
    end

    def DestroyNote
      @note = Note.find(params[:id])
      if @note.user == current_user.id
        @note.destroy
      end
      redirect_to request.referrer
    end

    def join
      @project = Micropost.find(params[:id])
      unless @project.users.include?(current_user)
        @project.users << current_user
      end
      redirect_to @project
    end

    def NewFile
      @project = Micropost.find(params[:project])
      @new = @project.project_files.new
      @file_details = params["file"]
      @new.name = @file_details.original_filename
      @new.url = @file_details.tempfile

      @new.content_type = @file_details.content_type
      @new.user_id = current_user.id
      @new.save
      redirect_to request.referrer

    end

    private


      

      def team_params(id)

        params.require(id)
      end
  
      def micropost_params
        params.require(:micropost).permit(:content, :picture, :document)
      end

      def correct_user

        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
      end
  end