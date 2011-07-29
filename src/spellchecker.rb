#!/usr/bin/ruby

# Ruby 1.9
require_relative 'spellchecking'

# Ruby 1.8
#require 'absolute/path/to/spellchecking'

filename = "/usr/share/dict/words";
if ARGV.size > 0
  filename = ARGV[0]
  puts filename
else
  puts "no filename specified...trying /usr/share/dict/words"
end

begin
  puts "...loading dictionary"
  sp = Spellchecking::Spellchecker.new(IO.read(filename).split("\n").map{|w|w.downcase.strip})
  puts "done"
  while true
    print "> "
    s = STDIN.gets
    puts sp.suggest(s.strip)
  end
rescue Exception => e
  puts "error. please check the provided word list."
end
