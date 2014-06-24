#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$: << File::dirname(__FILE__) + "/lib"

require 'Application'

begin
  app = Application.new(ARGV)

  elements = app.grep
  
  puts "Нашёл #{elements.count} элементов:"
  
  puts elements.map {|e| "Путь XPath: \"#{e.path}\"\nПуть CSS: \"#{e.css_path}\"\nКодировка: #{e.text.encoding}\nЗначение: \"#{e}\"\n\n"}

rescue Application::InsufficientArguments
  puts "Usage: #{__FILE__} <string to find> <url to fetch>"
rescue Exception => e
  puts "Exception: #{e.class}: #{e}"
end
