if Rails.env != "test"
  Passbook::Config.instance.add_pkpass do |passbook|
    passbook.pass_config["pass.com.bitcoin-passbook.address"]={
                                "cert_path"=>"config/pass-address.p12",
                                "cert_password"=> ENV["PASS_ADDRESS"],
                                "template_path"=>"data/templates/pass.com.bitcoin-passbook.address",
                                "class"=>"Pass"
                              }
  end
end