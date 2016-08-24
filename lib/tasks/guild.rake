require 'rake'

namespace :wow do
  namespace :guild do
    desc "Update stored guild information from API data"
    task :import => :environment do |t|
      Character.where(guild_id: nil).where.not(level: nil).order(name: :asc).all.each do |character|
        Character::UpdateGuildWorker.perform_async character.id
      end

      Guild.all.each do |guild|
        Guild::UpdateWorker.perform_async guild.id
      end
    end
  end
end
