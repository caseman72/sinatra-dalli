Gem::Specification.new do |s|
  s.name = "sinatra-dalli"
  s.version = "0.1.0"
  s.date = "2011-04-30"
  s.description = "Cache extension on Sinatra"
  s.summary = "Cache extension on Sinatra"

  s.authors = ["Casey Manion"]
  s.email = "casey@manion.com"
  s.homepage = "https://github.com/caseman72/sinatra-dalli"

  s.files = %w[
    Rakefile
    README.textile
    lib/sinatra/dalli.rb
    spec/sinatra-dalli_spec.rb
    spec/fixture.rb
  ]

  s.require_paths = ["lib"]
  s.add_dependency "sinatra"
  s.add_dependency "dalli"

  s.has_rdoc = true
  s.rubygems_version = '1.3.7'
end
