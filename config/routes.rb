Rails.application.routes.draw do
  resources :bibliographic_description_items
  resources :bibliographic_descriptions
  resources :source_styles
  resources :profiles
  resources :users
  resources :authors
  resources :bibliographic_styles
  resources :sources
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
