module Attask
  module API
    class Expense < Base

      api_model Attask::Expense

      include Attask::Behavior::Default


    end
  end
end