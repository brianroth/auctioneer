class Character < ApplicationRecord
  default_scope { order(:name => :asc) } 

  validates :name, presence: true, uniqueness: { scope: :realm }, length: { maximum: 100 }

  has_many :auctions
  belongs_to :realm
  belongs_to :guild, optional: true, counter_cache: true
  belongs_to :race, optional: true
  belongs_to :clazz, optional: true
  belongs_to :faction, optional: true
end
