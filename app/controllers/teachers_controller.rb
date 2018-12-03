class TeachersController < ApplicationController
    before_action :logged_in_user
    
    def index
        @teachers = Teacher.all
    end

    def show
        @teacher = Teacher.find(params[:id])
    end

    def NewNote
      @teacher = Teacher.find(params[:teacher])
      @new = @teacher.notes.new
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

    def AddClass
      @teacher = Teacher.find(params[:teacher])
      @new = @teacher.subjects.new
      @new.name = params["note-name"]
      @new.save
      redirect_to @new
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
