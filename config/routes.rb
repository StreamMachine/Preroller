Preroller::Engine.routes.draw do
  namespace :admin do
    resources :outputs
    
    resources :campaigns do 
      member do
        post :upload
        post :toggle
      end
    end
    
    root :to => "home#index"
  end
  
  match '/p/:key/:stream_key' => "public#preroll", :as => :preroll
end
