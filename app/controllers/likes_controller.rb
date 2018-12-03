class LikesController < ApplicationController

    def new
      @like = Like.new(like_params)
    end
  
    def create
        
        @user = current_user.id
        @product = params[:note_id]
        likes = {user_id: @user, note_id: @note}
        @like = Like.new(likes)

        @like.save!
        if @like.save
            redirect_to user_path(@user)
        else
            redirect_to product_path
        end
    end
  
    private
  
    def like_params
      params.require(:likes).permit(:user_id, :note_id)
    end
  
end