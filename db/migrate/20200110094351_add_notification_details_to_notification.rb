class AddNotificationDetailsToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :user_id, :bigint
    add_column :notifications, :notification, :text
    add_column :notifications, :status, :boolean
    add_column :notifications, :order_id, :bigint
  end
end
