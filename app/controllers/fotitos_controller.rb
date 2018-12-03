class FotitosController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    def _create
        @fotito = current_user.fotitos.build(fotito_params)
        if @fotito.save
          flash[:success] = "Profile Picture Updated!"
          redirect_to current_user
        else
            flash[:danger] = "Something Went Wrong, Please Try Again"
            redirect_to '/shared/fotito_form'
        end
      end
    
      def destroy
        @fotito.destroy
        flash[:success] = "Profile Picture Deleted"
        redirect_to '/shared/fotito_form'
      end
    
      private
    
        def fotito_params
          params.require(:fotito).permit(:content, :picture)
        end

        def correct_user
            @fotito = current_user.fotitos.find_by(id: params[:id])
            redirect_to '/shared/fotito_form' if @fotito.nil?
          end
end

