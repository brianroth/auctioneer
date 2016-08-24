require 'rake'

namespace :wow do
  namespace :realm do
    desc "Update stored realm information from API data"
    task :import => :environment do |t|
      WowClient.new.update_realm_status
    end
  end
end
