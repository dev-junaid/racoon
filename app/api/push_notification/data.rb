module PushNotification
  class Data < Grape::API

    resource :push_notification_data do
      desc "List all Notifications"

      get do
        customer = Customer.where(email: params[:customer_id])
        if customer.present?
          Notification.where(user_id: customer.first.customer_id)
        end
      end

    end

  end
end