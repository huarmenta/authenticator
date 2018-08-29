Rails.application.routes.draw do
  mount Authenticator::Engine => "/authenticator"
end
