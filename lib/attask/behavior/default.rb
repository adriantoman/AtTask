module Attask
  module Behavior
    module Default


      LIMIT = 200


      def metadata
        @metadata ||= request(:get, credentials, api_model.api_path + "/metadata")
      end

      # Retrieves all items
      # @return [Array<Attask::Model>] an array of models depending on where you're calling it from (e.g. [Attask::Client] from Attask::Base#clients)
      def search(options = {},query_options = {})

        # Load setting from setting file
        settings(options[:settings]) if options[:settings] != nil

        # Load the fields which need to be downloaded from attask
        fields =  getSettingsFields || options[:fields] || getAllFields
        #Load custom fields which need to be downloaded from attask
        customFields = getSettingsCustomFields || options[:customFields] || getCustomFields

        #Adding possibility to not download any field or custom field  (by specifying empty string )
        fields = [fields != "" ? fields : nil,customFields != "" ? customFields : nil].compact.join(",")
        fields = sortFields(fields)

        query = { :fields => fields }.merge(query_options)

        first = 0
        query = query.merge({"$$FIRST" => first, "$$LIMIT" => LIMIT})
        ended = false
        objects = Array.new


        while (!ended) do
          response = request(:get, credentials, api_model.api_path + "/search", :query => query)
          downloaded =  api_model.parse(response.parsed_response["data"])
          #puts "Setting is first = #{first} and LIMIT = #{LIMIT} and we have downloaded #{objects.count}"
          if (downloaded.count == LIMIT)
            first = first + LIMIT
            query = query.merge({"$$FIRST" => first, "$$LIMIT" => LIMIT})
          else
            ended = true
          end
          objects.concat(downloaded)
        end
        objects
      end



      # Creates an item
      # @param [Attask::Model] model the item you want to create
      # @return [Attask::Model] the created model depending on where you're calling it from (e.g. Harvest::Client from Harvest::Base#clients)
      def add(object,options = {})
        response = request(:post, credentials, api_model.api_path, :query => object)
        api_model.parse(response.parsed_response["data"])
      end


      def update(object,options = {})
        response = request(:put, credentials, api_model.api_path, :query => object)
        api_model.parse(response.parsed_response["data"])
      end

      def exec_function(object,function,options = {})
        response = request(:put, credentials, api_model.api_path + "/#{object.ID}", :query => {:action => function})
      end



      # Create CSV export for Attask::Model object
      # Same options setting as search
      # @param [HASH] options for specifying export folder, filename and search options
      def exportToCsv(options = {})

        gzip = options[:gzip] || false

        settings(options[:settings]) if options[:settings] != nil
        fields =  options[:fields] || getSettingsFields != nil ? getSettingsFields : nil || getAllFields
        customFields = options[:customFields] || getSettingsCustomFields != nil ? getSettingsCustomFields : nil || getCustomFields

        fields = [fields != "" ? fields : nil,customFields != "" ? customFields : nil].compact.join(",")
        fields = sortFields(fields)

        objects = search(options)
        filename = options[:filename]
        filepath = options[:filepath]
        warn "There are no data in specified entity" if objects.empty?

        ordered_fields = fields.split(",")

        FasterCSV.open("#{filepath}#{filename}", "w",{:col_sep => ";",:quote_char => '"'}) do |csv|
          csv << ordered_fields
          objects.each do |object|
            temp = Array.new
            ordered_fields.each do |o|
              temp.push(object[o])
            end
            csv << temp
          end
        end

        if (gzip)
          Zlib::GzipWriter.open("#{filepath}#{filename}".gsub(".csv",".gz")) do |gz|
            gz.write File.read("#{filepath}#{filename}")
          end
        end


      end

      private

      def settings(file)
        @settings ||=   File.open(file,"r") {|f| JSON.load(f)}
      end

      def getSettingsCustomFields
        return nil if @settings == nil
        entity = @settings["entity"].find_all {|e| e.keys.first == self.class.to_s.split("::")[2].downcase}
        temp = entity.first.values.first.find{|e| e[0] == "customFields"}
        temp[1]
      end

      def getSettingsFields
        return nil if @settings == nil
        entity = @settings["entity"].find_all {|e| e.keys.first == self.class.to_s.split("::")[2].downcase}
        temp = entity.first.values.first.find{|e| e[0] == "fields"}
        temp[1]
      end

      def sortFields(fields)
        temp = fields.split(",").sort{|a,b| a.downcase <=> b.downcase}
        temp.join(",")
      end


      def getAllFields
        json = metadata.parsed_response["data"]
        fields = Array.new
        json["fields"].each_key do |key|
          fields.push(key)
        end
        fields.join(',')
      end


      def getCustomFields
        json = metadata.parsed_response["data"]
        fields = Array.new
        if json["custom"] != nil then
          json["custom"].each_key do |key|
            fields.push("DE:#{key}")
          end
          fields.join(',')
        end

      end



    end
  end
end