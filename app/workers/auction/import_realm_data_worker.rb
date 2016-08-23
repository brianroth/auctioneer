class Auction::ImportRealmDataWorker
  include Sidekiq::Worker

  def perform(realm)

    raise "'realm' argument is required" unless realm

    logger.info "Performing realm import, realm = #{realm}"

    response = RestClient.get "https://us.api.battle.net/wow/auction/data/#{URI.encode(realm)}?locale=en_US&apikey=#{WowCommunityApi::API_KEY}"
    logger.info "Requested auction information for #{ENV['realm']} (X-Plan-Quota-Current=#{response.headers[:x_plan_quota_current]})"
    hash = JSON.parse(response.body,:symbolize_names => true)

    response = RestClient.get hash[:files].first[:url]
    hash = JSON.parse(response.body,:symbolize_names => true)
    hash[:auctions].each do |auction_hash|
      Auction::ImportWorker.perform_async auction_hash
    end
  end
end
