class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.text    :notes
      t.float   :cutoff_high
      t.float   :cutoff_medium
      t.integer :discount_cost
      t.float   :discount_points
      t.timestamps
    end
    
    Report.create(:notes => 'Your notes here',
      :cutoff_high     => 1.5, 
      :cutoff_medium   => 2.5,
      :discount_cost   => 1000,
      :discount_points => 0.3)
  end

  def self.down
    drop_table :reports
  end
end
