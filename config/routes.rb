Rails.application.routes.draw do
  post "/", to: "chatwork#hook" 
end
