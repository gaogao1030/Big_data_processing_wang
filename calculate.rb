require "./cross.rb"

cross_types = CrossRecord.cross_types
cross_types.each do |ct|
  crs = CrossRecord.get_cross_records(ct)
  result = CrossRecord.calculate_result(crs)
  puts "#{ct}:#{result}"
end

