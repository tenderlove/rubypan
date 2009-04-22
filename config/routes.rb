ActionController::Routing::Routes.draw do |map|
  map.connect 'releases/:action', :controller => 'releases'
  map.root :controller => 'results'
  map.resources :authors
  map.connect 'latest', :controller => 'releases', :action => 'latest'
  map.connect 'latest.:format', :controller => 'releases', :action => 'latest'
  map.connect ':action/:id', :controller => 'results'
  map.connect ':action.:format', :controller => 'results'
  
end
