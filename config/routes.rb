Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html



  #Password
  get 'password_resets/new'
  get 'password_resets/edit'

  get 'sessions/new'
  resources :search, only: [:search_params, :searching]
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update] 
  resources :microposts, only: [:create, :destroy]
  resources :fotitos, only: [:create,:destroy]
  
  #Messaging

  resources :messages
  
  #Teachers

  resources :teachers

  #Subjects

  resources :subjects

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  #Likes
 

  
  
  #Static pages

  root 'users#home'
  get 'logout' => 'sessions#destroy'
  get 'AllProjects' => "users#all_projects" 
  # get 'fotitos/create' => "fotitos#create"
  get 'NewProject' => 'users#create_project', :as => "create_project"
  get 'index' => 'users#index'
  # get 'projects' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'users/:id/details', to: 'users#details', :as => 'details'
  get 'microposts/:id', to: 'microposts#show', :as => "project"
  get 'users/:id/profile', to: 'users#profile', :as => 'profile'
  get 'new_project' => 'users#new_project'
  post 'AddTeam' => 'microposts#TeamUpdate'
  post 'NewNote' => 'microposts#NewNote'
  post 'upload' => 'microposts#NewFile'
  #Searching
  get 'search/index' => 'search#search'
  get 'project/delete' => 'microposts#destroy', :as => 'project_destroy'
  #get 'users/new'
  get 'note/delete' => 'microposts#DestroyNote', :as => 'note_destroy'
  get 'project/join' => 'microposts#join', :as => 'join'
  #Teachers
  post 'TeacherNote' => 'teachers#NewNote'
  post 'AddClass' => 'teachers#AddClass'
  post 'ClassNote' => 'subjects#NewNote'
  post 'ClassFile' => 'subjects#NewFile'
  post 'JoinClass' => 'users#JoinClass', :as => 'JoinClass'
  get 'DeleteFile' => 'subjects#DestroyFile', :as => 'killfile'
  #Likes
  post 'NewLike' => 'teachers#NoteLike'
  post 'SubjectLike' => 'subjects#NoteLike'
  post 'KillLike' => 'teachers#UnLike'
  post 'SubKillLike' => 'subjects#UnLike'
  #Profile Picture
  get 'profile_picture' => 'pictures#profile_picture'
  #Login/Logout actions
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'


  get '*path' => redirect('/404')

  mount ActionCable.server, at: '/cable'

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
