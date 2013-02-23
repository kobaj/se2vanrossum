;This file contains the hill climbing functions for solving a wordsearch puzzle. 
;
;Example format for a 4x4 matrix is as follows
; Each entry in the list of lists represents a row. 
;
; (("a" "d" "f" "g")("e" "w" "r" "c")("u" "j" "h" "g")( "b" "n" "j" "k"))
;
; The list of solution will be passed in as:
;(("c" "a" "t")("d" "o" "g") ...)
;
;Authored by Cezar Delucca

;char-concat-count-helper (strList)
;This function is a helper function for concatenating a list of strings into a 
;single string
;strList = the string list
(defun char-concat-helper (strList)
  (if (endp strList)
      ""
      (concatenate 'string (car strList) 
                   (char-concat-helper (cdr strList))
                   )))

;char-concat-count (solutions)
;This function takes in a list of character string representations of
;the solutions and concats into a single string, retains the fist character, and stores its length 
; for the solver to utilize in string matching.
;solutions = the list of chracter strings
;
;Example
;(concat-count (list (list "c" "a" "t")(list "d" "o" "g")(list "t" "u" "r" "t" "l" "e")( list "s" "n" "a" "k" "e")))
; returns -> (("c" "cat" 3) ("d" "dog" 3) ("t" "turtle" 6) ("s" "snake" 5))
(defun char-concat-count (solutions)
  (if (endp solutions)
      nil
      (cons (list (caar solutions) (char-concat-helper (car solutions))
                  (len (car solutions)))(char-concat-count (cdr solutions)))
            ))


;hill-climbing-solver (matrix words)
;This is the entry point for the hill climbing
;solver. It traverses the entire matrix only once and
;performs localized searches based on matching the first
;character of any of the words. The solution set is a list
;of vectors like brute force solver's output.
;matrix = the gameboard
;words = the solutions to be found
;(hill-climbing-solver (matrix words)
;  (let*((charWordLengths(char-concat-count words))
;        ()
;   
;   ))
