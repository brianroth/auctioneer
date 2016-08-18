class Race < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :side }, length: { maximum: 100 }
  validates :side, presence: true, length: { maximum: 100 }
end
