module Reorder
  class Data < Grape::API

    resource :reorder_data do
      desc "List all Notifications"

      get do
        m = Magentwo.connect "https://mall2door.net/en", "junaid_hassan_101@hotmail.com", "abc123"
        # debugger
        CONSUMER_KEY = 'dz4xnhhgfsfuyj00g6bkel0jq6mwdak2'
        CONSUMER_SECRET = 'hhjnlf59qh2m7an9sdpfcu0o9nox78y6'
        TOKEN = 'ie5iafduhqs1dydynidsjki582oti17w'
        TOKEN_SECRET = 'mva5hldj17elic6muxmf53fq7zmm7xl5'


        BASE_URL = "https://mall2door.net/rest"

        service = MagentoRestApi::Connection.new({"consumer_key"=> CONSUMER_KEY,
                                                   "consumer_secret"=> CONSUMER_SECRET,
                                                   "token"=> TOKEN,
                                                   "token_secret"=> TOKEN_SECRET})
        debugger
        # uri = URI('https://mall2door.net/rest/V1/carts/mine')
        # consumer = OAuth::Consumer.new(keys['consumer_key'], keys['consumer_secret'], { :site => uri.host, :scheme => :header })
        # token_hash = { :oauth_token => keys['token'], :oauth_token_secret => keys['token_secret'] }
        # access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
        # return access_token
        # response =  service.connect('GET', 'https://mall2door.net/rest/V1/products?searchCriteria[pageSize]=20')
        response =  service.connect('POST', 'https://mall2door.net/rest/V1/products?searchCriteria[pageSize]=20')
        response =  service.connect('POST', 'https://mall2door.net/rest/V1/carts/mine')
        puts "-----------------------------"
        puts item = JSON.parse(response.body)
        # Magento2::Api.configure('dz4xnhhgfsfuyj00g6bkel0jq6mwdak2', 'hhjnlf59qh2m7an9sdpfcu0o9nox78y6', 'ie5iafduhqs1dydynidsjki582oti17w', 'mva5hldj17elic6muxmf53fq7zmm7xl5', "https://mall2door.net")
        # orders = Magento2::Api.post("/rest/en/V1/carts/mine", {searchCriteria: 'all'})
        # WSDL_URL = "https://mall2door.net/soap/?services=customerCustomerRepositoryV1&wsdl"
        # USER_NAME = "junaid@mall2door.net"
        # API_KEY = "mall2door"
        # WSDL_URL = "https://johnstowngardencentre.ie/api/V2_soap/?wsdl"
        # client = Savon.client(wsdl: WSDL_URL)
        # debugger
        # response  = client.call(:shopping_cart_create, message: {sessionId: 'iksdc9i6t06jlb0bm3pvqxam5x63wblm', storeId: '1'})
        # if response
        #  response.body
        # end
        # response  = client.call(:login, message: {username: USER_NAME, apiKey: API_KEY})
        # if response
        #   @session = response.body[:login_response][:login_return]
        # end

      end

    end

  end
end