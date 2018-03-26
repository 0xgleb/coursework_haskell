require 'excon' # library for HTTP
require 'json'  # library for JSON

require './api.rb'

print 'Expression: '
expr = JSON.generate gets.chomp
print 'Action (Check or Evaluate): '
action = gets.chomp

# create new instance of Excon
excon = Excon.new('http://localhost:3000')

case action
when 'Check'
  res = post_check(excon, expr)
  print 'Error: ' if res.status != 200
  puts res.body
when 'Evaluate'
  res = post_evaluate(excon, expr)
  print 'Error: ' if res.status != 200
  puts res.body
else
  puts 'Invalid action!'
end
