# class ChatChannel < ApplicationCable::Channel
#   def subscribed
#     # stream_from "some_channel"
#   end

#   def unsubscribed
#     # Any cleanup needed when channel is unsubscribed
#   end
# end
# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def receive(data)
    ActionCable.server.broadcast("chat_channel", data)
  end

  def unsubscribed
    # Any cleanup needed when the channel is unsubscribed
  end
end
