module Attask


  # The model that contains information about a billing record
  #
  # == Fields
  # [+name+] (REQUIRED) the name of the billing record

  class BillingRecord < Hashie::Mash
    include Attask::Model

    api_path '/billingrecord'


  end

end