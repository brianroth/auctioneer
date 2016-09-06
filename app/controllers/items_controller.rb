class ItemsController < BaseController
  include ActiveHashRelation
  before_action :find_item, only: [:show]

  def index
    items = apply_filters(Item.all, filter_params)
    items = paginate(items)

    render json: items, meta: meta_attributes(items)
  end

  def show
    render json: @item
  end

  private

  def find_item
    @item = Item.find(params[:id])
  end
end
