Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  root :to => 'home#index'
  get '/products', :to => 'products#index'

  # get '/collections', :to => 'collections#index'

  # get '/collections/:id', :to => 'home#show'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
