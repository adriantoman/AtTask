module Attask
  module API
    class BillingRecord < Base

      api_model Attask::BillingRecord

      include Attask::Behavior::Default


      def add_hours(object,hours_collection)
        billing_record_id = object["ID"]
        response = request(:put, credentials, "/bill/#{billing_record_id}/", :query => {
                                    :updates => {
                                        :hours => hours_collection
                                    },
                                    :fields => "hours"
                            }




        )
        response
      end


    end
  end
end