require 'optparse'
require 'net/http'
require 'nokogiri'

class Application
  class InsufficientArguments < Exception
    attr_reader :usage
    def initialize(usage)
      @usage = usage
    end
  end

  private

  class Selector
    def regex node_set, regex
      node_set.find_all { |node| node.text =~ /#{regex}/ }
    end
  end
  
  def process_command_line(argv)
    
    @opts = OptionParser.new
    @opts.banner = "Usage: rxgrep [options] <string to find> <url to fetch>"
    @opts.on("-i", "--case-insensitive", "Process input case insensitively") {|val| @cfg[:case_insensitive] = true }
    @opts.on("-E ENC", "--encoding ENC", String, "Assume content encoding")   {|val| @cfg[:encoding] = val }
    
    @opts_rest = @opts.parse(argv)
    raise Application::InsufficientArguments.new(@opts.to_s) unless @opts_rest.count >= 2

    @cfg[:string] = @cfg[:case_insensitive] ? @opts_rest[0].upcase : @opts_rest[0]
    @cfg[:url]    = URI.parse(@opts_rest[1])
  end

  
  public
  attr_reader :result  

  def initialize(argv)
    @selector = Application::Selector.new
    @cfg = Hash.new
    @cfg[:case_insensitive] = false
    process_command_line(argv)
  end

  
  def grep(url = @cfg[:url])
    
    response = Net::HTTP.get_response(@cfg[:url])

    # TODO: workaround for response.body.upcase (Net::HTTP doesn't parse Content-Type,
    #       and assumes ASCII-8BIT encoding for response body)
    xml = Nokogiri::XML(@cfg[:case_insensitive] ? response.body.upcase : response.body)
    
    xml.encoding = @cfg[:encoding] if @cfg[:encoding]
    
    @result = xml.xpath("//*[regex(text(), '#{@cfg[:string]}')]", @selector)
  
  end # grep()

end # Application
