require 'sinatra'
require 'yaml'
require 'open-uri'
require 'nokogiri'
require 'digest/md5'
require 'time'
require 'json'
require 'haml'
require 'memcached'
require 'sinatra/memcache'

require File.expand_path(File.join(File.dirname(__FILE__), 'lib/classes/muni'))

DAY = 24 * 60 * 60

get '/' do
	haml :index
end

get '/muni.json' do
	cache 'arrivals', :expiry => 45 do
		@@faves ||= YAML.load_file('settings.yml')
		arrivals = Muni.new.arrivals(@@faves)
		arrivals.to_json
	end
end

get '/browse' do
	# cache 1 day
	cache 'routes', :expiry => 1 * DAY do
		@routes = Muni.new.routes
		haml :browse_routes
	end
end

get '/browse/:tag' do |tag|
	cache "route_#{tag}", :expiry => 1 * DAY do
		@route_info = Muni.new.route_info(tag)
		haml :browse_route_info
	end
end

set :cache_namespace, "muni"
set :cache_enable, true
