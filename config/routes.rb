Rails.application.routes.draw do
  devise_for :users

  resources :compression_springs do
    member do
      get "steps/1" => "compression_springs#step1", :as => :step1
      patch "steps/1/update" => "compression_springs#step1_update", :as => :update_step1
      get "steps/2" => "compression_springs#step2", :as => :step2
      patch "steps/2/update" => "compression_springs#step2_update", :as => :update_step2
      get "steps/3" => "compression_springs#step3", :as => :step3
      patch "steps/3/update" => "compression_springs#step3_update", :as => :update_step3
    end
  end
  namespace :admin do
    resources :platforms
  end
  root 'welcome#index'
end
