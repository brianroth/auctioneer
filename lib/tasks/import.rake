require 'rake'

namespace :wow do
  desc "Import auction data for a realm"
  task :import => :environment do |t|
    raise "'realm' argument is required" unless ENV['realm']

    Auction::ImportRealmDataWorker.perform_async ENV['realm']
  end
end