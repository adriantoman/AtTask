module Attask


  # The model that contains information about a project
  #
  # == Fields
  # [+name+] (REQUIRED) the name of the project

  class Category < Hashie::Mash
    include Attask::Model

    api_path '/category'


  end

end