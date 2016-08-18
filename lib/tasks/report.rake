require 'rake'

namespace :wow do
  namespace :report do
    desc "Report on under priced auctions"
    task :underpriced => :environment do |t|

      # Underpriced buyouts
      buyouts = Auction.joins(:item).where('auctions.buyout > 0 and auctions.buyout < items.sell_price')

      puts "\nAuctions with buyouts less than vendor price\n#{'-' * 80}"
      if buyouts.any?
        buyouts.each do |auction|
          puts "#{auction.id} | #{auction.buyout} | #{auction.item.sell_price} | #{auction.item.name}"
        end
      else
        puts "None"
      end

      # Underpriced bids
      bids = Auction.joins(:item).where('auctions.bid > 0 and auctions.bid < items.sell_price')

      puts "\nAuctions with bids less than vendor price\n#{'-' * 80}"
      if bids.any?
        bids.each do |auction|
          puts "#{auction.id} | #{auction.bid} | #{auction.item.sell_price} | #{auction.item.name}"
        end
      else
        puts "None"
      end
    end
  end
end
