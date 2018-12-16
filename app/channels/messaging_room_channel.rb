class MessagingRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messaging_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
