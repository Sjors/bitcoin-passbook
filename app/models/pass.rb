class Pass < ActiveRecord::Base
  belongs_to :address
  has_many :registrations, :class_name => "Passbook::Registration", :foreign_key => "serial_number", :primary_key => 'serial_number'
  
  def set_pass_fields
    self.authentication_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
    self.serial_number||= Base64.urlsafe_encode64(SecureRandom.base64(36))
  end

  def self.find_or_create(params)
    address = Address.find(params[:address_id])
        
    # Check if we already created this pass
    pass_pass = address.pass
    return pass_pass if pass_pass.present?
    
    pass_pass ||=new
    
    pass_pass.set_pass_fields
    
    # params.slice(*attr_accessible[:default].map(&:to_sym)).each do |attr, val|
    #   pass_pass.send :"#{attr}=", val
    # end
   
    # pass_pass.send :"var=", var
    
    # Set address:
    pass_pass.address =address
      
    
    # pass_pass.files = [File.read(File.open("tmp/logo.png" ,"rb"))]
    
    pass_pass.save!
    pass_pass
  end
  
  def check_for_updates
    # iPhone is asking for an updated pass. Fetch the most recent balance and last transaction from Blockchain.
  end

  def update_pass pkpass
    update_json pkpass.json
    # update_files pkpass.files
  end

  # Not  needed:
  # def update_files pass_files
  # 
  #   pass_files["logo@2x.png"] = logo
  #   pass_files["icon@2x.png"] = logo
  #   pass_files["background@2x.png"] = background
  #   pass_files["thumbnail@2x.png"] = background
  #   
  # end

  def update_json pass_json    
    if ENV["RAILS_ENV"]=="production"
      pass_json['webServiceURL'] = "https://bitcoin-passbook.herokuapp.com/"
    else
      pass_json['webServiceURL'] = "http://sjors.local:3000/"
    end
    
    pass_json['serialNumber'] = self.serial_number
    pass_json['authenticationToken'] = self.authentication_token
    
    
    pass_json['barcode'] = {
                              message: "bitcoin:" + self.address.base58,
                              format: "PKBarcodeFormatQR",
                              messageEncoding: "iso-8859-1",
                              altText: "receive bitcoins"
    }                            
    
    # pass_json['associatedStoreIdentifiers'] =

    # pass_json['relevantDate'] = 

    # pass_json['locations'] = 
    
     pass_json['description'] = "Bitcoin #{ self.address.name } address"
     pass_json['logoText'] = self.address.name
     
     pass_json['storeCard'] = { 
       headerFields: [
         key: "balance",
         label: "Balance",
         value: "฿" + self.address.balance.to_s
       ],
       primaryFields: [
         {
           key: "field",
           label: "",
           value: "" 
         }
       ],
      backFields: [
        {
            key: "address",
            label: "Bitcoin address",
            value: self.address.base58
       },
         {
             key: "blockchain",
             label: "Full transaction history",
             value: "https://blockchain.info/address/" + self.address.base58
        },
        {
          key: "credits",
          label: "Credits",
          value: "Bitcoin logo from https://en.bitcoin.it/wiki\nCoin image from https://www.casascius.com/\nGet more passes from http://bitcoin-passbook.com/"
        }
        # {
        #   key: "terms",
        #   label: "TERMS AND CONDITIONS",
        #   value: "Blah..."
        # }
      ]
    }    
    
    if self.address.transactions.count == 0
      pass_json['storeCard']["secondaryFields"] = [
        {
            key: "last_transaction",
            label: "Last transaction",
            value: "No transactions found"
        }]
    else
      sent_or_received = self.address.transactions.last.amount < 0 ? "Spent" : "Received"
      amount = self.address.transactions.last.amount.abs
      date = self.address.transactions.last.date
      pass_json['storeCard']["secondaryFields"] = [
        {
            key: "last_transaction",
            label: "Last transaction",
            value: sent_or_received + " ฿" + amount.to_s,
            changeMessage: "%@"
        },  {
            key: "last_transaction_date",
            label: "Date",
             dateStyle: "PKDateStyleShort",
             timeStyle: "PKDateStyleShort",
            value: I18n.l(date.to_time, :format => :w3c)
        }
        # {
     #      key: "date",
     #      label: self.sight.app.identifier == "AMS" ? "DATE" : "DATUM",
     #      dateStyle: "PKDateStyleMedium",
     #      timeStyle: "PKDateStyleNone",
     #      value: I18n.l(self.valid_on.to_time, :format => :w3c)
     #    }
      ]
    end
  end
  
  private
  def pass_params
    params.permit(:authentication_token)
  end
end
