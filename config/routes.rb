Hds::Application.routes.draw do
  
  get 'books/search_authors'
  get 'books/search_illustrators'
  get 'books/search_publishers'
  get 'books/search_themes'
  post 'books/search_tags'
  post 'books/search_for'
  put 'reviews/select_shelf'
  put 'reviews/change_shelf'
  get 'profiles/search_followable_users'
  get 'shelves/list'
  get 'shelves/gridlist'
  match 'publishers/collections_by_publisher/:name' => "publishers#collections_by_publisher", :via => :get

  devise_for :users  
  resources :users do
    resources :profile, :controller => :profiles, :name_prefix => "user_"
  end
  resources :profiles, :only => [:show, :edit] do
    resources :shelves, :name_prefix => "profile_"
    resources :children, :name_prefix => "profile_"
  end
  resources :shelves do
    resources :books, :name_prefix => "shelf_"
  end
  resources :publishers do
    resources :collections
  end
  resources :authors
  resources :illustrators
  resources :collections
  resources :categories do
    get "list_books"
  end
  resources :book_types
  resources :themes do 
    get "list_books"
  end
  resources :books do 
    resources :reviews, :name_prefix => "book_"
  end
  resources :children, :only => [:show]
  resources :reviews
  resources :follows
  resources :tags
    
  
  


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
