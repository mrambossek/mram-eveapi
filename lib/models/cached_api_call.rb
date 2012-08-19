class CachedApiCall < ActiveRecord::Base
  belongs_to :api_key
  serialize :params, Hash

  class << self

    def purge_cache_for(api)
      return unless api
      api.cached_api_calls.where(["cachedUntil < ?", Time.now]).delete_all
    end

    def call_cached_api(which, api, data = {}) # {{{
      min_data = { :keyID => nil }
      data = min_data.merge!(data)
      
      self.purge_cache_for(api) if api

      # see whats left
      cached_call = api.cached_api_calls.where(['apiname = ?', which]).order('cachedUntil DESC').first
    
      content = if cached_call then
        puts "DEBUG: CACHED!"
        cached_call.result
      else 
        clnt = HTTPClient.new
        printf "DEBUG: fetching %s\n", EveApi::base_url + EveApi::urls[which][:url]
        res = clnt.post(EveApi::base_url + EveApi::urls[which][:url], data)
        res.body
      end

      doc = Nokogiri::XML(content)
      cached_until = doc.xpath('/eveapi[@version="2"]/cachedUntil').text

      if cached_call
        cached_call
      else
        api.cached_api_calls.create(:apiname => which, :params => data, :cachedUntil => cached_until, :result => content)
      end
    end # }}}

  end

end
