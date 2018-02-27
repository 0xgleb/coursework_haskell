input_file_name = 'random_numbers_test'
output_file_name = 'ruby_result_test'

buffer = ''
numbers = []

File.open(input_file_name) do |f|
  f.each_char do |c|
    if c == ','
      numbers << Integer(buffer)
      buffer = ''
    else
      buffer << c
    end
  end
end

numbers << Integer(buffer)

numbers = numbers.sort

File.open(output_file_name, 'w') do |f|
  last = numbers.pop
  numbers.each { |num| f.write "#{num}," }
  f.write last
end
