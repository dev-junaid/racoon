class OrderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  #def perform
  #  Magento2::Api.configure('dz4xnhhgfsfuyj00g6bkel0jq6mwdak2', 'hhjnlf59qh2m7an9sdpfcu0o9nox78y6', 'ie5iafduhqs1dydynidsjki582oti17w', 'mva5hldj17elic6muxmf53fq7zmm7xl5', "https://mall2door.net")
  #  setup_customer
  #end
  def perform
    Magento2::Api.configure('dz4xnhhgfsfuyj00g6bkel0jq6mwdak2', 'hhjnlf59qh2m7an9sdpfcu0o9nox78y6', 'ie5iafduhqs1dydynidsjki582oti17w', 'mva5hldj17elic6muxmf53fq7zmm7xl5', "https://mall2door.net")
    orders = Magento2::Api.get("/rest/en/V1/orders", {searchCriteria: 'all' })
    all_orders = orders[:items]
    all_orders.each do |order|
      unless order[:status].present?
        order_id =  order[:increment_id]
        id = order[:entity_id]
        status = order[:state]
        params = {
            entity_id: id,
            increment_id: order_id,
            status: status,
        }
        if status
          Magento2::Api.put("/rest/en/V1/orders/create", {entity: params})
        end
     end
    end
  end
end