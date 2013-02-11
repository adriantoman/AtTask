module Attask
  module API
    class Project < Base

      api_model Attask::Project

      include Attask::Behavior::Default


    end
  end
end