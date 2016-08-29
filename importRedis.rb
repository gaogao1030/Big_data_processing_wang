require "./model/f2"
require "./model/f1"
require "pry"

puts "clean redis start"
F1.delete_all if F1.count > 0
F2.delete_all if F2.count > 0
puts "clean redis done"
puts "---------------------------"
puts "inport_redis_from_csv start"
F1.import_redis_from_csv
puts "inport_redis_from_csv done"
puts "---------------------------"
puts "set_cropss_types start"
F1.set_cross_types
puts "set_cropss_types done"
puts "---------------------------"
puts "calculate start"
F1.calculate
puts "calculate done"
