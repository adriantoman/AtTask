$: << File.expand_path(File.dirname(__FILE__) + "/")

require "httparty"
require 'hashie'
require 'json'
require 'zlib'

require 'ext/array'
require 'ext/hash'

require 'attask/credentials'
require 'attask/error'

require 'attask/base'

%w(default).each {|a| require "attask/behavior/#{a}"}

%w(model project assigment baseline baselinetask category company expense expensetype group hour hourtype issue rate resourcepool risk risktype role schedule task team timesheet user milestone metadata portfolio program reservedtime).each {|a| require "attask/#{a}"}
%w(base project assigment baseline baselinetask category company expense expensetype group hour hourtype issue rate resourcepool risk risktype role schedule task team timesheet user milestone metadata portfolio program reservedtime).each {|a| require "attask/api/#{a}"}


module Attask

  class << self

    # Creates a standard client that will raise all errors it encounters
    #
    # == Examples
    # Attask.client('mysubdomain', 'myusername', 'mypassword')
    #
    # @return [Attask::Base]
    def client(subdomain, username, password, options = {})
      Attask::Base.new(subdomain, username, password, options)
    end


  end

end