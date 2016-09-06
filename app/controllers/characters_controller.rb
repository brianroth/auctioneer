class CharactersController < BaseController
  include ActiveHashRelation
  before_action :find_character, only: [:show]

  def index
    characters = apply_filters(Character.includes(:realm, :race, :clazz, :faction), filter_params)
    characters = paginate(characters)

    render json: characters, meta: meta_attributes(characters)
  end

  def show
    render json: @character
  end

  private

  def find_character
    @character = Character.find(params[:id])
  end
end
