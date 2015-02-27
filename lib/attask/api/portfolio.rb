module Attask
  module API
    class Portfolio < Base

      api_model Attask::Portfolio

      include Attask::Behavior::Default

    end
  end
end