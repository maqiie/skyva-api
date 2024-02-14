# app/controllers/messages_controller.rb

class MessagesController < ApplicationController
    before_action :authenticate_user!
  
    def create
      message = current_user.messages.create(content: params[:message])
      ActionCable.server.broadcast("chat_channel_#{current_user.id}", message: message.content, name: current_user.name, admin: current_user.admin)
      head :ok
    end
  end
  