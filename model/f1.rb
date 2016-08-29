require 'redis'
require 'redis_orm'
require "smarter_csv"
require "progress_bar"
require "json"

$redis = Redis.new(host: "localhost", port: 6379)

class F1 < RedisOrm::Base
  property :cross, String
  property :parent_A, String
  property :parent_B, String
  property :model_id, String
  property :biomass_production_rate, Float
  property :degree_of_heterosis, Float
  property :parent_A_biomass, Float
  property :parent_B_biomass, Float
  property :hybrid_type, String
  property :n_bottlenecks, String

  index :cross

  def self.calculate
    bar = ProgressBar.new(self.count)
    self.get_cross_types.each do |type|
      records = self.all(condition: {cross: type})
      sum_of_pa_and_pb = 0.00000000
      sum_of_heterosis = 0.00000000
      records.each do |record|
        sum_of_pa_and_pb += record.parent_A_biomass + record.parent_B_biomass/2
        sum_of_heterosis += record.degree_of_heterosis
        bar.increment!
      end
      F2.create(cross_type: type,
                sum_of_average_pa_and_pb: sum_of_pa_and_pb/records.count,
                sum_of_average_heterosis: sum_of_heterosis/records.count,
                count: records.count)
    end
  end


  def self.get_cross_types
    cross_types = $redis.get("self:cross_types")
    JSON.parse(cross_types)
  end

  def self.set_cross_types
    array = self.all.map{|f| f.cross}.uniq
    $redis.set("self:cross_types",array.to_json)
  end

  def self.import_redis_from_csv
    csv_records = SmarterCSV.process("./data/sample.csv")
    puts "csv_records loaded"
    bar = ProgressBar.new(csv_records.count)
    csv_records.each do |record|
      self.create(cross: record[:cross],
                parent_A: record[:parent_a],
                parent_B: record[:parent_b],
                model_id: record[:model_id],
                biomass_production_rate: record[:biomass_production_rate],
                degree_of_heterosis: record[:degree_of_heterosis],
                parent_A_biomass: record[:parent_a_biomass],
                parent_B_biomass: record[:parent_b_biomass],
                hybrid_type: record[:hybrid_type],
                n_bottlenecks: record[:n_bottlenecks])
      bar.increment!
    end
  end

  def self.delete_all
    bar = ProgressBar.new(self.count)
    self.all.each do |record|
      record.destroy
      bar.increment!
    end
  end

end
