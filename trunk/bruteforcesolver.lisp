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

;search-left-to-right (matrix solList)
;This function searches the matrix from left to right
;in order to string match the solutions.
;If solutions are found, then it returns a list of vectors.
;matrix = the game board
;solList = the concatenated list of string characters along with their word sizes.
(defun search-left-to-right (matrix solList)

   )

;search-right-to-left (matrix solList)
;This function searches the matrix from right to left
;in order to string match the solutions.
;If solutions are found, then it returns a list of vectors.
;matrix = the game board
;solList = the concatenated list of string characters along with their word sizes.
(defun search-right-to-left (matrix solList)
  (
   ))

;search-up-to-down (matrix solList)
;This function searches the matrix from up to down
;in order to string match the solutions.
;If solutions are found, then it returns a list of vectors.
;matrix = the game board
;solList = the concatenated list of string characters along with their word sizes.
(defun search-up-to-down (matrix solList)
  (
   ))

;search-down-to-up (matrix solList)
;This function searches the matrix from down to up
;in order to string match the solutions.
;If solutions are found, then it returns a list of vectors.
;matrix = the game board
;solList = the concatenated list of string characters along with their word sizes.
(defun search-down-to-up (matrix solList)
  (
   ))

;brute-force-solver (matrix solutions)
; This function utilizes a brute force algorithm
; to search, match, and return locations within the grid
; with the pass-in solutions.
; matrix = the populated grid
; solutions = a list of words that we are searching for
;
;Note: we are excluding diagonals due to complexity.
(defun brute-force-solver (matrix solutions)
  (let* ((solList (concat-count solutions));concatenate sols with their sizes
         (searchLeftToRight(search-left-to-right matrix solList))
         (searchRightToLeft(search-right-to-left matrix solList))
         (searchUpToDown (search-up-to-down matrix solList))
         (searchDownToUp (search-down-to-up matrix solList)))
        (concatenate 'list searchLeftToRight searchRightToLeft
                     searchUpToDown searchDownToUp);return a list of all vectors found. 
   ))

;TESTING
(brute-force-solver (list (list "a" "b" "c" "f" "g") ;;example game board
                          (list "m" "l" "a" "h" "i") 
                          (list "p" "o" "t" "j" "k") 
                          (list "d" "o" "g" "q" "s")
                          (list "r" "p" "t" "u" "w"))
                    (list (list "c" "a" "t") (list "d" "o" "g")); example solutions list
                    )







