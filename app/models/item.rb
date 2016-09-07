class Item < ApplicationRecord
  default_scope { order(:item_level => :desc) }
  
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 256 }
  validates :item_level, presence: true, numericality: { only_integer: true }

  has_many :auctions
  belongs_to :bind, optional: true

  def self.cached_find_by_id(item_id)
    Rails.cache.fetch("item/#{item_id}", expires_in: 1.hours) do
      Item.find_by_id(item_id)
    end
  end

  def self.cached_create!(attributes)
    item = Item.create!(attributes)
    Rails.cache.write("item/#{item.id}", item)
    item
  end
end