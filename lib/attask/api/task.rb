module Attask
  module API
    class Task < Base

      api_model Attask::Task

      include Attask::Behavior::Default


      def getAllFields
        response = request(:get, credentials, api_model.api_path + "/metadata")
        json = response.parsed_response["data"]
        fields = Array.new
        json["fields"].each_key do |key|
          fields.push(key)
        end

        # For some reasons api is not returning this values
        fields.delete("auditUserIDs")
        fields.delete("auditNote")
        fields.join(',')
      end


    end
  end
end