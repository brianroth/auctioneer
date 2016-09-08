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
      puts "Population by realm"
      realms = Realm.order(:name)

      printf " %-20s | %-5s | %-10s | %10s | %6s | %6s | %-6s | %-8s\n",
        'Realm', 'Type', 'Population', 'Characters', 'Horde', 'Alliance', 'Guilds', 'Auctions'
      puts "#{'-' * 100}\n"

      realms.each do |realm|
        printf " %-20s | %-5s | %-10s | %10.4d | %6.4d | %8.4d | %6.2d | %8d\n",
          realm.name, realm.realm_type, realm.population, realm.characters.count, realm.characters.horde.count, realm.characters.alliance.count, realm.guilds.count, realm.auctions.count if realm.characters.any?
      end
    end
    namespace :distribution do
      desc "Report character class distribution"
      task :class => :environment do |t|
        puts "Character class distribution"
        classes = Character.unscoped.group(:clazz).count.to_a

        classes.sort! { |x,y| y[1] <=> x[1] }
        
        printf "\n\n %-13.13s | %-5.5s\n", 'Class', 'Count'
        puts "#{'-' * 80}\n"

        classes.each do |clazz|
          if clazz[0]
            printf " %-13.13s | %5.5d\n", clazz[0].name, clazz[1]
          else
            printf " %-13.13s | %5.3d\n", 'Unknown', clazz[1]
          end
        end
      end
      desc "Report character race distribution"
      task :race => :environment do |t|
        puts "Character race distribution"
        races = Character.unscoped.group(:race).count.to_a

        races.sort! { |x,y| y[1] <=> x[1] }

        printf "\n\n %-20s | %-6.5s\n", 'Race', 'Count'
        puts "#{'-' * 80}\n"

        races.each do |race|
          if race[0]
            printf " %-20s | %6.1d\n", race[0].name, race[1]
          else
            printf " %-20s | %6.1d\n", 'Unknown', race[1]
          end
        end
      end
    end
  end
end
