module Reorder
  class Data < Grape::API

    resource :reorder_data do
      desc "List all Notifications"

      get do
        # m = Magentwo.connect "https://mall2door.net/en", "junaid_hassan_101@hotmail.com", "abc123"
        # debugger
        CONSUMER_KEY = 'dz4xnhhgfsfuyj00g6bkel0jq6mwdak2'
        CONSUMER_SECRET = 'hhjnlf59qh2m7an9sdpfcu0o9nox78y6'
        TOKEN = 'ie5iafduhqs1dydynidsjki582oti17w'
        TOKEN_SECRET = 'mva5hldj17elic6muxmf53fq7zmm7xl5'


        # BASE_URL = "https://mall2door.net/rest"

        service = MagentoRestApi::Connection.new({"consumer_key"=> CONSUMER_KEY,
                                                  "consumer_secret"=> CONSUMER_SECRET,
                                                  "token"=> TOKEN,
                                                  "token_secret"=> TOKEN_SECRET})
        # rest/V1/orders/1
        rsp = {message: "Something Went Wrong!", orderId: nil}
        if params[:order_id].present?
          response =  service.connect('GET', "https://mall2door.net/rest/V1/orders/#{ params[:order_id]}")

          if response.kind_of? Net::HTTPSuccess
            previous_order = JSON.parse(response.body)

            firstname = previous_order["billing_address"]["firstname"]
            city = previous_order["billing_address"]["city"]
            country_id = previous_order["billing_address"]["country_id"]
            lastname = previous_order["billing_address"]["lastname"]
            postcode = previous_order["billing_address"]["postcode"]
            region = previous_order["billing_address"]["region"]
            region_code = previous_order["billing_address"]["region_code"]
            region_id = previous_order["billing_address"]["region_id"]
            street = previous_order["billing_address"]["street"].first
            telephone = previous_order["billing_address"]["telephone"]
            payment_method = previous_order["payment"]["method"]
            shipping_method  = previous_order["extension_attributes"]["shipping_assignments"].first["shipping"]["method"]
            shipping_carrier_code =  shipping_method.split("_")[0]
            shipping_method_code = shipping_method.split("_")[1]
            email = previous_order["customer_email"]

            items  = previous_order["items"]
            if items.present?
              # STEP 1
              response =  service.connect('POST', 'https://mall2door.net/rest/V1/guest-carts/')
              user_id = JSON.parse(response.body)
              puts "-----------------------------"

              #STEP 2
              response =  service.connect('GET', "https://mall2door.net/rest/V1/guest-carts/#{user_id}")
              puts cart = JSON.parse(response.body)
              puts cart_id = cart["id"]
              puts "-----------------------------"

              items.each do |item|
                item_id =  item["item_id"]
                qty =  item["qty_ordered"]
                sku =  item["sku"]
                # STEP 3
                item = {
                    "cartItem" => {
                        "sku" => "#{sku}",
                        "qty" => qty,
                        "quote_id" => "#{user_id}"
                    }
                }
                response =  service.connect('POST', "https://mall2door.net/rest/V1/guest-carts/#{cart_id}/items", item)
                puts cart = JSON.parse(response.body)
              end
              # STEP 4
              shipping_info = {
                  "addressInformation" => {
                      "shipping_address" => {
                          "region" => region,
                          "region_id" => region_id,
                          "region_code" => region_code,
                          "country_id" => country_id,
                          "street" => [
                              street
                          ],
                          "postcode" => postcode,
                          "city" => city,
                          "firstname" => firstname,
                          "lastname" => lastname,
                          "email" => email,
                          "telephone" => telephone
                      },
                      "billing_address" => {
                          "region" => region,
                          "region_id" => region_id,
                          "region_code" => region_code,
                          "country_id" => country_id,
                          "street" => [
                              street
                          ],
                          "postcode" => postcode,
                          "city" => city,
                          "firstname" => firstname,
                          "lastname" => lastname,
                          "email" => email,
                          "telephone" => telephone
                      },
                      "shipping_carrier_code" => shipping_carrier_code,
                      "shipping_method_code" => shipping_method_code
                  }
              }
              response =  service.connect('POST', "https://mall2door.net/rest/V1/guest-carts/#{user_id}/shipping-information", shipping_info)
              # debugger
              puts shipping = JSON.parse(response.body)

              # STEP 6
              order_params = {
                  "paymentMethod" => {
                      "method" => "#{payment_method}"
                  }
              }
              response =  service.connect('PUT', "https://mall2door.net/rest/V1/guest-carts/#{user_id}/order", order_params)
              debugger
              puts order_details = JSON.parse(response.body)

              if response.kind_of? Net::HTTPSuccess
                rsp[:message] = "Order has been places successfully!"
                rsp[:orderId] = order_details
              else
                rsp[:message] = order_details["message"]
              end

            end
          end
        end
        rsp
      end

    end

  end
end