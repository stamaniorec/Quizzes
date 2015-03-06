Rails.application.routes.draw do

  devise_for :users
  
  resources :scores

  resources :quizzes do
  	resources :questions
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  
  #Questions routes
  patch "/quizzes/:quiz_id/questions/:id" => "questions#update", :as => "update_question"
  delete "/quizzes/:quiz_id/questions/:id" => "questions#delete", :as => "destroy_question"
  
  #Users routes
  get 'users' => 'users#index', as: 'users_index'
  get 'users/:id'=> 'users#show', as: 'user_show'

  get 'leaderboard/play' => 'leaderboard#show_play_leaderboard', as: 'play_leaderboard'
  get 'leaderboard/create' => 'leaderboard#show_create_leaderboard', as: 'create_leaderboard'
  get 'leaderboard/general' => 'leaderboard#show_general_leaderboard', as: 'show_general_leaderboard'
  match 'leaderboard', to: 'leaderboard#show_general_leaderboard', via: :get
  
  root 'quizzes#index'

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
