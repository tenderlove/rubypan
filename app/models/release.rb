class Release < ActiveRecord::Base
  belongs_to :ruby_gem

  index do
    name        'A'
    summary     'B'
    meta        'C'
    description 'C'
  end

  named_scope :latest, lambda {
    { :conditions => ['latest = true'] }
  }
end
