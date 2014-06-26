require 'net/http'

class SMSAero
  URL = 'https://gate.smsaero.ru/%{action}'

  def initialize(*args)
    options = args.extract_options!

    raise 'User and password should be provided!' unless options[:user] && options[:password]

    @user = options[:user]
    @password_hash = Digest::MD5.hexdigest(options[:password])
  end

  def send_message(options={})
    process_request :send, options
  end

  def method_missing(action, *args, &block)
    process_request(action, *args, &block)
  end

  def process_request(action, *args, &block)
    options = args.extract_options!
    options.reverse_merge! answer: :json

    uri = URI(URL % { action: action })
    uri.query = URI.encode_www_form options

    result = Net::HTTP.post_form uri, user: @user, password: @password_hash
    JSON.parse(result.body)
  end
end
