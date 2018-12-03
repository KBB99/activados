class MessagesController < ApplicationController
  before_action do
    # @conversation = Conversation.find(params[:conversation_id])
    # @friend = User.find(@conversation.sender_id)
    # @other = User.find(@conversation.recipient_id)
    @me = User.find(current_user.id)
    @project = Subject.find(params[:message][:micropost_id])
  end
  before_action :check_conversations

  def index
    @conversations = Conversation.all
    @messages = @conversation.messages
    
    if params[:m]
      @messages = @conversation.messages
    end
    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true;
      end
    end

    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end


  def create
    new_message = @project.messages.build(message_params)

    if new_message.save

      ActionCable.server.broadcast 'messaging_room_channel',
                                  message: render_message(new_message)
    end
  end

private
  def message_params
    params.require(:message).permit(:body, :user_id, :micropost_id)
  end
  
  def check_conversations
    # if current_user.id != @project.sender_id && current_user.id != @conversation.recipient_id
    #   redirect_to(users_url)
    # end
  # end
  end

  def render_message(message)
    render(partial: 'message', locals: {message:message})
  end



end