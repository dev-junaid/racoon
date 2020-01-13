require 'fcm'
class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    fcm = FCM.new("AAAART0-JpY:APA91bGXH8mhK2yStnuFxWZNvNrUrIrXWrojXim976wuHZWmnB6z04UQ_VY8LiGKaDIRHy9tX_LEyJcfjzyfouI6TiJM8CAqHybyoFqaeX1NHPUaGbm1SRGvNb6K8hdlMuK_T2WuikF0")
    registration_ids= ["ccO44EcITEU:APA91bEv-mEfllPOX4bc0fDoom9igtEV_O1S53K5maKjXbLUqoU3SF8Qn5RqOBYKBSzcS3RMqFFMPAOLsfo60zax2OD_U79jl4pImhDaliTbCrQOfXcUXMYNRTCfNE0DeuJ3m3jnjm3m"] # an array of one or more client registration tokens
    order_id = "#6000000065"
    Notification.create(user_id: 2305, notification: "Order #{order_id} has been placed successfully!", status: true)
    #Notification.create(user_id: 2305, notification: "Order #{order_id} has been moved to processing!", status: true)
    #Notification.create(user_id: 2305, notification: "Order #{order_id} has been moved to shipped!", status: true)
    #Notification.create(user_id: 2305, notification: "Order #{order_id} has been moved to delivered!", status: true)

    options = { "data": {
        "title": "Order Notification",
        "body": "Order #{order_id} has been placed successfully!"
    }
    }
    #options = { "data": {
    #    "title": "Order Notification",
    #    "body": "Order #{order_id} has been moved to processing!"
    #}
    #}
    #options = { "data": {
    #    "title": "Order Notification",
    #    "body": "Order #{order_id} has been shipped successfully!"
    #}
    #}
    #options = { "data": {
    #    "title": "Order Notification",
    #    "body": "Order #{order_id} has been shipped delivered!"
    #}
    #}
    response = fcm.send(registration_ids, options)
  end
end
