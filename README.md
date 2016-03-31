#inverted-index.rkt

Implementation of an [inverted index](https://en.wikipedia.org/wiki/Inverted_index) in Racket.

The resulting inverted index is a hash table of words to a list of pairs. Each pair looks like

  `(<0 indexed line number> . <0 indexed position on that line>)`

##Caveats
* Currently, punctuation is included as a whole word. The implementation could be extended to ignore punctuation, or furthermore, to include all substrings of each word in the inverted index as well.

##Recommended Datasets
I used [the works of Shakespeare](http://www.gutenberg.org/cache/epub/100/pg100.txt) to test the implementation.

