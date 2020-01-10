module PushNotification
  class Data < Grape::API

    resource :push_notification_data do
      desc "List all Notifications"

      get do
        Notification.where(user_id: params[:customer_id])
      end

    end

  end
end