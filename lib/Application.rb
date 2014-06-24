require 'net/http'
require 'nokogiri'

class Application
  class InsufficientArguments < Exception
  end

  private

  def process_command_line(argv)
    raise Application::InsufficientArguments.new() unless argv.count >= 2
    @string   = argv[0]
    @url = URI.parse(argv[1])
  end

  public
  attr_accessor :string
  attr_reader :url
  attr_reader :result

  def initialize(argv)
    process_command_line(argv)
  end

  def grep(url = self.url)
    response = Net::HTTP.get_response(@url)

    xml = Nokogiri::XML(response.body)
    xml.encoding = 'UTF-8'
    @result = xml.xpath("//*[contains(text(), '#{string}')]")
  end

end
