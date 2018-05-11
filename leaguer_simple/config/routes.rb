Rails.application.routes.draw do

  resources :users
  resources :teams
  resources :matches, only: [:show]
  resources :sessions, only: [:new, :create, :destroy]

  root 'static_pages#home'
  match '/help', to: 'static_pages#help', via: 'get'
  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/league', to: 'leagues#show', via: 'get'

  match '/teams/:id/invite', to: 'teams#invite', via: 'get', as: :invite_to_team
  match '/teams/:id/send_invite', to: 'teams#send_invite', via: 'post', as: :send_invite

  match '/users/:id/accept_invite', to: 'users#accept_invite', via: 'put', as: :accept_invite
  match '/users/:id/accept_invite', to: 'users#decline_invite', via: 'destroy', as: :decline_invite

  match '/teams/:id/challenge', to: 'teams#challenge_teams', via: 'get', as: :challenge_teams
  match '/teams/:id/send_challenge', to: 'teams#send_challenge', via: 'post', as: :send_challenge
  match '/teams/:id/accept_challenge', to: 'teams#accept_challenge', via: 'post', as: :accept_challenge
  match '/teams/:id/cancel_challenge', to: 'teams#cancel_challenge', via: 'post', as: :cancel_challenge

  match '/matches/:id/submit_result', to: 'matches#submit_result', via: 'post', as: :submit_result

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
