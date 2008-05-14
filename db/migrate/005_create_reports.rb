class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string  :name
      t.text    :notes
      t.float   :cutoff_high
      t.float   :cutoff_medium
      t.integer :discount_cost
      t.float   :discount_points
      t.timestamps
    end
    
    Report.create(:notes => 'Your notes here',
      :name            => 'weighted',
      :cutoff_high     => 1.6, 
      :cutoff_medium   => 2.4,
      :discount_cost   => 1000,
      :discount_points => 0.3)
    Report.create(:notes => 'Unweighted',
      :name            => 'unweighted',
      :cutoff_high     => 1.6, 
      :cutoff_medium   => 2.4,
      :discount_cost   => 0,
      :discount_points => 0)
  end

  def self.down
    drop_table :reports
  end
end
