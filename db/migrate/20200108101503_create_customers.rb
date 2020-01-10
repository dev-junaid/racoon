class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.bigint :customer_id
      t.string :device_id
      t.string :device_type

      t.timestamps
    end
  end
end
