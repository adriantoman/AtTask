module Attask
  module API
    class Timesheet < Base

      api_model Attask::Timesheet

      include Attask::Behavior::Default


    end
  end
end