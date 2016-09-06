class ItemSerializer < BaseSerializer
  attributes :id, :name, :item_bind, :item_level, :item_clazz, :item_sub_clazz, :sell_price, :created_at, :updated_at
end