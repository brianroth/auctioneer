class Auction < ApplicationRecord
  belongs_to :character
  belongs_to :item
  belongs_to :realm
end
