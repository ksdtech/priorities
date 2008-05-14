class WeightedItem
  attr_accessor :item, :weighted_rank, :bucket
  
  def initialize(item, report)
    @item = item
    @weighted_rank = item.weighted_rank(report)
    if @weighted_rank == 0
      @bucket = :base
    elsif @weighted_rank < report.cutoff_high
      @bucket = :high
    elsif @weighted_rank < report.cutoff_medium
      @bucket = :medium
    elsif @weighted_rank != 10 
      @bucket = :low
    else
      @bucket = :other
    end
  end
end


class Report < ActiveRecord::Base
  attr_accessor :weighted_items
  
  def sort_weighted_items
    @weighted_items = BudgetItem.find(:all).collect do |i| 
      WeightedItem.new(i, self) 
    end.sort do |w1, w2| 
      diff = w1.weighted_rank <=> w2.weighted_rank
      diff = w1.item.id <=> w2.item.id if diff == 0
      diff
    end
  end
    
  def method_missing(method, *args)
    ms = method.to_s
    if ms =~ /^items_([a-z]+)$/
      bucket = $1.to_sym
      @weighted_items.select { |weighted| weighted.bucket == bucket }
    elsif ms =~ /^subtotal_([a-z]+)$/
      bucket = $1.to_sym
      @weighted_items.inject(0) do |t, weighted| 
        t += weighted.item.total_cost if weighted.bucket == bucket 
        t
      end
    else
      super
    end
  end
  
end
