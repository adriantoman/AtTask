module Attask
  class Credentials
    attr_accessor :subdomain, :username, :password, :session, :sandbox

    def initialize(subdomain, username, password, options)
      @subdomain, @username, @password, @session = subdomain, username, password, nil
      @sandbox = options[:sandbox]
      @version = options[:version] || 'v3.0'
    end

    def valid?
      !subdomain.nil? && !username.nil? && !password.nil?
    end

    def host
      fail "Sandbox is not supported anymore." if @sandbox
      "https://#{subdomain}.my.workfront.com/attask/api/#{@version}"
    end

    def is_logged?
      !@session.nil?
    end
  end
end