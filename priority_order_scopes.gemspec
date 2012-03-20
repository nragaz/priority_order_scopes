Gem::Specification.new do |s|
  s.name = "priority_order_scopes"
  s.summary = "Flip through Active Record models in order using next and previous scopes and instance methods."
  s.description = "Flip through Active Record models in order using next and previous scopes and instance methods."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.version = "0.0.2"
  s.authors = ["Nick Ragaz"]
  s.email = "nick.ragaz@gmail.com"
  s.homepage = "http://github.com/nragaz/priority_order_scopes"

  s.add_dependency 'rails', '~> 3'
  s.add_development_dependency 'sqlite3'
end
