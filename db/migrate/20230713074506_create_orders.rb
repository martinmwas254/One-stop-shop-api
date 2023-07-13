class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, null: false
      t.decimal :total_price
      t.string :status
      t.text :shipping_address
      t.string :payment_method

      t.timestamps
    end
  end
end