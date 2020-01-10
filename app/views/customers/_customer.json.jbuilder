json.extract! customer, :id, :first_name, :last_name, :email, :phone, :customer_id, :device_id, :device_type, :created_at, :updated_at
json.url customer_url(customer, format: :json)
