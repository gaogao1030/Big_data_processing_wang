require "importex"
require "pry"
class CrossRecord < Importex::Base
  column "cross"
  column "parent_A"
  column "parent_B"
  column "model_id"
  column "biomass_production_rate"
  column "degree_of_heterosis"
  column "parent_A_biomass"
  column "parent_B_biomass"
  column "hybrid_type"
  column "n_bottlenecks"


  def self.cross_types
    cross_types = CrossRecord.all.map{|c|c["cross"]}.uniq
  end

  def self.get_cross_records(cross_type)
    CrossRecord.all.select{|c|c["cross"] == cross_type}
  end

  def self.calculate_result(cross_records)
    average_of_heterisis = CrossRecord.calculate_average_of_heterosis(cross_records)
    sum_of_average_pa_and_pb = CrossRecord.calculate_sum_of_average_pa_and_pb(cross_records)
    return {
      average_of_heterisis: average_of_heterisis,
      sum_of_average_pa_and_pb: sum_of_average_pa_and_pb,
      item_count: cross_records.count
    }
  end

  private

  def self.calculate_sum_of_average_pa_and_pb(cross_records)
    sum = 0.00000000
    cross_records.each do |cr|
      sum += ((cr["parent_A_biomass"].to_f + cr["parent_B_biomass"].to_f)/2)
    end
    return sum/cross_records.count
  end

  def self.calculate_average_of_heterosis(cross_records)
    sum = 0.00000000
    cross_records.each do |cr|
      sum += cr["degree_of_heterosis"].to_f
    end
    return sum/cross_records.count
  end


end

CrossRecord.import("./f1.xls")
