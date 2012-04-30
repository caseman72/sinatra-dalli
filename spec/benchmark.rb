require 'rubygems'
require 'dalli'
require 'zlib'
require 'benchmark'

CACHE = Dalli::Client.new 'localhost:11211', :namespace => 'bench'
def get key, flg
  value = CACHE.get(key, :raw => flg)
  value = CACHE[key, true]
  if flg
    Marshal.load(Zlib::Inflate.inflate(value))
  else
    value
  end
end

def get key, flg
  v = CACHE.get(key, :raw => true)
  return v unless v

  v = Zlib::Inflate.inflate(v) if flg
  Marshal.load(v)
end

def set key, value, flg
  v = Marshal.dump(value)
  v = Zlib::Deflate.deflate(v) if flg
  CACHE.set(key, v, 0, :raw => true)
  value
end


Benchmark.bm(17) do |x|
  x.report('no compress set:') do
    5000.times do |i|
      set(i.to_s, i, false)
    end
  end
  x.report('no compress get:') do
    5000.times do |i|
      get(i.to_s, false)
    end
  end

  x.report('compress set:') do
    5000.times do |i|
      set(i.to_s, i, true)
    end
  end
  x.report('compress get:') do
    5000.times do |i|
      get(i.to_s, true)
    end
  end
end
