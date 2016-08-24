class WowClient
  def initialize(logger = nil)
    @logger = logger
  end

  # owner_realm_name is neither realm slug, nor realm name
  def create_or_update_character(character_name, owner_realm_name)
    
    if realm = Realm.where(slug: owner_realm_name.underscore.dasherize).first

      character = realm.characters.find_by_name(character_name)

      if character.nil? || character.updated_at < 3.days.ago
        begin
          character_hash = get("character/#{realm.slug}/#{URI.encode character_name}")

          if character
            character.update_attributes(clazz_id: character_hash[:class],
                                        race_id: character_hash[:race],
                                        realm: realm,
                                        gender: character_hash[:gender],
                                        level: character_hash[:level],
                                        achievement_points: character_hash[:achievementPoints],
                                        faction: character_hash[:faction],
                                        updated_at: Time.now.utc)
          else
            character = realm.characters.create!(name: character_name,
                                                clazz_id: character_hash[:class],
                                                race_id: character_hash[:race],
                                                gender: character_hash[:gender],
                                                level: character_hash[:level],
                                                achievement_points: character_hash[:achievementPoints],
                                                faction: character_hash[:faction]
                                                )
          end
        rescue RestClient::Exception => e
          log "#{e} for character #{character_name} #{realm.name}", :error
          if character
            character.touch
          else
            character = realm.characters.create!(name: character_name)
          end
        end
      end
    else
      raise "Realm not found: #{realm_name}"
    end
  end

  def update_guild(guild)
    begin
      realm = guild.realm
      guild_hash = get("guild/#{realm.slug}/#{URI.encode guild.name}",
                       { :fields => 'members' })

      if guild_hash[:members]
        guild_hash[:members].each do |member_hash|
          character_hash = member_hash[:character]
          character = realm.characters.find_by_name(character_hash[:name])

          unless character
            begin
              character = guild.characters.create!(name: character_hash[:name],
                                                   realm: realm,
                                                   clazz_id: character_hash[:class],
                                                   race_id: character_hash[:race],
                                                   gender: character_hash[:gender],
                                                   level: character_hash[:level],
                                                   achievement_points: character_hash[:achievementPoints],
                                                   faction: guild_hash[:side]
                                                   )
            rescue ActiveRecord::RecordInvalid => e
              log "Validation failure for character #{realm.name} #{guild.name}: #{e.message}: ", :error
            end
          end
        end
      end
    rescue RestClient::Exception => e
      log "#{e} for guild #{realm.name} #{guild.name}", :error
    end
    guild
  end

  def create_or_update_guild(character_name, realm)
    begin
      guild_hash = get("character/#{realm.slug}/#{URI.encode character_name}",
                       { :fields => 'guild' })

      if guild_hash[:guild]
        guild = realm.guilds.find_by_name(guild_hash[:guild][:name])

        unless guild
          guild = realm.guilds.create!(name: guild_hash[:guild][:name])
        end
      end
    rescue RestClient::Exception => e
      log "#{e} for guild #{realm.name} #{character_name}", :error
    end

    guild
  end

  def create_or_update_item(item_id)
    item = Item.find_by_id(item_id)
    unless item
      begin
        item_hash = get("item/#{item_id}")
        item = Item.create!(id: item_id,
                            name: item_hash[:name],
                            item_bind: item_hash[:itemBind],
                            item_level: item_hash[:itemLevel],
                            item_clazz: item_hash[:itemClass],
                            item_sub_clazz: item_hash[:itemSubClass],
                            buy_price: item_hash[:buyPrice],
                            sell_price: item_hash[:sellPrice])

      rescue RestClient::Exception => e
        log "#{e} for item #{item_id}", :error
      end
    end
    item
  end

  def update_realm_status
    begin
      realms_hash = get("realm/status")

      if realms_hash[:realms]
        realms_hash[:realms].each do |realm_hash|
          realm = Realm.find_by_name(realm_hash[:name])

          if realm
            realm.update_attributes(population: realm_hash[:population])
          else
            realm = Realm.create!(name: realm_hash[:name],
                                  slug: realm_hash[:slug],
                                  realm_type: realm_hash[:type],
                                  population: realm_hash[:population],
                                  battlegroup: realm_hash[:battlegroup],
                                  locale: realm_hash[:locale],
                                  timezone: realm_hash[:timezone]
                                  )
          end
        end
      end
    end
  end

  private

  def log(message, priority = :info)
    if @logger
      @logger.send(priority, message)
    else
      puts message
    end
    message
  end

  def get(resource, options = {})
    parameters = {
      locale: 'en_US',
      apikey: WowCommunityApi::API_KEY
    }.merge(options)

    response = RestClient.get "https://us.api.battle.net/wow/#{resource}",
      params: parameters,
      content_type: :json,
      accept: :json

    log "Requested #{resource} (X-Plan-Quota-Current=#{response.headers[:x_plan_quota_current]})", :debug

    JSON.parse(response.body, :symbolize_names => true)
  end

end
