class Item < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :item_bind, presence: true, numericality: { only_integer: true }
  validates :item_level, presence: true, numericality: { only_integer: true }

  has_many :auctions
end
