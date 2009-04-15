ActionController::Routing::Routes.draw do |map|
  map.root :controller => "results"
  map.connect ':action/:id', :controller => 'results'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
