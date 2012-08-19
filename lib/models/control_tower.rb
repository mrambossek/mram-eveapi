# vim: set foldmethod=marker smarttab sw=2: #

class ControlTower < ActiveRecord::Base
  def self.refresh_list(api) # {{{
    return false unless api

    params = { :keyID => api.keyID, :vCode => api.vCode }
    apidata = CachedApiCall.call_cached_api(:StarbaseList, api, params)
    doc = Nokogiri::XML(apidata.result)
    result = doc.xpath('/eveapi[@version="2"]/result')
    doc.xpath('//rowset/row').each do |row|
      # try to find exact tower (matching unique itemID)
      t = ControlTower.find_by_itemID(row[:itemID])
      if t then
        # we found this exact POS, not sure if location can change (no repackage?) but lets update it anyway
        t.locationID = row[:locationID]
        t.moonID = row[:moonID]
        # update volatile infos
        t.state = row[:state]
        t.stateTimestamp = row[:stateTimestamp]
        t.onlineTimestamp = row[:onlineTimestamp]
        t.standingOwnerID = row[:standingOwnerID]
        # set last update to now, and API
        t.last_update_type = 'a'
        t.last_update_ts = Time.now
        t.last_update_api_ts = apidata.created_at
        t.save!
      else
        # try to find manually-added tower (no itemID known yet)
        t = ControlTower.find_by_moonID(row[:moonID])
        if t then
          # we found a match according to moonID, lets update everything
          t.itemID = row[:itemID]
          t.locationID = row[:locationID]
          # update volatile infos
          t.state = row[:state]
          t.stateTimestamp = row[:stateTimestamp]
          t.onlineTimestamp = row[:onlineTimestamp]
          t.standingOwnerID = row[:standingOwnerID]
          # set last update to now, and API
          t.last_update_type = 'a'
          t.last_update_ts = Time.now
          t.last_update_api_ts = apidata.created_at
          t.save!
        else
          # tower could not be found - hence we add new
          attrs = row.attributes.each_with_object({}){|(k,v),h| h[k] = v.value }
          attrs.merge!({ :last_update_type => 'a', :last_update_ts => Time.now, :last_update_api_ts => apidata.created_at })
          ControlTower.create(attrs)
        end
      end 
    end 
  end # }}}
    
  def refresh_tower(api) # {{{
    params = { :keyID => api.keyID, :vCode => api.vCode, :itemID => self.itemID}
    apidata = CachedApiCall.call_cached_api(:StarbaseDetail, api, params)
    doc = Nokogiri::XML(apidata.result)
    result = doc.xpath('/eveapi[@version="2"]/result')
    self.state = result.xpath('./state').text
    self.stateTimestamp = result.xpath('./stateTimestamp').text
    self.onlineTimestamp = result.xpath('./onlineTimestamp').text

    self.usageFlags = result.xpath('./generalSettings/usageFlags').text.to_i
    self.deployFlags = result.xpath('./generalSettings/deployFlags').text.to_i
    self.allowCorp = result.xpath('./generalSettings/allowCorporationMembers').text.to_i
    self.allowAlly = result.xpath('./generalSettings/allowAllianceMembers').text.to_i

    self.useStandingsFrom = result.xpath('./combatSettings/useStandingsFrom').first[:ownerID]
    self.onStandingDrop = result.xpath('./combatSettings/onStandingDrop').first[:standing]
    self.onStatusDropEnabled = result.xpath('./combatSettings/onStatusDrop').first[:enabled]
    self.onStatusDropStanding = result.xpath('./combatSettings/onStatusDrop').first[:standing]
    self.onAggressionEnabled = result.xpath('./combatSettings/onAggression').first[:enabled]
    self.onWarEnabled = result.xpath('./combatSettings/onCorporationWar').first[:enabled]

    self.save!
  end # }}}
    
end
