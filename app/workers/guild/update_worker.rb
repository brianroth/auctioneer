class Guild::UpdateWorker
  include Sidekiq::Worker

  def perform(guild_id)

    logger.info "Performing import guild guild_id = #{guild_id}"

    if guild = Guild.find(guild_id)
      WowClient.update_guild(guild)
    end
  end
end
