class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'

    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.string :telephone
      t.string :address
      t.timestamps
    end

    add_index :users, [:username], :unique => true
  end
end
