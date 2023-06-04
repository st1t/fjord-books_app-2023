Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books
  resources :users, only: %i(index show)
  resources :reports, only: %i(index show new edit create update destroy)
  resources :comments, only: %i(show new create destroy)
end
