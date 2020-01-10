class API < Grape::API
  prefix 'api'
  version 'v1', using: :path
  mount PushNotification::Data
end