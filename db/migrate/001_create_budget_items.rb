class CreateBudgetItems < ActiveRecord::Migration
  def self.up
    create_table :budget_items, :force => true do |t|
      t.integer :position, :null => false, :default => 0
      t.string  :category
      t.string  :description
      t.string  :requester
      t.integer :quant_bacich, :null => false, :default => 0
      t.integer :quant_kent, :null => false, :default => 0
      t.integer :quant_district, :null => false, :default => 0
      t.integer :unit_cost, :null => false, :default => 0
      t.boolean :recurs_annually, :null => false, :default => false
      t.string  :special_funding
      t.timestamps
    end
    
    BudgetItem.import
  end

  def self.down
    drop_table :budget_items
  end
end
