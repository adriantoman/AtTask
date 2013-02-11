module Attask
  module API
    class Issue < Base

      api_model Attask::Issue

      include Attask::Behavior::Default


    end
  end
end