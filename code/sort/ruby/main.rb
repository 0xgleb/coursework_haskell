file_name = "random_numbers_test"

buffer = ""
numbers = []

File.open(file_name) do |f| 
  f.each_char do |c| 
    if c == ',' then
      numbers << Integer(buffer)
      buffer = ""
    else
      buffer << c
    end
  end
end
