class BudgetItem < ActiveRecord::Base
  acts_as_list :order => :position
  has_many :votes
  
  def quant_total
    quant_bacich + quant_kent + quant_district
  end
  
  def total_cost
    quant_total * unit_cost
  end
  
  def special?
    !special_funding.blank?
  end
  
  def rank_for_user(user)
    return nil if user.nil?
    user = user.id if user.respond_to?(:remember_me)
    v = votes.find(:first, :conditions => ['user_id=?', user])
    v.nil? ? nil : v.rank
  end
  
  def vote_count
    n = votes.count
    n > 0 ? n : nil
  end
  
  def average_rank
    return nil unless vote_count
    sprintf("%0.*f", 1, votes.average(:rank))
  end
  
  class << self    
    def import
      fname = File.join(RAILS_ROOT, 'db/budget_items.csv')
      position = 0
      FasterCSV.foreach(fname, :headers => true, :header_converters => :symbol) do |row|
        h = row.to_hash
        create(:position   => position,
          :category        => h[:category],
          :description     => h[:description],
          :requester       => h[:requester],
          :quant_bacich    => (h[:bacich] || 0).to_i,
          :quant_kent      => (h[:kent] || 0).to_i,
          :quant_district  => (h[:district] || 0).to_i,
          :unit_cost       => (h[:unit_cost] || 0).to_i,
          :recurs_annually => (h[:recurs_annually] || 'No')[0, 1].downcase == 'y',
          :special_funding => h[:special_funding])
        position += 1
      end
    end
  end
end
