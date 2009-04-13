class RubyGem < ActiveRecord::Base
  has_and_belongs_to_many :authors
  has_many :releases
end
