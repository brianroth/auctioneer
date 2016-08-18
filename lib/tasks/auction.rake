require 'rake'

namespace :wow do
  namespace :auction do
    desc "Archive old auctions"
    task :archive => :environment do |t|
      Auction.where("created_at < ?", 48.hours.ago).delete_all
    end
  end
end
