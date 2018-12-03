class SubjectsController < ApplicationController
    before_action :logged_in_user
    def show
        @subject = Subject.find(params[:id])
        @users = @subject.users.all
        @message = @subject.messages.new

    end

    def NewNote
        @subject = Subject.find(params[:subject])
        @new = @subject.notes.new
        if params["anonymous"] == "on"
            @new.user = -1
        else
            @new.user = current_user.id
        end
        @new.content = params["note-description"]
        @new.title = params["note-name"]
        @new.save
        redirect_to request.referrer
    end

    def NewFile
        @subject = Subject.find(params[:subject])
        @new = @subject.project_files.new
        @file_details = params["file"]
        @new.name = @file_details.original_filename
        @new.url = @file_details.tempfile
        @new.content_type = @file_details.content_type
        @new.user_id = current_user.id
        @new.save
        redirect_to request.referrer  
    end

    def DestroyFile
        @file = ProjectFile.find(params["format"])
        @file.delete
        redirect_to request.referrer  
    end


    def NoteLike
        @note = Note.find(params[:note])
        @note.likes.new(user_id: current_user.id).save
        redirect_to request.referrer
    end

    def UnLike
        @note = Note.find(params[:note])
        @like = Like.find(@note.likes.where(user_id: current_user.id).ids.last)
        @like.delete
        redirect_to request.referrer
    end
end

