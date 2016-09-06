class GuildSerializer < BaseSerializer
  attributes :id, :name, :created_at, :members, :updated_at
  has_one :realm

  def members
    object.characters.size
  end
end