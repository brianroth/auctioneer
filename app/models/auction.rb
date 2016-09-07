class Auction < ApplicationRecord
  default_scope { order(:bid => :desc) } 

  belongs_to :character
  belongs_to :item
  belongs_to :realm
end
