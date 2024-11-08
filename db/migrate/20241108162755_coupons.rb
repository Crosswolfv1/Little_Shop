class Coupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :description
      t.integer :dollar_off
      t.integer :percent_off

      t.timestamps
    end
  end
end
