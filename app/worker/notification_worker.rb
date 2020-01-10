require 'fcm'
class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    #fcm = FCM.new("AIzaSyD_EL7eAnWGRkfPRrGiBZovZqO1Y4pbaYs")
    fcm = FCM.new("AAAART0-JpY:APA91bGXH8mhK2yStnuFxWZNvNrUrIrXWrojXim976wuHZWmnB6z04UQ_VY8LiGKaDIRHy9tX_LEyJcfjzyfouI6TiJM8CAqHybyoFqaeX1NHPUaGbm1SRGvNb6K8hdlMuK_T2WuikF0")
    registration_ids= ["f7JfI8W7Mpg:APA91bH6hIoJIljtab48g5BE4kaZx33EitUjW02P1nJCDtjFqBsy1LtmhyZsFD3k-c1AHyvYzDES6yiyFQr6uzzxVun_vCOE0FNRO72aK9XPDPWYuzfK1dpSkI8pDDhcvLeq588z4jl2"] # an array of one or more client registration tokens
    options = { "data": {
        "title": "Portugal vs. Denmark",
        "body": "5 to 1"
    }
    }
    response = fcm.send(registration_ids, options)
  end
end