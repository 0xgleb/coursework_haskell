require 'excon' # library for HTTP
require 'json'  # library for JSON

# function for querying /check
def post_check(excon, body)
  excon.request(
    method: :post,
    path: '/check',
    headers: { 'Content-Type' => 'application/json' },
    body: body
  )
end

# function for querying /evaluate
def post_evaluate(excon, body)
  excon.request(
    method: :post,
    path: '/evaluate',
    headers: { 'Content-Type' => 'application/json' },
    body: body
  )
end

# expression input
print 'Expression: '
expr = JSON.generate gets.chomp # .chomp removes carriage return characters (like \n)

# action input
print 'Action (Check or Evaluate): '
action = gets.chomp

# creating an instance of excon with base url http://localhost:3000
excon = Excon.new('http://localhost:3000')

case action # identifying the action
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
