class Pass < ActiveRecord::Base
  # belongs_to :address
  
  def set_pass_fields
    self.authentication_token = Base64.urlsafe_encode64(SecureRandom.base64(36))
    self.serial_number||= Base64.urlsafe_encode64(SecureRandom.base64(36))
  end

  # def self.update_or_create params
  #   pass_pass = find_by_card_id params[:card_id]
  #   pass_pass ||=new
  #   params.slice(*attr_accessible[:default].map(&:to_sym)).each do |attr, val|
  #     pass_pass.send :"#{attr}=", val
  #   end
  #   pass_pass.save!
  #   pass_pass
  # end

  def self.update_or_create(params)


    # address = Address.find(params[:address_id])
    
    # Check if we already created this pass
    # pass_pass = address.pass
    # return pass_pass if pass_pass.present?
    
    pass_pass ||=new
    
    pass_pass.set_pass_fields
    
    # params.slice(*attr_accessible[:default].map(&:to_sym)).each do |attr, val|
    #   pass_pass.send :"#{attr}=", val
    # end
   
    # pass_pass.send :"var=", var
    
    # Set address:
    # pass_pass.address =address
      
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
    @barcode = "http://google.com/" # Payment request for the users address
    
    pass_json['serialNumber'] = self.id.to_s
    
    pass_json['barcode'] = {
                              message: @barcode,
                              format: "PKBarcodeFormatPDF417",
                              messageEncoding: "iso-8859-1",
                              altText: "14DCzMesaa1xUCb87Dp3qC1oF7nwmS7LA5" # The address
    }                            
    
    # pass_json['associatedStoreIdentifiers'] =

    # pass_json['relevantDate'] = 

    # pass_json['locations'] = 
    
     pass_json['description'] = "Bitcoin Mobile Wallet address"
     pass_json['logoText'] = "Mobile Wallet"
     
     pass_json['eventTicket'] = { # TODO: change category
       headerFields: [
         
       ],
       primaryFields: [
         {
           key: "date",
           label: "DATE",
           dateStyle: "PKDateStyleMedium",
           timeStyle: "PKDateStyleNone",
           value: "1997-07-16T19:20+01:00" #I18n.l(Time.now.to_time, :format => :w3c)
         }
       ],
       secondaryFields: [
         {
           key: "address",
           label: "ADDRESS",
           value: "Somewhere st"
         }, 
       ], 
       auxiliaryFields: [
         {
             key: "test",
             label: "AUX",
             value: "test"
        }
      ],
      backFields: [
        {
          key: "test",
          label: "testback",
          value: "test back"
        },
        {
          key: "terms",
          label: "TERMS AND CONDITIONS",
          value: "Blah..."
        }
      ]
    }    
  end
  
  private
  def person_params
    params.permit(:authentication_token)
  end
end
