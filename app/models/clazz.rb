class Clazz < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :power_type, presence: true, length: { maximum: 100 }
end
