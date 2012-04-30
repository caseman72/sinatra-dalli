require 'rubygems'
require 'sinatra'
require 'rack/test'

require File.dirname(__FILE__) + '/../lib/sinatra/dalli'
require File.dirname(__FILE__) + '/fixture'

include Rack::Test::Methods
def app
  Sinatra::Application
end

describe 'Sinatra-Dalli' do
  before do
    @client = Dalli::Client.new 'localhost:11211', :namespace => "test"
  end

  it "/index" do
    get '/'
    last_response.ok?.should be_true
    last_response.body.should == "Hello World"
  end

  it "/cache" do
    get '/cache'
    last_response.ok?.should be_true
    last_response.body.should == "Hello World"
  end

  it "/cache - marshal" do
    get '/cache'
    Marshal.load(@client.get('cache', true)).should == "Hello World"
  end

  it "/cache, /read" do
    get '/cache'
    get '/read'
    last_response.ok?.should be_true
    last_response.body.should == "Hello World"
  end

  it "/cache, /expire - nil" do
    get '/cache'
    get '/expire'
    @client.get('cache').should be_nil
  end

  it "/cache2 - nil" do
    get '/cache2'
    sleep(1)
    @client.get('cache2').should be_nil
  end

  it "/compress" do
    get '/compress'
    last_response.ok?.should be_true
    last_response.body.should == "Hello Compress"
    @client.get('compress', true).should == Zlib::Deflate.deflate(Marshal.dump('Hello Compress'))
  end

  it "/object" do
    get '/object'
    last_response.ok?.should be_true
    last_response.body.should == "hello a hello b"
    Marshal.load(@client.get('object', true)).should == { :a => 'hello a', :b => 'hello b' }
  end

  it "/cache, /cache2, /compress, /expire_all - nil " do
    get '/cache'
    get '/cache2'
    get '/compress'
    get '/expire_all'
    @client.get('cache').should be_nil
    @client.get('cache2').should be_nil
    @client.get('compress').should be_nil
  end
end
