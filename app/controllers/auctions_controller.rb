class AuctionsController < BaseController
  include ActiveHashRelation
  before_action :find_auction, only: [:show]

  def index
    auctions = apply_filters(Auction.includes(:realm, :character, :item), filter_params)
    auctions = paginate(auctions)
    
    render json: auctions, meta: meta_attributes(auctions)
  end

  def show
    render json: @auction
  end

  private

  def find_auction
    @auction = Auction.find(params[:id])
  end
end
