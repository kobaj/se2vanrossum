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

;defun clean-results-tier3 (results)
;This is essentially a third helper for cleaning the results
;that goes through the cleaned list and extracts the vectors.
;results = the "cleaned" results
(defun clean-results-tier3 (results)
  (if (endp results)
      nil
      (cons (caar results)
            (clean-results-tier3 (cdr results)))))

;defun clean-results-tier2 (results)
;This is essentially a second helper for the clean-results
;that goes through the cleaned list and gets rid of the final nil elements.
;results = the "cleaned" results
(defun clean-results-tier2 (results)
  (if (endp results)
      nil
      (if (equal (car results) nil)
          (clean-results-tier2 (cdr results))
          (cons  (car results) (clean-results-tier2 (cdr results))))))

;defun clean-results-helper (inner)
;This function is a helper for clean-results.
;It iterates through a list and removes nil elments.
;inner = the inner list
(defun clean-results-helper (inner)
  (if (endp inner)
      nil
      (if (equal (car inner) nil)
          (clean-results-helper (cdr inner))
          (cons (car inner) (clean-results-helper (cdr inner))))))
          

;clean-results-tier1 (results)
;This function takes the list of vectors
;and removes all of the nil entries
;that each search direction returns if 
;the word was not found. This allows the
;results to be human readable and easy to work with
;for modularity.
;results = the list of vectors
(defun clean-results-tier1 (results)
  (if (endp results)
      nil
      (cons (clean-results-helper (car results))
            (clean-results-tier1 (cdr results)))))

; nthrdc (xs)
; This function is similar to nthcdr except we are 
; going backwards and removing the nth elements
; from the end of the list.
; n = the number of elements to delete
; xs = the list
(defun nthrdc (n xs)
  (if (or (< (len xs) n) (< n 0))
      nil
      (reverse (nthcdr n (reverse xs)))))

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
        (if (equal (car sol)
                   (char-concat-helper (nthcdr y (nthrdc (- (len (nthcdr y r-row)) (cadr sol)) r-row))))
            (list x y "left" (- (cadr sol) 1)) ;solution found
            nil
            )
  nil ;solution cant fit, so its automatically not there
  ))

;reverse-matrix (matrix)
; This function takes in a matrix
;in row order form and reverses it.
;matrix = the matrix to be reversed
(defun reverse-matrix (matrix)
  (if (endp matrix)
      nil
      (cons (reverse (car matrix))(reverse-matrix (cdr matrix)))
   ))

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

;defun match-up-to-down (x y rows sol)
;This function takes as many rows as the size of the solution
;and matches the solution based on the coordinate of the potential
;starting position.
;x = the x coord
;y = the y coord
;t-rows = the transposed rows below the potential solution (number of them = word length)
;sol = the solution to be matched
(defun match-up-to-down (x y t-rows sol)
      (if (equal (char-concat-helper (car (nthcdr y t-rows))) (car sol))
          (list x y "down" (- (cadr sol) 1))
          nil
   ))

;defun match-down-to-up (x y rows sol)
;This function takes as many rows as the size of the solution
;and matches the solution based on the coordinate of the potential
;starting position.
;x = the x coord
;y = the y coord
;rt-rows = the reverse transposed rows below the potential solution (number of them = word length)
;sol = the solution to be matched
(defun match-down-to-up (x y rt-rows sol)
      (if (equal (char-concat-helper (reverse (car (nthcdr y rt-rows)))) (car sol))
          (list x y "up" (- (cadr sol) 1))
          nil
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
      (let* ((leftToRight (match-left-to-right x y (car (nthcdr x matrix))
                                               (car solutions)))
             (rightToLeft (match-right-to-left x y  (reverse (car (nthcdr x matrix)))
                                                (car solutions)))
             (upToDown (match-up-to-down x y (transpose
                                              (nthrdc (- (len (nthcdr x matrix)) (cadr (car solutions))) (nthcdr x matrix))
                                              (len (car matrix))
                                              0)
                                         (car solutions)))

              (downToUp (match-down-to-up x y (transpose (nthrdc (- (len (nthcdr (- (+ x 1) (cadr (car solutions))) matrix)) ;TODO cont here, move each item to its methods instead
                                                                       (cadr (car solutions)))
                                                                    (nthcdr (- (+ x 1) (cadr (car solutions))) matrix))
                                                            (len (car matrix))
                                                            0)
                                             (car solutions)))) ;using nested ifs instead of cond so we have the else statement at the end
     
        (if (not (equal leftToRight nil))
            leftToRight
            (if (not (equal rightToLeft nil))
                rightToLeft
                (if (not (equal downToUp nil))
                    downToUp
                    (if (not (equal upToDown nil))
                        upToDown
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
;Note: The results need to be cleaned up since we are performing lots 
;of localized searches within an overall search.
(defun hill-climbing-solver (matrix words)
(clean-results-tier3
 (clean-results-tier2
  (clean-results-tier1 
   (search-and-Localize matrix matrix (char-concat-count words) 0)))))
  
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
                          (list "i" "i" "u" "u" "q" "s" "o" "k" "j")
                          (list "a" "u" "d" "d" "f" "j" "h" "w" "q")
                          (list "j" "d" "f" "a" "g" "l" "f" "g" "d")
                          (list "g" "d" "u" "x" "j" "n" "o" "o" "r")
                          (list "d" "s" "j" "s" "k" "m" "x" "h" "x")
                          (list "s" "w" "k" "q" "q" "a" "d" "c" "z"))
                    
                    (list (list "c" "a" "t"); example word list 
                          (list "d" "o" "g") 
                          (list "p" "i" "g")
                          (list "r" "a" "t")
                          (list "p" "a" "r" "r" "o" "t")
                          (list "s" "p" "a" "r" "r" "o" "w")
                          (list "w" "o" "r" "m")
                          (list "f" "o" "x")
                          (list "h" "o" "g")
                          )
                    )




