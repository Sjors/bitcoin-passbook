class Pass < ActiveRecord::Base
  belongs_to :address
  
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
       secondaryFields: [
         {
             key: "last_transaction",
             label: "Last transaction",
             value: "Spent ฿0.01 on May 19th, 18:42"
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
  end
  
  private
  def person_params
    params.permit(:authentication_token)
  end
end
