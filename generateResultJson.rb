require "pry"
require './model/f2'
require './model/f1'


puts "generating..."
data = []
F2.all.each do |f|
  data.push({
  type: f.cross_type,
  count: f.count,
  sum_of_average_heterosis: f.sum_of_average_heterosis,
  sum_of_average_pa_and_pb: f.sum_of_average_pa_and_pb})
end

open("result.json",'a') do |file|
  file.puts data.to_json
end

puts "generate done"
