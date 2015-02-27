module Attask
  module API
    class Program < Base

      api_model Attask::Program

      include Attask::Behavior::Default

    end
  end
end