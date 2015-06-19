module Attask
  module API
    class BillingRecord < Base

      api_model Attask::BillingRecord

      include Attask::Behavior::Default


      def add_hours(object,hours_collection)
        billing_record_id = object["ID"]
        update = {
            "hours" => hours_collection.map{|id| {"ID" => id}}
        }
        response = request(:put, credentials, "/bill/#{billing_record_id}", :query => {
                                    :updates => update,
                                    :fields => "hours"
                            }




        )
        response
      end


    end
  end
end