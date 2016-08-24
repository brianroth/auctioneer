class Auction::ImportRealmDataWorker
  include Sidekiq::Worker

  def initialize
    @wow_client = WowClient.new(logger)
  end
  
  def perform(realm_name)

    logger.info "Performing realm import, realm_name = #{realm_name}"

    raise "'realm' argument is required" unless realm_name

    @wow_client.update_realm_status

    realm = Realm.where("lower(name) = ?", realm_name.downcase).first

    if realm
      response = RestClient.get "https://us.api.battle.net/wow/auction/data/#{realm.slug}?locale=en_US&apikey=#{WowCommunityApi::API_KEY}"
      logger.info "Requested auction information for #{realm.name} (X-Plan-Quota-Current=#{response.headers[:x_plan_quota_current]})"
      hash = JSON.parse(response.body,:symbolize_names => true)

      response = RestClient.get hash[:files].first[:url]
      hash = JSON.parse(response.body,:symbolize_names => true)
      hash[:auctions].each do |auction_hash|
        Auction::ImportWorker.perform_async auction_hash
      end
    else
      logger.error "Realm #{realm_name} was not found"
    end

  end
end
