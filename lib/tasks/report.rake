require 'rake'

namespace :wow do
  namespace :report do
    desc "Report on under priced auctions"
    task :underpriced => :environment do |t|

      # Underpriced buyouts
      buyouts = Auction.joins(:item)
      .where('auctions.buyout > 0 and (auctions.buyout+100000) < items.sell_price')
      .order(:realm_id)

      puts "\nAuctions with buyouts less than vendor price\n\n"
      printf " %-12.12s | %-6.6s | %-6.6s | %-10s\n", 'Realm', 'Buyout', 'Vendor','Item'
      puts "#{'-' * 80}\n"

      if buyouts.any?
        buyouts.each do |auction|
          printf " %-12.12s | %-6d | %-6d | %-15s\n",
            auction.realm.name, auction.buyout, auction.item.sell_price, auction.item.name
        end
      else
        puts "None"
      end

      # Underpriced bids
      bids = Auction.joins(:item)
      .where('auctions.bid > 0 and (auctions.bid+100000) < items.sell_price')
      .order(:realm_id)

      puts "\nAuctions with bids less than vendor price\n\n"
      printf " %-12.12s | %-6.6s | %-6.6s | %-10s\n", 'Realm', 'Bid', 'Vendor','Item'
      puts "#{'-' * 80}\n"

      if bids.any?
        bids.each do |auction|
          printf " %-12.12s | %-6d | %-6d | %-15s\n",
            auction.realm.name, auction.bid, auction.item.sell_price, auction.item.name
        end
      else
        puts "None"
      end
    end
    desc "Report realm population"
    task :population => :environment do |t|

      realms = Realm.order(:name)

      printf " %-20.20s | %-5.5s | %-10.10s | %-10.10s | %-6.6s | %-8.8s\n", 'Realm', 'Type', 'Population', 'Characters','Guilds', 'Auctions'
      puts "#{'-' * 80}\n"

      realms.each do |realm|
        printf " %-20.20s | %-5s | %-10s | %-10d | %-6d | %-8d\n",
          realm.name, realm.realm_type, realm.population, realm.characters.count, realm.guilds.count, realm.auctions.count if realm.characters.any?
      end
    end
  end
end
