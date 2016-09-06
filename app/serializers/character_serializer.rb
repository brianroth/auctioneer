class CharacterSerializer < BaseSerializer
  attributes :id, :name, :level, :achievement_points, :created_at, :updated_at
  has_one :clazz, key: :class
  has_one :race
  has_one :realm
  has_one :faction
end