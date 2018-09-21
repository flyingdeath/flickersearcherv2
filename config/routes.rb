Flickersearcherv2::Application.routes.draw do



  get '/mainpage/batch', :to => 'mainpage#batch', :as => :batch
  get '/mainpage/interesting', :to => 'mainpage#interesting', :as => :interesting
  get '/mainpage/next_page', :to => 'mainpage#next_page', :as => :next_page
  get '/mainpage/pervous_page', :to => 'mainpage#pervous_page', :as => :pervous_page
  post '/mainpage/save_users', :to => 'mainpage#save_users', :as => :save_users
  get '/mainpage/save_interesting', :to => 'mainpage#save_interesting', :as => :save_interesting
  get '/mainpage/getinfo/:id', :to => 'mainpage#getinfo', :as => :getinfo
  get '/mainpage/save_user', :to => 'mainpage#save_user', :as => :save_user
  get '/interesting', :to => "mainpage#interesting", :as => :interesting
  get '/recent', :to => "mainpage#recent", :as => :recent
  get '/search_nature', :to => "mainpage#search_nature", :as => :search_nature
  get '/save_user', :to => "mainpage#save_user", :as => :save_user
  get '/mainpage/catalog', :to => "mainpage#catalog", :as => :catalog
  get '/mainpage/transfrom', :to => "mainpage#transfrom", :as => :transfrom


  get '/auth/auth_start', :to => "auth#auth_start", :as => :auth_start
  post '/auth/auth_finish', :to => "auth#auth_finish", :as => :auth_finish


  root :to => "mainpage#interesting"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
