require 'rake'

namespace :wow do
  namespace :load do
    desc "Update stored guild information from API data"
    task :guilds => :environment do |t|
      Character.where(guild: nil).where.not(level: nil).order(name: :asc).all.each do |character|
        character.guild = WowClient.create_or_update_guild(character.name, character.realm)
        character.save
      end

      Guild.order(realm: :asc, name: :asc).all.each do |guild|
        WowClient.update_guild(guild.name, guild.realm)
      end
    end
  end
end
