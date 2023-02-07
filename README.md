# Unscramble
This app is basically a solver for anagrams and sub-anagrams. Given some scrambled letters, it gives you words and subwords that you can form from it!

### But why another one?
Why not? I made this app while playing Bookworm Adventures and thought about goofing around and just ***annihilate*** the enemies. I found [this](https://word.tips/unscramble-word-finder/) site, and while it did work, the input was limited to 15 letters. The game has a 4x4 block, giving us 16 scrambled letters, so I had to omit a letter every time I use the site. Along with the kinda-long loading time, I thought it was a good idea to make an offline unscrambler, thus the birth of this app.

I know there are other applications out there, written in compiled languages instead of AutoHotkey, but where's the fun in that? The challenge of optimizing an interpreted language is interesting, and AutoHotkey's speed is still considerably fast.

### So what are the optimization techniques?
Preprocessing! Basically sorting the words beforehand. Just like how can you find a book in an organized library faster compared to a book sale, this app finds the appropriate words fast by sorting the words in advance.

Anagrams that are as long as the scrambled text are determined virtually instantaneously since the unique-letter combinations (e.g., readme has 1 a, 1 d, 2 e's, 1 m, and 1 r) are all sorted out beforehand, so the app only has to count the unique letters of the word and then get the words with the same unique letters.

For the sub-anagrams, it takes a little more time, since the application has to check all the unique letters of the words one by one. But the words are already sorted by length, so the app only has to traverse the "dictionary" file once. This is further improved if the user wants to omit words with very little letters (such as three or two-letter words), since the app won't bother to go through with them.

Also, all these sorted variables are loaded into memory when the app starts, but fret not! Thanks to an impressive function I stole from [here](https://www.autohotkey.com/board/topic/30042-run-ahk-scripts-with-less-half-or-even-less-memory-usage/), the application keeps its memory usage to only around 1 to 10 MB, averaging around 5 MB. However, the application stores the text output to a variable, so you should expect the memory usage to spike when using the app with long words.

### I don't want to use the Bookworm Adventures dictionary file
...Understandable. It's very simple! **You'll need AutoHotkey v2 to use your customized app.**
- Download all the files in `Preprocessing`, along with `Unscramble.ahk`.
- You'll need a dictionary file named `dictionary.txt` whose words are separated with a line feed (see the dictionary.txt file in Preprocessing for a sample). Copy the dictionary.txt file to the Preprocessing folder.
- Then just run the scripts in Preprocessing in order (1. WordGroupsSorter.ahk, 2. File2Var.ahk, 3. Dict2VarCounts.ahk).
- Afterwards, copy `WordCombinations.ahk` and `WordCounts.ahk` to the same directory with `Unscramble.ahk` and you're good to go!
  
If you can't do these, or are having issues, post an [Issue](https://github.com/Pizzashi/Unscramble/issues) along with your `dictionary.txt` file and I'll compile your executable for you! In the meantime, excuse me while I ***annihilate*** the fools in Bookworm Adventures...
