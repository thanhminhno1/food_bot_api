class ChatworkController < ApplicationController
  before_action :ensure_room
  before_action :ensure_user_message
  before_action :remove_quote

  def hook
    MessageService.new(params[:webhook_event][:body],
                       params[:webhook_event_type],
                       params[:webhook_event][:message_id],
                       params[:webhook_event][:account_id])
                  .process
  end

  private

  def remove_quote
    params[:webhook_event][:body].gsub! "\n", ""
    params[:webhook_event][:body].gsub! /(\[qt).*(\[\/qt\])/, ""
  end

  def ensure_room
    return response_nothing unless params[:webhook_event][:room_id].to_i == ENV["GROUP"].to_i
  end

  def ensure_user_message
    return response_nothing if params[:webhook_event][:account_id].to_i == ENV["CHATBOT_ID"].to_i
  end

  def response_nothing
    render nothing: true 
  end
end
