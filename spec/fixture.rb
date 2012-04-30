
get '/' do
  "Hello World"
end

get '/cache' do
  cache "cache" do
    "Hello World"
  end
end

get '/cache2' do
  cache "cache2", :expiry => 1 do
    "Hello World"
  end
end

get '/read' do
  cache 'cache'
end

get '/compress' do
  cache "compress", :compress => true do
    "Hello Compress"
  end
end

get '/object' do
  hash = cache "object" do
    { :a => 'hello a', :b => 'hello b' }
  end
  hash[:a] + ' ' + hash[:b]
end

get '/expire' do
  expire "cache"
end

get '/drop' do
end

get '/expire_all' do
  expire "cache"
  expire "cache2"
  expire "compress"
end

configure do
  set :cache_namespace, "test"
  set :cache_logging, false
end
