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

;char-p (char sols)
;This function performs a simple search to determine if
;a specific character matches the first character of any of
;the solutions. This either return nil for not found or the
;word along with the length.
;char = the char to match
;sols = the words to find
(defun char-p (char sols)
  (if (endp sols)
      nil
      (or 

;search-and-localize (matrix charWordLengths)
;This function performs the overall search of the entire
;matrix and performs a localized search (hill climbing) if
;any of the first characters of each solution is found
;at the current letter in the matrix.
;matrix = the gameboard
;charWordLengths = the solutions with first character, the word itself, and the length
(defun search-and-localize (matrix charWordLengths)
 (if (endp matrix)
     nil
     (let*((matching (char-p (caar matrix) charWordLengths)))
       (if (equal matching nil)
           (search-and-localize () charWordLengths);char not in sol list
           ()
           
         
         
  ))


;hill-climbing-solver (matrix words)
;This is the entry point for the hill climbing
;solver. It traverses the entire matrix only once and
;performs localized searches based on matching the first
;character of any of the words. The solution set is a list
;of vectors like brute force solver's output.
;matrix = the gameboard
;words = the solutions to be found
(defun hill-climbing-solver (matrix words)
  (let*((charWordLengths(char-concat-count words))
        (vects(search-and-Localize matrix charWordLengths)))
   ()
   ))
  
  ;TESTING...this is how we use this solver.
;(hill-climbing-solver (list (list "w" "b" "y" "i" "g" "g" "d" "a" "w") ;example game board
;                          (list "m" "l" "i" "d" "i" "q" "p" "u" "o") 
;                          (list "p" "o" "t" "a" "c" "f" "d" "f" "r") 
;                          (list "d" "o" "g" "t" "s" "c" "a" "c" "m")
;                          (list "r" "p" "p" "t" "w" "w" "r" "g" "o")
;                          (list "e" "p" "t" "o" "g" "o" "x" "z" "a")
;                          (list "w" "f" "t" "r" "q" "r" "w" "d" "b")
;                          (list "e" "d" "t" "r" "i" "r" "t" "f" "p")
;                          (list "h" "d" "t" "a" "r" "a" "t" "f" "p")
;                          (list "e" "w" "t" "p" "a" "p" "r" "o" "t")
;                          (list "i" "i" "u" "u" "q" "s" "o" "k" "n")
;                          (list "a" "u" "q" "s" "y" "f" "p" "s" "p")
;                          (list "e" "f" "d" "a" "q" "z" "j" "d" "c"))
;                    
;                    (list (list "c" "a" "t"); example word list 
;                          (list "d" "o" "g") 
;                          (list "p" "i" "g")
;                          (list "r" "a" "t")
;                          (list "p" "a" "r" "r" "o" "t")
;                          (list "s" "p" "a" "r" "r" "o" "w")
;                          (list "w" "o" "r" "m")
;                          )
;                    )

