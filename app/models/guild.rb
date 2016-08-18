class Guild < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :realm }, length: { maximum: 100 }
  validates :realm, presence: true, length: { maximum: 100 }

  has_many :characters
end
