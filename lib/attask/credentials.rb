module Attask
  class Credentials
    attr_accessor :subdomain, :username, :password, :session, :sandbox

    def initialize(subdomain, username, password, options)
      @subdomain, @username, @password, @session = subdomain, username, password, nil
      @sandbox = options[:sandbox]
      @version = options[:version] || "v3.0"
    end

    def valid?
      !subdomain.nil? && !username.nil? && !password.nil?
    end

    def host
      if (@sandbox) then
        "https://#{subdomain}.attasksandbox.com/attask/api/#{@version}"
      else
        "https://#{subdomain}.attask-ondemand.com/attask/api/#{@version}"
      end
    end

    def is_loged?
      return true if @session != nil
    end


  end
end
