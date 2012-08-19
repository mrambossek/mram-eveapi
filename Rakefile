require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('mram-eveapi') do |g|
  g.version         = '0.0.1'
  g.summary         = "EVE API Interface Layer"
  g.url             = "https://github.com/mrambossek/mram-eveapi"
  g.author          = "Markus Rambossek"
  g.email           = "git@rambossek.at"
  g.ignore_pattern  = ["tmp/*", "script/*"]
  g.runtime_dependencies = ["httpclient", "nokogiri"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
