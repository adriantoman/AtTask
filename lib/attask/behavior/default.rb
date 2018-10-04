module Attask
  module Behavior
    module Default
      LIMIT = 200

      def metadata
        @metadata ||= request(:get, credentials, api_model.api_path + "/metadata")
      end

      # Retrieves all items
      # @return [Array<Attask::Model>] an array of models depending on where you're calling it from (e.g. [Attask::Client] from Attask::Base#clients)
      def search(options = {}, query_options = {}, storage_object = nil)
        # Load setting from setting file
        settings(options[:settings]) if options[:settings] != nil

        # Load the fields which need to be downloaded from attask
        fields = getSettingsFields || options[:fields] || getAllFields
        # Load custom fields which need to be downloaded from attask
        customFields = getSettingsCustomFields || options[:customFields] || getCustomFields

        # Adding possibility to not download any field or custom field  (by specifying empty string )
        fields = [fields != "" ? fields : nil, customFields != "" ? customFields : nil].compact.join(",")
        fields = sortFields(fields)

        query = {:fields => fields}.merge(query_options)

        first = 0
        limit = 2000
        query = query.merge('$$FIRST' => first, '$$LIMIT' => limit)
        ended = false
        objects = storage_object || ArrayStorage.new
        objects_count = 0

        primary_keys = {}

        until ended
          response = request(:get, credentials, api_model.api_path + '/search', :query => query)
          downloaded = api_model.parse(response.parsed_response["data"])
          if downloaded&.any?
            first += downloaded.size
            query = query.merge("$$FIRST" => first)
          else
            ended = true
          end
          downloaded.each do |object|
            next unless options[:uniq_by_pk]
            pk = options[:uniq_by_pk].to_sym
            next unless object.respond_to?(pk)
            actual_pk = object.send(pk)
            if primary_keys.key?(actual_pk)
              # Sometimes the API returns duplicates, we decided to fail if that happens to be able to detect that easily
              raise StandardError, "Object with ID #{actual_pk} is a duplicate returned from the API. Aborting."
            else
              primary_keys[actual_pk] = nil
            end
          end
          objects.concat(downloaded)
          objects_count += downloaded.size
        end
        puts "Downloaded #{objects_count} records for entity #{self.class.name}"
        objects.close
        objects.value
      end

      # Creates an item
      # @param [Attask::Model] object the item you want to create
      # @return [Attask::Model] created object Hash returned from the API
      def add(object, options = {})
        response = request(:post, credentials, api_model.api_path, :body => object)
        api_model.parse(response.parsed_response["data"])
      end

      #TODO refactor occurrences and remove
      def add_old(object, options = {})
        response = request(:post, credentials, api_model.api_path, :query => object)
        api_model.parse(response.parsed_response["data"])
      end

      def update(object, options = {})
        response = request(:put, credentials, api_model.api_path, :body => object)
        api_model.parse(response.parsed_response['data'])
      end

      #TODO refactor occurrences and remove
      def update_old(object, options = {})
        response = request(:put, credentials, api_model.api_path, :query => object)
        api_model.parse(response.parsed_response["data"])
      end

      def exec_function(object, function, options = {})
        response = request(:put, credentials, api_model.api_path + "/#{object.ID}", :query => {:action => function})
      end

      # Create CSV export for Attask::Model object
      # Same options setting as search
      # @param [HASH] options for specifying export folder, filename and search options
      def exportToCsv(options = {}, query_options = {})
        gzip = options[:gzip] || false

        settings(options[:settings]) if options[:settings] != nil

        fields = options[:fields] || getSettingsFields != nil ? getSettingsFields : nil || getAllFields
        customFields = options[:customFields] || getSettingsCustomFields != nil ? getSettingsCustomFields : nil || getCustomFields

        fields = [fields != "" ? fields : nil, customFields != "" ? customFields : nil].compact.join(",")
        fields = sortFields(fields)

        filename = options[:filename]
        filepath = options[:filepath]

        ordered_fields = fields.split(",")
        storage_object = CsvStorage.new(filepath, filename, ordered_fields)
        search(options, query_options, storage_object)

        if gzip
          Zlib::GzipWriter.open("#{filepath}#{filename}".gsub(".csv", ".gz")) do |gz|
            gz.write File.read("#{filepath}#{filename}")
          end
        end
      end

      private

      def settings(file)
        @settings ||= File.open(file, "r") { |f| JSON.load(f) }
      end

      def getSettingsCustomFields
        return nil if @settings.nil?
        entity = @settings["entity"].find_all { |e| e.keys.first == self.class.to_s.split("::")[2].downcase }
        temp = entity.first.values.first.find { |e| e[0] == "customFields" }
        temp[1]
      end

      def getSettingsFields
        return nil if @settings == nil
        entity = @settings["entity"].find_all { |e| e.keys.first == self.class.to_s.split("::")[2].downcase }
        temp = entity.first.values.first.find { |e| e[0] == "fields" }
        temp[1]
      end

      def sortFields(fields)
        temp = fields.split(",").sort { |a, b| a.downcase <=> b.downcase }
        temp.join(",")
      end

      def getAllFields
        json = metadata.parsed_response["data"]
        fields = Array.new
        json["fields"].each_pair do |key, value|
          next if value['flags'] && value['flags'].include?('WRITE_ONLY')
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