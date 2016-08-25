class Realm < ApplicationRecord
  enum types: [:pvp, :pve, :rp, :rppvp]
  
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :realm_type, presence: true, inclusion: { in: Realm.types.keys }, length: { maximum: 5 }
  validates :population, presence: true, length: { maximum: 100 }
  validates :battlegroup, presence: true, length: { maximum: 100 }
  validates :locale, presence: true, length: { maximum: 100 }
  validates :timezone, presence: true, length: { maximum: 100 }

  has_many :characters
  has_many :guilds
  has_many :auctions
end
