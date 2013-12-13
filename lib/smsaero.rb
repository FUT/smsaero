require 'net/http'

class SMSAero
  URL = 'http://gate.smsaero.ru/%{action}'

  def initialize(*args)
    options = args.extract_options!

    raise 'User and password should be provided!' unless options[:user] && options[:password]

    @user = options[:user]
    @password_hash = Digest::MD5.digest options[:password]
  end

  def method_missing(action, *args, &block)
    options = args.extract_options!
    options.reverse_merge! answer: :json

    uri = URI(URL % { action: action })
    uri.query = URI.encode_www_form options

    Net::HTTP.post_form uri, user: @user, password: @password_hash
  end
end