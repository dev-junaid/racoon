class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :order_id
      t.string :state
      t.string :customer_emails
      t.string :customer_phone

      t.timestamps
    end
  end
end
