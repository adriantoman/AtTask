module Attask


  # The model that contains information about a project
  #
  # == Fields
  # [+name+] (REQUIRED) the name of the project

  class Risk < Hashie::Mash
    include Attask::Model

    api_path '/risk'

  end

end