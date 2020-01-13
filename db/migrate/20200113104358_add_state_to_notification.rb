class AddStateToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :state, :string
  end
end
