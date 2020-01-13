json.extract! order, :id, :order_id, :state, :customer_emails, :customer_phone, :created_at, :updated_at
json.url order_url(order, format: :json)
