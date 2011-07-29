Simple Spellchecker
===================

Puzzle problem for a job application.

Simple spellchecker is a ruby script that reads
a database of words and then suggests best corrections
for words based on the following three rules (requirements):

* case errors: inSIDE => inside
* repeated letters: jjoobbb => job
* incorrect vowels: weke => wake

and the assumption that no word in the English dictionary
contains three or more consecutive equal characters. This
was verified by running
    
    $ grep '(.){3}' /usr/share/dict/words
    => ""


Usage
-----

    $ ./spellchecker.rb [path-to-dictionary]

    > TEpp
    tap
    > BbAloTAD
    belated
    > reetel
    NO SUGGESTION

Testing
-------

From within the main (spellchecker) directory in a UNIX system

    $ test/generate.rb | src/spellchecker.rb | grep 'NO SUGGESTION'

If this line returns nothing, the tests are successful.

Implementation
--------------

I used a simple trie that ignores differences between vowels, and
produces a set of candidate words for each pattern. All variations
in terms of duplicated letters are checked.

Example.

1. the user inputs > tTepPpPPp
2. put it in lowercase => ttepppppp
3. remove three or more consecutive letters => ttepp
4. ignore vowels => tt?pp
5. enumerate all variants
    * t?p
    * t?pp
    * tt?p
    * tt?pp
6. find all matches for each variant
    * tap, tip, ...
    * no match
    * no match
    * no match
7. choose the best match, e.g., tap, and output (or NO SUGGESTIONS if there are no matches
after this stage

Complexity
----------

For natural dictionaries, the running time for a single word
is practically linear with respect to the length of the word.
However, for a word with W letters (that become W' when stripped of
repetitions) consisting of V vowels and
N repeated letters, in a worst-case dictionary, the algorithm would
run in time on the order O(W + W' * 5<sup>V</sup> * 2<sup>N</sup>), but this is
very hypothetical. It might be important to note that the runtime will never
exceed the order of memory consumption, that is, the size of the dictionary.

Author
------
Peteris Erins  
[http://peteriserins.com](http://peteriserins.com)
