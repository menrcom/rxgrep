#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$: << File::dirname(__FILE__) + "/lib"

require 'net/http'
require 'nokogiri'

exit 1 unless ARGV.count == 2

string   = ARGV[0]
filename = ARGV[1]
uri = URI.parse(filename)

response = Net::HTTP.get_response(uri)

xml = Nokogiri::XML(response.body)
xml.encoding = 'UTF-8'
elements = xml.xpath("//*[contains(text(), '#{string}')]")

puts "Нашёл #{elements.count} элементов:"

puts elements.map {|e| "Путь XPath:#{e.path}\nпуть CSS:#{e.css_path}\nКодировка:#{e.text.encoding}\nЗначение:#{e}\n\n"}
