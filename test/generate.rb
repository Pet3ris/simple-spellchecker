#!/usr/bin/ruby

require 'set' 

begin
  words = IO.read("/usr/share/dict/words").split("\n")
  n = words.length
  vowels = ['a', 'e', 'i', 'o', 'u']
  vowel_set = vowels.to_set
  1000.times do
    w = rand n
    word = words[w]
    for i in 0...word.length
      case rand(4)
        when 0
          print word[i,1].upcase
        when 1
          if vowel_set.include? word[i,1]
            print vowels[rand(5)]
          else
            print word[i,1]
          end
        when 2
          (rand(10) + 1).times { print word[i,1] }
        when 3
          print word[i,1]
        end
    end
    puts
  end
rescue Exception => e
  puts "/usr/share/dict/words seems to be missing...are you on UNIX?"
end
