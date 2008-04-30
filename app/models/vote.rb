class Vote < ActiveRecord::Base
  belongs_to :budget_item
  belongs_to :user
  
  validates_inclusion_of :rank, :in => 1..3
end
