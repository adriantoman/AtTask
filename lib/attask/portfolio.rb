module Attask


  # The model that contains information about a project
  #
  # == Fields
  # [+name+] (REQUIRED) the name of the project

  class Portfolio < Hashie::Mash
    include Attask::Model

    api_path '/portfolio'


  end

end