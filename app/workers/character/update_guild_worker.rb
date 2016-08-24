class Character::UpdateGuildWorker
  include Sidekiq::Worker

  def initialize
    @wow_client = WowClient.new(logger)
  end
  
  def perform(character_id)

    logger.info "Performing update character guild for character_id = #{character_id}"

    if character = Character.find(character_id)
      character.guild = @wow_client.create_or_update_guild(character.name, character.realm)
      character.save
    end
  end
end