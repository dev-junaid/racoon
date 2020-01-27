class AddArNotificationToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :ar_notification, :text
  end
end
