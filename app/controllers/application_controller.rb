class ApplicationController < ActionController::API
  # before_action :chatwork
  def chatwork
    # ChatWork.api_key = ENV["CHATWORK_API_TOKEN"]
    ChatWork::Client.new(api_key: ENV["CHATWORK_API_TOKEN"])
  end
end
