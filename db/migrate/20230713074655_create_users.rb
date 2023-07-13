class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest # Add password digest column
      t.string :email
      t.boolean :admin, default: false # Add admin column with default value

      t.timestamps
    end
  end
end