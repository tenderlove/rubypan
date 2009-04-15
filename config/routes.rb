ActionController::Routing::Routes.draw do |map|
  map.root :controller => "search"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
