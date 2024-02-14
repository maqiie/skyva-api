# app/channels/chat_channel.rb

class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{current_user.id}"
  end

  def receive(data)
    ActionCable.server.broadcast("chat_channel_#{current_user.id}", message: data['message'], name: current_user.name, admin: current_user.admin)
  end

  def unsubscribed
    # Any cleanup needed when the channel is unsubscribed
  end
end
