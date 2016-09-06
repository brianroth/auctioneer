class GuildsController < BaseController
  include ActiveHashRelation
  before_action :find_guild, only: [:show]

  def index
    guilds = apply_filters(Guild.includes(:realm), filter_params)
    guilds = paginate(guilds)

    render json: guilds, meta: meta_attributes(guilds)
  end

  def show
    render json: @guild
  end

  private

  def find_guild
    @guild = Guild.find(params[:id])
  end
end
