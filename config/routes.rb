require "#{Rails.root}/lib/api_constraint"
Rails.application.routes.draw do
  scope module: :v1, constraints: ApiConstraint.new(version: 1) do
    post '/oauth/token', to: 'oauth#token'
    resources :users
  end
end
