class Auction::ImportWorker
  include Sidekiq::Worker

  def initialize
    @wow_client = WowClient.new(logger)
  end

  def perform(auction_hash)

    logger.info "Performing import job auction_hash = #{auction_hash.inspect}"

    auction_hash.deep_symbolize_keys!

    item = @wow_client.create_or_update_item(auction_hash[:item])

    character = @wow_client.create_or_update_character(auction_hash[:owner], auction_hash[:ownerRealm])

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
