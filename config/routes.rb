Rails.application.routes.draw do
  resources :bibliographic_description_items
  resources :bibliographic_descriptions
  resources :source_styles
  resources :profiles
  resources :users
  resources :authors
  resources :bibliographic_styles, only: [:index]
  resources :sources
  # resources :change_styles

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get 'bibliographic_styles', to: 'bibliographic_styles#index'
  get 'bibliographic_styles/apa', to: 'bibliographic_styles#apa'
  get 'bibliographic_styles/mla', to: 'bibliographic_styles#mla'
  get 'bibliographic_styles/harvard', to: 'bibliographic_styles#harvard'
  get 'bibliographic_styles/chicago', to: 'bibliographic_styles#chicago'
  get 'bibliographic_styles/dstu', to: 'bibliographic_styles#dstu'

  get 'change_styles', to: 'change_styles#index'
  get 'change_styles/step_1', to: 'change_styles#step_1'
  get 'change_styles/step_2', to: 'change_styles#step_2'
  get 'change_styles/step_3', to: 'change_styles#step_3'

  get 'define_styles/define', to: 'define_styles#define_style'

  root to: 'define_styles#define'
end
