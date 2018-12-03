class ConversationsController < ApplicationController
    before_action do
      # :my_conversations
      # @friend = User.find(@conversation.sender_id)
      # @other = User.find(@conversation.recipient_id)
      # @me = User.find(current_user.id)
    end
  
    def index
      @user = User.find(current_user.id)
      @users = User.all
      @conversations = Conversation.all
    end
  
    def create
      if Conversation.between(params[:sender_id],params[:recipient_id]).present?
        @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
      else
        @conversation = Conversation.create!(conversation_params)
      end
      redirect_to conversation_messages_path(@conversation)
    end
  
  private
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end

    def my_conversations
      if @me.id != @conversation.sender_id || @me.id != @conversation.recipient_id
        redirect_to(users_url)
      end
    end

  end