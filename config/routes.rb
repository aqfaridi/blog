# == Route Map
#
#                   Prefix Verb   URI Pattern                                       Controller#Action
#              users_index GET    /users/index(.:format)                            users#index
#         article_comments GET    /articles/:article_id/comments(.:format)          comments#index
#                          POST   /articles/:article_id/comments(.:format)          comments#create
#      new_article_comment GET    /articles/:article_id/comments/new(.:format)      comments#new
#     edit_article_comment GET    /articles/:article_id/comments/:id/edit(.:format) comments#edit
#          article_comment GET    /articles/:article_id/comments/:id(.:format)      comments#show
#                          PATCH  /articles/:article_id/comments/:id(.:format)      comments#update
#                          PUT    /articles/:article_id/comments/:id(.:format)      comments#update
#                          DELETE /articles/:article_id/comments/:id(.:format)      comments#destroy
#     vote_article_article POST   /articles/:id/vote_article(.:format)              articles#vote_article
#                 articles GET    /articles(.:format)                               articles#index
#                          POST   /articles(.:format)                               articles#create
#              new_article GET    /articles/new(.:format)                           articles#new
#             edit_article GET    /articles/:id/edit(.:format)                      articles#edit
#                  article GET    /articles/:id(.:format)                           articles#show
#                          PATCH  /articles/:id(.:format)                           articles#update
#                          PUT    /articles/:id(.:format)                           articles#update
#                          DELETE /articles/:id(.:format)                           articles#destroy
#                     tags GET    /tags(.:format)                                   tags#index
#                          POST   /tags(.:format)                                   tags#create
#                  new_tag GET    /tags/new(.:format)                               tags#new
#                 edit_tag GET    /tags/:id/edit(.:format)                          tags#edit
#                      tag GET    /tags/:id(.:format)                               tags#show
#                          PATCH  /tags/:id(.:format)                               tags#update
#                          PUT    /tags/:id(.:format)                               tags#update
#                          DELETE /tags/:id(.:format)                               tags#destroy
#         new_user_session GET    /users/sign_in(.:format)                          sessions#new
#             user_session POST   /users/sign_in(.:format)                          sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)                         sessions#destroy
#            user_password POST   /users/password(.:format)                         devise/passwords#create
#        new_user_password GET    /users/password/new(.:format)                     devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)                    devise/passwords#edit
#                          PATCH  /users/password(.:format)                         devise/passwords#update
#                          PUT    /users/password(.:format)                         devise/passwords#update
# cancel_user_registration GET    /users/cancel(.:format)                           registrations#cancel
#        user_registration POST   /users(.:format)                                  registrations#create
#    new_user_registration GET    /users/sign_up(.:format)                          registrations#new
#   edit_user_registration GET    /users/edit(.:format)                             registrations#edit
#                          PATCH  /users(.:format)                                  registrations#update
#                          PUT    /users(.:format)                                  registrations#update
#                          DELETE /users(.:format)                                  registrations#destroy
#        user_confirmation POST   /users/confirmation(.:format)                     devise/confirmations#create
#    new_user_confirmation GET    /users/confirmation/new(.:format)                 devise/confirmations#new
#                          GET    /users/confirmation(.:format)                     devise/confirmations#show
#                     root GET    /                                                 welcome#index
#                    users GET    /users(.:format)                                  users#index
#              delete_user DELETE /users/:id(.:format)                              users#destroy
#                edit_user GET    /users/:id/edit(.:format)                         users#edit
#              update_user PUT    /users/:id(.:format)                              users#update
#

Rails.application.routes.draw do

  get 'users/index'

  resources :articles do
    resources :comments
    member do
      post 'vote_article', to: 'articles#vote_article'
    end
  end

  resources :tags
  
  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  match '/users/',   to: 'users#index',   via: 'get'
  match '/users/:id',   to: 'users#destroy',   via: 'delete', as: :delete_user
  match '/users/:id/edit',   to: 'users#edit',   via: 'get', as: :edit_user
  match '/users/:id',   to: 'users#update',   via: 'put', as: :update_user

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
