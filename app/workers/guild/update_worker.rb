class Guild::UpdateWorker
  include Sidekiq::Worker

  def initialize
    @wow_client = WowClient.new(logger)
  end
  
  def perform(guild_id)

    logger.info "Performing import guild guild_id = #{guild_id}"

    if guild = Guild.find(guild_id)
      @wow_client.update_guild(guild)
    end
  end
end
