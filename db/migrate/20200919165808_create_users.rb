class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :confirmation_token
      t.boolean :is_admin

      t.timestamps
    end
  end
end
