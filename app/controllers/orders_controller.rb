class OrdersController < ApplicationController 
  load_and_authorize_resource
  skip_before_filter :verify_authenticity_token, :only => [:ipn]
  
  def ipn
    # Security depends on nobody knowing the shared secret. It might be safer to 
    # call back Coinbase and double check the info.
    
    # Test locally like so:
    
    # curl -X POST -d '{    "order": {        "id": "5RTQNACF",        "created_at": "2012-12-09T21:23:41-08:00",        "status": "completed",        "total_btc": {            "cents": 100000000,            "currency_iso": "BTC"        },        "total_native": {            "cents": 1253,            "currency_iso": "USD"        },        "custom": "A35",        "button": {            "type": "buy_now",            "name": "Alpaca Socks",            "description": "The ultimate in lightweight footwear",            "id": "5d37a3b61914d6d0ad15b5135d80c19f"        },        "transaction": {            "id": "514f18b7a5ea3d630a00000f",            "hash": "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b",            "confirmations": 0        }    }}' http://localhost:3000/orders/ipn?password=secret -H "Content-Type: application/json"
    
    if params[:password]==ENV['COINBASE_SHARED_SECRET']
      order_id = params[:order][:id]
      status = params[:order][:status]
      custom = params[:order][:custom]
      
      if order_id.present? && status.present? && custom.present?
      
        address_id = custom.scan(/\d+/).first
      
        @address = Address.find(address_id)
        @address.update paid: status == "completed", order_id: order_id 
      
        render :nothing => true
      else
        logger.error "Order, status or custom field empty"
        render :nothing => true, :status => 422
      end
    else
      render :nothing => true, :status => 444
    end
  end
end