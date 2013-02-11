module Attask
  class Credentials
    attr_accessor :subdomain, :username, :password, :session, :sandbox

    def initialize(subdomain, username, password, options)
      @subdomain, @username, @password, @session = subdomain, username, password, nil
      @sandbox = options[:sandbox]
    end

    def valid?
      !subdomain.nil? && !username.nil? && !password.nil?
    end

    def host
      if (@sandbox != nil) then
        "https://#{subdomain}.attasksandbox.com/attask/api"
      else
        "https://#{subdomain}.attask-ondemand.com/attask/api"
      end
    end

    def is_loged?
      return true if @session != nil
    end


  end
end