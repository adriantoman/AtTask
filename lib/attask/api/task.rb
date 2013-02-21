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
        fields.delete("predecessorExpression")
        fields.join(',')
      end

      def metadata
        output = @metadata ||= request(:get, credentials, api_model.api_path + "/metadata")
        output["data"]["fields"].delete("predecessorExpression")
        output["data"]["fields"].delete("auditNote")
        output["data"]["fields"].delete("auditUserIDs")
        output
      end

    end
  end
end