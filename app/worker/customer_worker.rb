class CustomerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    Magento2::Api.configure('dz4xnhhgfsfuyj00g6bkel0jq6mwdak2', 'hhjnlf59qh2m7an9sdpfcu0o9nox78y6', 'ie5iafduhqs1dydynidsjki582oti17w', 'mva5hldj17elic6muxmf53fq7zmm7xl5', "https://mall2door.net")
    customers = Magento2::Api.get("/rest/en/V1/customers")

    #Magentwo.connect "https://mall2door.net", "fadal", "Fadal19*"
    #customers = Magentwo::Customer.all
    #if customers.present?
    #  customers.each do |customer|
        #lastname = customer.lastname. present? ? customer.lastname : ''
        #Customer.new(first_name: customer.firstname, last_name: customer.lastname, email: customer.email, customer_id: customer.id).save
      #end
    #end
  end
end