class Guild < ApplicationRecord
  default_scope { order(:characters_count => :desc) }

  validates :name, presence: true, uniqueness: { scope: :realm }, length: { maximum: 100 }

  belongs_to :realm
  has_many :characters
end
