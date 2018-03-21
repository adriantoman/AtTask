class ArrayStorage
  def initialize
    @array = []
  end

  def concat(objects)
    @array += objects
  end

  def close
  end

  def value
    @array
  end

  def count
    @array.count
  end
end

class CsvStorage

  def initialize(filepath,filename,fields)
    @ordered_fields = fields
    @csv = CSV.open("#{filepath}#{filename}", "w",{:col_sep => ",",:quote_char => '"'})
    @csv << fields
    @counter = 0
  end


  def concat(objects)

    objects.each do |object|
      temp = Array.new
      @ordered_fields.each do |o|
        # Remove special characters:
        if (object[o].instance_of? String)
          value = object[o].delete("\n").delete('"')
          temp.push(value)
        elsif (object[o].instance_of? Hashie::Array)
          temp.push(object[o].first)
        else
          temp.push(object[o])
        end
        @counter += 1
      end
      @csv << temp
    end
  end

  def count
    @counter
  end

  def close
    @csv.close
  end

  def value
    nil
  end

end
