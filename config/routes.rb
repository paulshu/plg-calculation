Rails.application.routes.draw do
  devise_for :users

  resources :compression_springs
  root 'welcome#index'
end
