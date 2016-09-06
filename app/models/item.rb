class Item < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :item_bind, presence: true, numericality: { only_integer: true }
  validates :item_level, presence: true, numericality: { only_integer: true }

  has_many :auctions

  def self.cached_find_by_id(item_id)
    Rails.cache.fetch("item/#{item_id}", expires_in: 1.hours) do
      item = Item.find_by_id(item_id)
    end
  end
end
