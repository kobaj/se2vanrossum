;This file contains the brute force functions for solving a wordsearch puzzle. 
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

;concat-count-helper (strList)
;This function is a helper function for concatenating a list of strings into a 
;single string
;strList = the string list
(defun concat-count-helper (strList)
  (if (endp strList)
      ""
      (concatenate 'string (car strList) (concat-count-helper (cdr strList))
                   )))

;Concat-Count (solutions)
;This function takes in a list of character string representations of
;the solutions and concats into a single string and stores its length 
; for the solver to utilize in string matching.
;solutions = the list of chracter strings
;
;Example
;(concat-count (list (list "c" "a" "t")(list "d" "o" "g")(list "t" "u" "r" "t" "l" "e")( list "s" "n" "a" "k" "e")))
; returns -> (("cat" 3) ("dog" 3) ("turtle" 6) ("snake" 5))
(defun concat-count (solutions)
  (if (endp solutions)
      nil
      (cons (list (concat-count-helper (car solutions))
                  (len (car solutions)))(concat-count (cdr solutions)))
            ))

;Brute-Force-solver (matrix solutions)
; This function utilizes a brute force algorithm
; to search, match, and return locations within the grid
; with the pass-in solutions.
; matrix = the populated grid
; solutions = a list of words that we are searching for
(defun Brute-Force-Solver (matrix solutions)
  (
   ))














