class AddTitleToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :title, :text
  end
end
