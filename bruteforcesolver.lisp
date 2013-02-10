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
(defun concat-helper (strList)
  (if (endp strList)
      ""
      (concatenate 'string (car strList) (concat-helper (cdr strList))
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
      (cons (list (concat-helper (car solutions))
                  (len (car solutions)))(concat-count (cdr solutions)))
            ))

; nthrdc (xs)
; This function is similar to nthcdr except we are 
; going backwards and removing the nth elements
; from the end of the list.
; n = the number of elements to delete
; xs = the list
(defun nthrdc (n xs)
 (reverse (nthcdr n (reverse xs)))
  )
  
;linear-row-search-helper (row sol)
;This function does the string comparison for each row
; and returns a vector if a solution is found.
;row = the current row
;sol = the current solution to find within the row
;leftOrRight = the direction of search
;rowNum = the current row number
;rowLen = the length of the total row to determine col num
(defun linear-row-search-helper (row sol leftOrRight rowNum colIndex rowSize)
  (if (< (len row) (cadr sol))
      nil ;the length of the current row is
          ;smaller than the solution, hence its not on this row.
      (if (equal (concat-helper (nthrdc (- (len row)(cadr sol)) row ))
                              (car sol);if the sub-row matches the solution
                              )
                              ;found solution
                              ;resulting vector (starting coords, direction, num of spaces from starting coords)
                              (if (equal leftOrRight "right")
                                  (list rowNum colIndex  leftOrRight (- (cadr sol) 1));right coords
                                  (list rowNum (- rowSize colIndex)  leftOrRight (- (cadr sol) 1));left coords
                                  )
                              ;else keep searching within the current row, but the next col
          (linear-row-search-helper (cdr row) sol leftOrRight rowNum (+ colIndex 1) rowSize)
          )))
   

;linear-row-search (sol rows)
;This function takes in a solution and
; a list of rows and does extensive string matching
;within the bounds of each row.
;sol = the target solution
;rows = the matrix in row major order
;leftOrRight = the direction of search

;Note: This is used for searching left to right 
; and right to left only. 
(defun linear-row-search (sol rows leftorRight rowNum)
  (if (endp rows)
      nil
      (let* ((vect (linear-row-search-helper (car rows) sol leftOrRight
                                             (+ rowNum 1)  0 (- (len (car rows)) 1))))
        (if (not (equal vect nil))
            vect
            (linear-row-search sol (cdr rows) leftOrRight (+ rowNum 1))
   ))))

;search-left-to-right (matrix solList)
;This function searches the matrix from left to right
;in order to string match the solutions.
;If solutions are found, then it returns a list of vectors.
;matrix = the game board
;solList = the concatenated list of string characters along with their word sizes.
(defun search-left-to-right (matrix solList)
(if (endp solList) ; no more solutions to check for
    nil
    (cons (linear-row-search (car solList) matrix "right" -1);start indexing the row
          (search-left-to-right matrix (cdr solList)
                                ))))

;reverse-matrix (matrix)
; This function takes in a matrix
;in row order form and reverses it.
;matrix = the matrix to be reversed
(defun reverse-matrix (matrix)
  (if (endp matrix)
      nil
      (cons (reverse (car matrix))(reverse-matrix (cdr matrix)))
   ))

;search-right-to-left (matrix solList)
;This function searches the matrix from right to left
;in order to string match the solutions.
;If solutions are found, then it returns a list of vectors.
;matrix = the game board
;solList = the concatenated list of string characters along with their word sizes.
(defun search-right-to-left (matrix solList)
(if (endp solList) ; no more solutions to check for
    nil
    (cons (linear-row-search (car solList)
                             (reverse-matrix matrix) "left" -1);start indexing the row
          (search-right-to-left matrix (cdr solList)
                                ))))

;transpose-helper (matrix index)
;Thie function acts as a helper for transpose by
;iterating through the whole matrix and creating a column
;out of the given row index.
;matrix = the matrix to be flipped
;index = the row index
(defun transpose-helper (matrix index)
  (if (endp matrix)
      nil
      (cons (car (nthcdr index (car matrix)))
            (transpose-helper (cdr matrix) index))
      ))

;transpose (matrix)
;This function takes in a matrix
;and returns its transpose (flipping to the right)
;matrix = the matrix to flip
;rowLength = the size of every row in the matrix
;Note: To be used for searching up to down and down to up
(defun transpose (matrix rowLength index)
  (if (= rowLength index)
      nil
      (cons (transpose-helper matrix index)
            (transpose matrix rowLength (+ index 1)))
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

;clean-results (results)
;This function takes the list of vectors
;and removes all of the nil entries
;that each search direction returns if 
;the word was not found. This allows the
;results to be human readable and easy to work with
;for modularity.
;results = the list of vectors
(defun clean-results (results)
  (if (endp results)
      nil
      (if (equal (car results) nil)
          (clean-results (cdr results))
          (cons (car results) (clean-results (cdr results)))
          )))
   

;brute-force-solver (matrix solutions)
; This function utilizes a brute force algorithm
; to search, match, and return locations within the grid
; with the pass-in solutions. This is the only function which should be called externally. 
; matrix = the populated grid
; solutions = a list of words that we are searching for
;
;Note: we are excluding diagonals due to complexity.
;
; The result is a list of vectors of the form (x y direction number-of-spaces). 
;Each x and y is zero indexed and the number of spaces is starting from that coordinate
;and going in the direction specified.
(defun brute-force-solver (matrix solutions)
  (let* ((solList (concat-count solutions));concatenate sols with their sizes
         (searchLeftToRight(search-left-to-right matrix solList))
         (searchRightToLeft(search-right-to-left matrix solList))
         (searchUpToDown (search-up-to-down matrix solList))
         (searchDownToUp (search-down-to-up matrix solList)))
        (clean-results(concatenate 'list searchLeftToRight searchRightToLeft
                     searchUpToDown searchDownToUp));return a list of all vectors found. 
   ))

;TESTING...this is how we use this solver.
;(brute-force-solver (list (list "a" "b" "y" "f" "g") ;;example game board
;                          (list "m" "l" "i" "h" "i") 
;                          (list "p" "o" "t" "a" "c") 
;                          (list "d" "o" "g" "q" "s")
;                          (list "r" "p" "t" "u" "w"))
;                    (list (list "c" "a" "t") (list "d" "o" "g") (list "i" "d" "g")); example solutions list
;                    )

           (transpose(list(list "a" "b" "y" "f" "g")
                          (list "m" "l" "i" "h" "i") 
                          (list "p" "o" "t" "a" "c") 
                          (list "d" "o" "g" "q" "s")
                          (list "r" "p" "t" "u" "w")) 5 0)

