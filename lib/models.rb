require 'active_record'

unless ActiveRecord::Base.connected? then
  dbconfig = YAML::load(File.open('./database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig["development"])
  ActiveRecord::Base.default_timezone = :utc
end

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each { |ext| load ext }
