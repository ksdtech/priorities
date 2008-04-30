class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :first_name
      t.string :last_name
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
      t.column :state, :string, :null => :no, :default => 'passive'
      t.column :deleted_at, :datetime
    end
    
    # User.create_active_user(:first_name => 'Peter', :last_name => 'Zingg',
    #  :login => 'pzingg', :password => 'mypass', :email => 'pzingg@example.com')
  end

  def self.down
    drop_table "users"
  end
end
