class ApiKey < ActiveRecord::Base
  has_many :cached_api_calls

  def purge_cache
    CachedApiCall.purge_cache_for(self)
  end
end
