Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :doses, only: %i[index show destroy]
  resources :cocktails do
    resources :doses, only: %i[new create edit update]
  end
end
