class PicturesController < ApplicationController
    def profile_picture
        if logged_in?
            @fotitos = current_user.fotitos
            @fotito  = current_user.fotitos.build
            # @feed_items = current_user.feed.paginate(page: params[:page])
        end
    end
end