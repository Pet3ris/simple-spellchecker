module Spellchecking
  require 'set'

  class Spellchecker
    @@VOWEL_DAMAGE      = 1
    @@REPETITION_DAMAGE = 1
    
    def initialize(words)
      @words  = words
      @trie   = SpellingTrie.new
      (0...words.length).each{|i| @trie.add(@words[i], i)}
    end

    # Suggest word
    def suggest(input)
      input = input.downcase

      # remove triplicates
      normalized = input[0, 2]
      for i in 2...input.length
        normalized << input[i] if input[i] != input[i - 1] or input[i - 1] != input[i - 2]
      end

      # memorize duplicates
      duplicates = Set.new
      for i in 1...normalized.length
        duplicates.add(i - 1) if normalized[i] == normalized[i - 1]
      end 

      best = -1
      suggestion = "NO SUGGESTION"

      examine = lambda do |i, so_far, repetitions|
        if i >= normalized.length
          matches = @trie.get_matches(so_far)
          if not matches.empty?
            matches.each do |w|
              vowel_mismatches = 0
              for i in 0...@words[w].length
                vowel_mismatches += 1 if @words[w][i] != so_far[i]
              end
              score = vowel_mismatches * @@VOWEL_DAMAGE + repetitions * @@REPETITION_DAMAGE;
              if best == -1 or score < best
                best = score
                suggestion = @words[w]
              end
            end
          end
        else
          if duplicates.include? i
            examine.call(i + 2, so_far + normalized[i], repetitions + 1)
          end
          examine.call(i + 1, so_far << normalized[i], repetitions)
        end
      end

      examine.call(0, "", 0)

      suggestion
    end

    class SpellingTrie
      attr_reader   :kids
      attr_accessor :words_here

      @@vowels = Set.new ['a', 'e', 'i', 'o', 'u']

      def initialize()
        @kids       = Hash.new
        @words_here = Set.new
      end

      # Add word to the trie
      def add(word, w)
        if word != "" 
          cur = self
          word.downcase.each_char do |character|
            modified_char = @@vowels.include?(character) ? '*' : character
            cur.kids[modified_char] = SpellingTrie.new if not cur.kids.has_key? modified_char
            cur = cur.kids[modified_char]
          end
          cur.words_here.add(w)
        end
      end

      # Get all possible matches for this word
      def get_matches(word)
        cur = self
        word.each_char do |character|
          modified_char = @@vowels.include?(character) ? '*' : character
          return Set.new if not cur.kids.has_key? modified_char
          cur = cur.kids[modified_char]
        end
        cur.words_here
      end
    end
  end
end
