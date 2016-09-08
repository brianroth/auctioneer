require 'rake'

namespace :wow do
  namespace :guild do
    desc "Update stored guild information from API data"
    task :import => :environment do |t|
      Character.unguilded.leveled.all.each do |character|
        Character::UpdateGuildWorker.perform_async character.id
      end

      Guild.all.each do |guild|
        Guild::UpdateWorker.perform_async guild.id
      end
    end
  end
end
