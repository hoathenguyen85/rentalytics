# This is an idea of what 'bundle install' does
begin
  # try to load gem
  gem 'json'
#uh-oh!!! ERROR CATCHING, NO GEM FOUND!
rescue LoadError
  puts 'json gem is missing.  Let me install that gem for you.....'
  #installs gem through your console
  system('gem install json')
  Gem.clear_paths
end