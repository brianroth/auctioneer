class Character::UpdateGuildWorker
  include Sidekiq::Worker

  def perform(character_id)

    logger.info "Performing update character guild for character_id = #{character_id}"

    if character = Character.find(character_id)
      character.guild = WowClient.create_or_update_guild(character.name, character.realm)
      character.save
    end
  end
end