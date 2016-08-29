require 'redis'
require 'redis_orm'
require "smarter_csv"
require "progress_bar"
require "json"

class F2 < RedisOrm::Base
  property :sum_of_average_pa_and_pb, Float
  property :sum_of_average_heterosis, Float
  property :count, Integer
  property :cross_type, String

  def self.delete_all
    bar = ProgressBar.new(self.count)
    self.all.each do |record|
      record.destroy
      bar.increment!
    end
  end

end
