require 'net/https'
require 'net/http'

module Singal
  class Picasa
    attr_accessor :auth_key
    attr_accessor :user_id

    def login(email, password)
      url = "https://www.google.com/accounts/ClientLogin"
      source = "TestCompany-Singal-0.0.1"

      uri = URI.parse(url)

      request = Net::HTTP.new(uri.host, uri.port)
      request.use_ssl = true
      request.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response, data = request.post(uri.path, "accountType=HOSTED_OR_GOOGLE&Email=#{email}&Passwd=#{password}&service=lh2&source=#{source}")

      authMatch = Regexp.compile("(Auth=)([A-Za-z0-9_\-]+)\n").match(data.to_s)
      if authMatch
        authorizationKey = authMatch[2].to_s
      end

      self.auth_key = authorizationKey
      self.user_id = email

      return authorizationKey
    end
  end
end