class ChatworkController < ApplicationController
  def hook
    #  "message_updated"
    if params[:webhook_event][:account_id] != ENV["CHATBOT_ID"]
      chatwork.create_message room_id: ENV["GROUP"], body: "Hello, ChatWork!"
    end
    # if params[:webhook_event_type] == "message_created"
    #   body = params[:webhook_event][:body]
    #   if body.include? "Menu"
    #     body.slice! 0, body.index("Menu")+4
    #     body = body[body.index("["), body.rindex("]")]
    #     body.split("/").each do |index, value|
    #       if index == 0
    #         menu = Menu.new name: "name", message_id: params[:webhook_event][:message_id]
    #         if menu.save
    #           chatwork.create_message((room_id: ENV["GROUP"], body: "Hello, ChatWork!"))
    #         else
    #           chatwork.create_message((room_id: ENV["GROUP"], body: "Hello, ChatWork!"))
    #         end
    #       else

    #       end
    #     end
    #     menu = Menu.create name: "name", message_id: params[:webhook_event][:message_id]

    #     menu = 
    #   end

      
      

    # end
  end
end
