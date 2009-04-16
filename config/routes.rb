ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'results'
  map.connect ':action/:id', :controller => 'results'
  map.connect ':action.:format', :controller => 'results'
end
