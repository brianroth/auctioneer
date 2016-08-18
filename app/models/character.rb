class Character < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :realm }, length: { maximum: 100 }
  validates :realm, presence: true, length: { maximum: 100 }

  has_many :auctions
  belongs_to :guild, optional: true
  belongs_to :race, optional: true
  belongs_to :clazz, optional: true
end
