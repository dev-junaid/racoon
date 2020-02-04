class CustomerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  #def perform
  #  Magento2::Api.configure('dz4xnhhgfsfuyj00g6bkel0jq6mwdak2', 'hhjnlf59qh2m7an9sdpfcu0o9nox78y6', 'ie5iafduhqs1dydynidsjki582oti17w', 'mva5hldj17elic6muxmf53fq7zmm7xl5', "https://mall2door.net")
  #  setup_customer
  #end
  def perform
    Magento2::Api.configure('dz4xnhhgfsfuyj00g6bkel0jq6mwdak2', 'hhjnlf59qh2m7an9sdpfcu0o9nox78y6', 'ie5iafduhqs1dydynidsjki582oti17w', 'mva5hldj17elic6muxmf53fq7zmm7xl5', "https://mall2door.net")
    orders = Magento2::Api.get("/rest/en/V1/orders", {searchCriteria: 'all'})
    all_orders = orders[:items]
    all_orders.each do |order|
      order_id =  order[:increment_id]
      store = order[:store_id]
      if store === 1 && order_id > "000000047" && order_id != "7000000001"
        n_perform order,order_id, store
      elsif store === 6 && order_id > "6000000075" && order_id != "7000000001"
        n_perform order,order_id, store
      end

    end
  end
  def n_perform order, order_id, store
    email = order[:customer_email]
    puts "-------------------------"
    puts order.inspect
    puts "=============================="
    order_e = Order.where(order_id: order_id)
    if order_e.present? && order[:state].present?
      unless order_e.first.state === order[:state]
        update_customer(email, order, order_e, store)
      end
    else
      setup_customer(email, order, order_e, store)
    end
  end
  def setup_notification state, order_id, customer_id, device_id, device_type, store
    title = 'Order Notification'
    a_title = 'طلب الإخطار'
    n_text = ''
    a_text = ''
    if state === 'new'
      n_text = "Order ##{order_id} has been placed successfully!"
      a_text = "تم وضع الطلب ##{order_id} بنجاح!"
    end
    if state === 'pending'
      n_text = "Order ##{order_id} has been processed!"
      a_text = "تمت معالجة الطلب ##{order_id}!"
    end

    if state === 'canceled'
      n_text = "Order ##{order_id} has been cancelled!"
      a_text = "تم إلغاء الطلب ##{order_id}!"
    end

    if state === 'processing'
      n_text = "Order ##{order_id} has been processed!"
      a_text = "تمت معالجة الطلب ##{order_id}!"
    end
    if state === 'complete'
      n_text = "Order ##{order_id} has been shipped!"
      a_text = "تم شحن الطلب ##{order_id}!"
    end
    if state === 'closed'
      n_text = "Order ##{order_id} has been delivered!"
      a_text = "تم تسليم الطلب ##{order_id}!"
    end
    notification = Notification.where(user_id: customer_id, order_id: order_id, state: state)
    unless notification.present?
      Notification.create(user_id: customer_id, order_id: order_id, notification: n_text, ar_notification: a_text, title: title,  status: false, state: state).save
      send_notification title,a_title, n_text, a_text, device_id, device_type, store
    end

  end
  def send_notification title, ar_title, body, ar_body, device_id, device_type, store
    #device_id = device_id
    #device_type = device_type
    fcm = FCM.new("AAAART0-JpY:APA91bGXH8mhK2yStnuFxWZNvNrUrIrXWrojXim976wuHZWmnB6z04UQ_VY8LiGKaDIRHy9tX_LEyJcfjzyfouI6TiJM8CAqHybyoFqaeX1NHPUaGbm1SRGvNb6K8hdlMuK_T2WuikF0")
    registration_ids = [device_id] # an array of one or more client registration tokens
    if device_type === 'android'
      options = { "data": {
          "title": title,
          "body": body,
          "ar_title": ar_title,
          "ar_body": ar_body
      }
      }
      response = fcm.send(registration_ids, options)
      puts response
    end
    if device_type === 'ios'
      if store === 1
        options = { "notification": {
            "title": title,
            "body": body,
        }
        }
      end
      if store === 6
        options = { "notification": {
            "title": ar_title,
            "body": ar_body

        }
        }
      end

      response = fcm.send(registration_ids, options)
      puts response
    end
  end
  def setup_customer email, order, order_e, store
    #def setup_customer
    customer = Magento2::Api.get("/rest/V1/customers/search", {'searchCriteria[filter_groups][0][filters][0][field]': 'email', 'searchCriteria[filter_groups][0][filters][0][value]': email, 'searchCriteria[filter_groups][0][filters][0][condition_type]': 'like'})
    #customer = Magento2::Api.get("/rest/V1/customers/search", {'searchCriteria[filter_groups][0][filters][0][field]': 'email', 'searchCriteria[filter_groups][0][filters][0][value]': 'maiwandsultan@gmail.com', 'searchCriteria[filter_groups][0][filters][0][condition_type]': 'like'})
    customer = customer[:items].first
    if customer.present?
      first_name = customer[:firstname]
      last_name = customer[:lastname]
      #email = customer[:email]
      phone = customer[:addresses].first[:telephone]
      customer_id = customer[:addresses].first[:customer_id]

      #puts customer[:items].present?
      if customer[:custom_attributes].present?
        attributes  = customer[:custom_attributes]
        device_id = ''
        device_type = ''
        #if attributes.present?
        device_index = attributes.find_index{ |item| item[:attribute_code] === "device_id"}
        if attributes[device_index]
          device_id = attributes[device_index][:value]
        end
        device_index = attributes.find_index{ |item| item[:attribute_code] === "device_type"}
        if attributes[device_index]
          device_type = attributes[device_index][:value]
        end
        #end

        if device_id.present? && device_type.present?
          customer_e = Customer.where(email: email)
          if customer_e.present?
            Customer.update(device_id: device_id, device_type: device_type)
          else
            Customer.create(first_name: first_name,last_name: last_name, email: email, phone: phone , customer_id: customer_id, device_id: device_id, device_type: device_type).save
          end
          order_id =  order[:increment_id]
          if order[:state].present?
            state = order[:state]
            phone = ''
            Order.create(order_id: order_id, state: state, customer_emails: email, customer_phone: phone).save
            setup_notification(state, order_id, customer_id, device_id, device_type, store )
          end
        end
      end
    end
  end
  def update_customer email, order,order_e, store
    customer = Magento2::Api.get("/rest/V1/customers/search", {'searchCriteria[filter_groups][0][filters][0][field]': 'email', 'searchCriteria[filter_groups][0][filters][0][value]': email, 'searchCriteria[filter_groups][0][filters][0][condition_type]': 'like'})
    #customer = Magento2::Api.get("/rest/V1/customers/search", {'searchCriteria[filter_groups][0][filters][0][field]': 'email', 'searchCriteria[filter_groups][0][filters][0][value]': 'maiwandsultan@gmail.com', 'searchCriteria[filter_groups][0][filters][0][condition_type]': 'like'})
    customer = customer[:items].first
    if customer.present?
      if customer[:custom_attributes].present?
        attributes  = customer[:custom_attributes]
        device_id = ''
        device_type = ''
        #Customer.update(customer_id: customer_id)
        #if attributes.present?
        device_index = attributes.find_index{ |item| item[:attribute_code] === "device_id"}
        if attributes[device_index]
          device_id = attributes[device_index][:value]
        end
        device_index = attributes.find_index{ |item| item[:attribute_code] === "device_type"}
        if attributes[device_index]
          device_type = attributes[device_index][:value]
        end
        #end

        if device_id.present? && device_type.present?
          customer_id = customer[:addresses].first[:customer_id]
          customer_e = Customer.where(email: email)
          if customer_e.present?
            Customer.update(device_id: device_id, device_type: device_type, customer_id: customer_id)
            if order[:state].present?
              state = order[:state]
              order_id =  order[:increment_id]
              order_e.update(state: state)
              setup_notification(state, order_id, customer_id, customer_e.first.device_id, customer_e.first.device_type, store )
            end
          end

        end
      end
    end
  end
end