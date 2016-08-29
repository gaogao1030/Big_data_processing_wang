require "pry"
require './model/f2'
require './model/f1'
require "csv_shaper"
require "to_csv"

ToCSV.byte_order_marker = true
ToCSV.timestamps        = true
ToCSV.locale            = 'en-US'
ToCSV.primary_key       = false
ToCSV.csv_options[:col_sep] = ','
ToCSV.csv_options[:row_sep] = "\r\n"

csv = [["type","count","sum_of_average_pa_and_pb","sum_of_average_heterosis"]]

F2.all.each do |f|
  csv.push([f.cross_type,f.count,f.sum_of_average_pa_and_pb,f.sum_of_average_heterosis])
end

File.open("result.csv",'w'){|io| io.puts csv.to_csv}
