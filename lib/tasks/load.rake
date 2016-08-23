require 'rake'

namespace :wow do
  namespace :load do
    desc "Update stored guild information from API data"
    task :guilds => :environment do |t|
      Character.where(guild: nil).where.not(level: nil).order(name: :asc).all.each do |character|
        Character::UpdateGuildWorker.perform_async character.id
      end

      Guild.order(realm: :asc, name: :asc).all.each do |guild|
        Guild::UpdateWorker.perform_async guild.id
      end
    end
  end
end
