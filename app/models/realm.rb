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

  def self.cached_find_by_slug(realm_slug)
    Rails.cache.fetch("realm/#{realm_slug}", expires_in: 1.hours) do
      Realm.find_by_slug(realm_slug)
    end
  end

  def self.cached_find_by_name(realm_name)
    Rails.cache.fetch("realm/#{realm_name}", expires_in: 1.hours) do
      Realm.find_by_name(realm_name)
    end
  end
end
