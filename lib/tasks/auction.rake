require 'rake'

namespace :wow do
  namespace :auction do
    desc "Archive old auctions"
    task :archive => :environment do |t|
      Auction.where("created_at < ?", 48.hours.ago).delete_all
    end

    desc "Import auction data for a realm"
    task :import => :environment do |t|
      raise "'realm' argument is required" unless ENV['realm']
      Auction::ImportRealmDataWorker.perform_async ENV['realm']
    end
  end
end
