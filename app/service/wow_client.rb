module WowClient

  def self.create_or_update_guild(character_name, realm)
    realm_slug = realm.parameterize
    name_encoded = URI.encode character_name

    begin
      response = RestClient.get "https://us.api.battle.net/wow/character/#{realm_slug}/#{name_encoded}?fields=guild&locale=en_US&apikey=#{WowCommunityApi::API_KEY}"
      puts "Requested character guild information for #{realm} #{character_name} (X-Plan-Quota-Current=#{response.headers[:x_plan_quota_current]})"
      guild_hash = JSON.parse(response.body, :symbolize_names => true)

      if guild_hash[:guild]
        guild = Guild.find_by_name_and_realm(guild_hash[:guild][:name], guild_hash[:guild][:realm])

        unless guild
          guild = Guild.create!(name: guild_hash[:guild][:name], realm: guild_hash[:guild][:realm])
        end
      end
    rescue RestClient::NotFound => e
    rescue RestClient::InternalServerError => e
      puts "InternalServerError for guild #{realm_slug} #{name_encoded}"
    rescue RestClient::GatewayTimeout => e
      puts "Gateway Timeout for for guild #{realm_slug} #{name_encoded}"
    end

    guild
  end

  def self.update_guild(name, realm)
    realm_slug = realm.parameterize
    name_encoded = URI.encode name

    begin
      response = RestClient.get "https://us.api.battle.net/wow/guild/#{realm_slug}/#{name_encoded}?fields=members&locale=en_US&apikey=#{WowCommunityApi::API_KEY}"
      puts "Requested guild member information for #{realm} #{name} (X-Plan-Quota-Current=#{response.headers[:x_plan_quota_current]})"
      guild_hash = JSON.parse(response.body, :symbolize_names => true)
      if guild_hash['members']
        guild_hash['members'].each do |member_hash|
          character_hash = member_hash['character']
          character = Character.find_by_name_and_realm(character_hash[:name], character_hash[:realm])

          unless character
            puts "Creating character realm=#{character_hash[:realm]} name=#{character_hash[:name]}"
            character = guild.characters.create!(name: character_hash[:name],
                                                 realm: character_hash[:guildRealm],
                                                 clazz_id: character_hash[:class],
                                                 race_id: character_hash[:race],
                                                 gender: character_hash[:gender],
                                                 level: character_hash[:level],
                                                 achievement_points: character_hash[:achievementPoints],
                                                 faction: guild_hash[:side]
                                                 )
          end
        end
      end
    rescue RestClient::NotFound => e
      puts "Guild not found for guild #{realm_slug} #{name_encoded}"
    rescue RestClient::InternalServerError => e
      puts "InternalServerError for guild #{realm_slug} #{name_encoded}"
    rescue RestClient::GatewayTimeout => e
      puts "Gateway Timeout for for guild #{realm_slug} #{name_encoded}"
    rescue ActiveRecord::RecordInvalid => e
      puts "realm_slug=#{realm_slug} name=#{name} #{e.message}: "
    end

  end

  def self.create_or_update_item(item_id)
    item = Item.find_by_id(item_id)
    unless item
      begin
        response = RestClient.get "https://us.api.battle.net/wow/item/#{item_id}?locale=en_US&apikey=#{WowCommunityApi::API_KEY}"
        puts "Requested item information for item #{item_id} (X-Plan-Quota-Current=#{response.headers[:x_plan_quota_current]})"
        item_hash = JSON.parse(response.body, :symbolize_names => true)
        item = Item.create!(id: item_id,
                            name: item_hash[:name],
                            item_bind: item_hash[:itemBind],
                            item_level: item_hash[:itemLevel],
                            item_clazz: item_hash[:itemClass],
                            item_sub_clazz: item_hash[:itemSubClass],
                            buy_price: item_hash[:buyPrice],
                            sell_price: item_hash[:sellPrice])

      rescue RestClient::NotFound => e
        puts "Item #{item_id} not found on remote server"
      rescue RestClient::InternalServerError => e
        puts "InternalServerError for item #{item_id}"
      rescue RestClient::GatewayTimeout => e
        puts "Gateway Timeout for item #{item_id}"
      rescue RestClient::ServiceUnavailable => e
        puts "Service Unavailable for item #{item_id}"
      end
    end
  end

  def self.create_or_update_character(name, realm)
    realm_slug = realm.underscore.dasherize
    name_encoded = URI.encode name

    character = Character.find_by_name_and_realm(name, realm)

    begin
      response = RestClient.get "https://us.api.battle.net/wow/character/#{realm_slug}/#{name_encoded}?locale=en_US&apikey=#{WowCommunityApi::API_KEY}"
      puts "Requested character information for #{realm} #{name} (X-Plan-Quota-Current=#{response.headers[:x_plan_quota_current]})"
      character_json = JSON.parse(response.body, :symbolize_names => true)

      if character
        character.update_attributes(clazz_id: character_json[:class],
                                    race_id: character_json[:race],
                                    gender: character_json[:gender],
                                    level: character_json[:level],
                                    achievement_points: character_json[:achievementPoints],
                                    faction: character_json[:faction])
      else
        character = Character.create!(name: name,
                                      realm: realm,
                                      clazz_id: character_json[:class],
                                      race_id: character_json[:race],
                                      gender: character_json[:gender],
                                      level: character_json[:level],
                                      achievement_points: character_json[:achievementPoints],
                                      faction: character_json[:faction]
                                      )
      end
    rescue RestClient::NotFound => e
      character = Character.create!(name: name, realm: realm) unless character
    rescue RestClient::InternalServerError => e
      puts "InternalServerError for character #{name} #{realm}"
      character = Character.create!(name: name, realm: realm) unless character
    rescue RestClient::GatewayTimeout => e
      puts "Gateway Timeout for character #{name} #{realm}"
      character = Character.create!(name: name, realm: realm) unless character
    rescue RestClient::ServiceUnavailable => e
      puts "Service Unavailable for character #{name} #{realm}"
      character = Character.create!(name: name, realm: realm) unless character
    end

    character
  end
end
