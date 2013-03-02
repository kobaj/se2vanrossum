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

; nthrdc (xs)
; This function is similar to nthcdr except we are 
; going backwards and removing the nth elements
; from the end of the list.
; n = the number of elements to delete
; xs = the list
(defun nthrdc (n xs)
 (reverse (nthcdr n (reverse xs))))



;defun match-left-to-right (row sol y)
;This function performs a match on the row for
;a specific solution based on a col index.
;row = the current row
;sol = the target solution
;y = the col index to start
;x = the return x coord for the solution vector
(defun match-left-to-right (x y row sol)
  (if (>= (len (nthcdr y row)) (cadr sol))
      (if (equal (car sol) (char-concat-helper (nthcdr y (nthrdc (- (len (nthcdr y row)) (cadr sol)) row))))
          (list x y "right" (- (cadr sol) 1)) ;solution found
          nil
          )
  nil ;solution cant fit, so its automatically not there
  ))


;defun match-right-to-left (r-row sol y)
;This function performs a match on the row for
;a specific solution based on a col index.
;r-row = the current reversed  row
;sol = the target solution
;y = the col index to start
;x = the return x coord for the solution vector
(defun match-right-to-left (x y r-row sol)
    (if (>= (len (nthcdr y r-row)) (cadr sol))
        (if (equal (car sol)(char-concat-helper (nthcdr y (nthrdc (- (len (nthcdr y r-row)) (cadr sol)) r-row))))
            (list x y "left" (- (cadr sol) 1)) ;solution found
            nil
            )
  nil ;solution cant fit, so its automatically not there
  ))
           
 ;localize (x y matrix solutions)
; This function performs a localized search in
; all possible directions for each potential solution at
; a particular coordinate.
; x = starting x
; y = starting y
; matrix = a copy of the gameboard
; solutions = the words to find
(defun localize (x y matrix solutions)
  (if (endp solutions)
      nil
      (let* ((leftToRight (match-left-to-right x y (car (nthcdr x matrix)) (car solutions)))
             (rightToLeft  (match-right-to-left x y  (reverse (car (nthcdr x matrix))) (car solutions)))
             (upToDown nil)
             (downToUp nil)) ;using nested ifs instead of cond so we have the else statement at the end
        (if (not (equal leftToRight nil))
            leftToRight
            (if (not (equal rightToLeft nil))
                rightToLeft
                (if (not (equal upToDown nil))
                    upToDown
                    (if (not (equal downToUp nil))
                        downToUp
                        (localize x y matrix (cdr solutions))))))

        )))


 
;char-match (char sols)
;This function performs a simple search to determine if
;a specific character matches the first character of any of
;the solutions. This either return nil for not found or the
;list of potential solutions with their lengths. 
;char = the char to match
;sols = the words to find
(defun char-match (char sols)
  (if (endp sols)
      nil
      (if (equal char (caar sols))
          (cons (cdar sols) (char-match char (cdr sols)))
          (char-match char (cdr sols)))))
       
;defun row-char-search (row sols rowIndex colIndex matrix)
;This function performs a linear search across the entire row
;and initiates a localized search if the current character
;matches any in the solution list.
;row = the current row
;sols = the solution list (parsed with char-concat-count)
;rowIndex = the current index of the row (not changing)
;colIndex = the iterating column index
;matrix = a copy of the gamboard for localized search
(defun row-char-search (row sols rowIndex colIndex matrix)
  (if (endp row)
      nil
      (let*((matches(char-match (car row) sols)))
        (if (equal matches nil)
            (row-char-search (cdr row) sols rowIndex (+ colIndex 1) matrix);keep iterating
            (cons (localize rowIndex colIndex matrix matches) ;potential sol(s) found
                  (row-char-search (cdr row) sols rowIndex (+ colIndex 1) matrix))
            ))))

           

;search-and-localize (matrix charWordLengths)
;This function performs the overall search of the entire
;matrix and performs a localized search if
;any of the first characters of each solution is found
;at the current letter in the matrix.
;matrix = the gameboard we are iterating
;charWordLengths = the solutions with first character, the word itself, and the length
;rowIndex = the current row within the matrix
(defun search-and-localize (matrix matrix-copy charWordLengths rowIndex)
 (if (endp matrix)
     nil
     (cons (row-char-search (car matrix) charWordLengths rowIndex 0 matrix-copy)
           (search-and-localize (cdr matrix) matrix-copy charWordLengths (+ rowIndex 1)))
))


;hill-climbing-solver (matrix words)
;This is the entry point for the hill climbing
;matrix = the gameboard
;words = the solutions to be found
(defun hill-climbing-solver (matrix words)
 (search-and-Localize matrix matrix (char-concat-count words) 0))
  
  ;TESTING...this is how we use this solver.
(hill-climbing-solver(list(list "w" "b" "y" "i" "g" "g" "d" "a" "w") ;example game board
                          (list "m" "l" "i" "d" "i" "q" "p" "u" "o") 
                          (list "p" "o" "t" "a" "c" "f" "d" "f" "r") 
                          (list "d" "o" "g" "t" "s" "c" "a" "c" "m")
                          (list "r" "p" "p" "t" "w" "w" "r" "g" "o")
                          (list "e" "p" "t" "o" "g" "o" "x" "z" "a")
                          (list "w" "f" "t" "r" "q" "r" "w" "d" "b")
                          (list "e" "d" "t" "r" "i" "r" "t" "f" "p")
                          (list "h" "d" "t" "a" "r" "a" "t" "f" "p")
                          (list "e" "w" "t" "p" "a" "p" "r" "o" "t")
                          (list "i" "i" "u" "u" "q" "s" "o" "k" "n")
                          (list "a" "u" "q" "s" "y" "f" "p" "s" "p")
                          (list "e" "f" "d" "a" "q" "z" "j" "d" "c"))
                    
                    (list (list "c" "a" "t"); example word list 
                          (list "d" "o" "g") 
                          (list "p" "i" "g")
                          (list "r" "a" "t")
                          (list "p" "a" "r" "r" "o" "t")
                          (list "s" "p" "a" "r" "r" "o" "w")
                          (list "w" "o" "r" "m")
                          )
                    )




