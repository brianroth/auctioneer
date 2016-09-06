class AuctionSerializer < BaseSerializer
  attributes :id, :bid, :buyout, :quantity, :time_left, :created_at, :updated_at
  has_one :item
  has_one :character
  has_one :realm
end