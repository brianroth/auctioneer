class Faction < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
