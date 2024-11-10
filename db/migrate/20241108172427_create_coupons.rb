class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :description
      t.integer :percent_off
      t.integer :dollar_off
      t.string :status
      t.string :code
      
      t.timestamps
    end
  end
end