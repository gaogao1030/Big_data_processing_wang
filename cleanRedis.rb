require "./model/f2"
require "./model/f1"
require "pry"

puts "start"
F1.delete_all if F1.count > 0
F2.delete_all if F2.count > 0
puts "done"
