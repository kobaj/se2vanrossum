;Shane Moore
;Team Van-Rossum
; create-board.el
;
; Generates the matrix game board depending
; on whether it is xword on wrd search
; if word search difficulty is involved
;



; Helper function to get largest element returns larger
; of two words
(defun largest-elem-helper (word1 word2)
  (if (>= (length word1) (length word2))
      word1)
  word2)

; Finds the largest element
; of a list of words to decide
; the correct matrix size
(defun largest-elem (word words)
  (if (endp words) (length word)
      (largest-elem 
       (largest-elem-helper word (car words)) 
      (cdr words))))

; Generates difficulty given
; Selected difficulty returns 
; an integer for board size
(defun gen-diff (words diff)
  (let ((n (largest-elem (car words) (cdr words)))
        (diff (+ n 1))
    diff)))


; To construct rows for the matrix
(defun mtx-row (n)
  (if (= n 0) nil
      (cons "" (mtx-row (- n 1))))
  )

;Create our matrix-board
(defun mtx (m n)
    (if (equal n 0) nil
      (cons (mtx-row m) (mtx m (- n 1)))))

;Generate Board for word-search
(defun wdsrch-brd (words diff)
  (let ((diff (gen-diff  words diff))
        (brd (mtx (len words) diff))
        (wdsrch (plce-words brd words))        
        wdsrch)))

;Generate Board for word-search
(defun xwrd-brd (words)
  (let ((brd (mtx diff diff))
        (xwrd (plce-words brd words))        
        xwrd)))
  
; Initial call to crate appropriate board
(defun create-board (words game diff)
   (cond (= game 1) (wdsrch-brd words diff)
	 (= game 2) (xword-brd words) 
))
