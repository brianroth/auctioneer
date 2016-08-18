require 'rake'

namespace :wow do
  desc "Import auction data for a realm"
  task :import => :environment do |t|
    raise "'realm' argument is required" unless ENV['realm']

    realm_name = URI.encode ENV['realm']

    response = RestClient.get "https://us.api.battle.net/wow/auction/data/#{realm_name}?locale=en_US&apikey=#{WowCommunityApi::API_KEY}"
    puts "Requested auction information for #{ENV['realm']} (X-Plan-Quota-Current=#{response.headers[:x_plan_quota_current]})"
    hash = JSON.parse(response.body,:symbolize_names => true)

    response = RestClient.get hash[:files].first[:url]
    hash = JSON.parse(response.body,:symbolize_names => true)
    hash[:auctions].each do |auction_hash|
      item = WowClient.create_or_update_item(auction_hash[:item])

      character = WowClient.create_or_update_character(auction_hash[:owner], auction_hash[:ownerRealm])

      auction = Auction.find_by_id(auction_hash[:auc])

      if auction
        auction.update_attributes(bid: auction_hash[:bid],
                                  quantity: auction_hash[:quantity],
                                  buyout: auction_hash[:buyout],
                                  time_left: auction_hash[:timeLeft])
      else
        if (character && item)
          auction = character.auctions.create!(item: item,
                                               bid: auction_hash[:bid],
                                               quantity: auction_hash[:quantity],
                                               buyout: auction_hash[:buyout],
                                               time_left: auction_hash[:timeLeft])
        end
      end
    end
  end
end
