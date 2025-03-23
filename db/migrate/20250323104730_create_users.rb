class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :name
      t.string :role, default: 'user'

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
