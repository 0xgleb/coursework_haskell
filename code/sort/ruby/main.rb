input_file_name = 'random_numbers'
output_file_name = 'ruby_result'

buffer = ''
numbers = []

# open the input file
File.open(input_file_name) do |f|
  # for each character c in the file
  f.each_char do |c|
    if c == ','
      # convert the buffer to an integer and add to the list of numbers
      numbers << Integer(buffer)
      # empty the buffer
      buffer = ''
    else
      # add the character to the buffer
      buffer << c
    end
  end

  # convert the buffer to an integer and add to the list of numbers
  numbers << Integer(buffer)
end

# sort the numbers
numbers = numbers.sort

# open the output file
File.open(output_file_name, 'w') do |f|
  # remove the last number from the list
  last = numbers.pop
  # write all the remaining numbers separated by commas to the file
  numbers.each { |num| f.write "#{num}," }
  # write the last element
  f.write last
end
