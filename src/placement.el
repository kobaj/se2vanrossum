; Team Van Rossum
; Places the words on the board appropriately


; Returns column
; Not sure if will be used
(defun get-col (brd col)
  (if (endp brd)
      nil
  (cons   (nth (car brd)) (cdr brd))))

; Checks the placement of given coordinates 
; Don't know if this will be needed or not
(defun plc-type (cords)
  (cond ((equal (caar cords) (caadr cords)) '("horiz"))
        ((equal (cddr cords) (cadar cords)) '("vert"))
        ((equal 1 1) '("diag"))))
  

; Changing values of a row puts the
; correct spot utilizing coordinates
(defun row-rep (chrs y1 y2 cnt row)
  (if (= cnt (len row)) nil ;we reached end of row
  (if (and (>= y1 cnt) (<= y2 cnt))
      (cons (car chrs) ; where we put characters into board
            (row-rep (cdr chrs) y1 y2 (+ 1 cnt) row)) 
    (cons (car row) ; kee going until we are in range
         (row-rep (nthcdr cnt row) y1 y2 (+ 1 cnt) row)
  
))))

; Mainly for places the vertical letters
; in each row appropriately.
(defun update-mult-row (brd chrs col-num cnt)
  (if (= cnt (len row)) nil ;done
    (if (and (>= x1 cnt) (<= x2 cnt))
	(cons (row-rep chrs col-num col-num 0 (nth cnt brd)) 
	      (update-mult-row (brd ; within range place new row
				(cdr chrs) 
				col-num 
				(+ cnt 1))))
      (cons (nth cnt brd) (update-mult-row brd ;outside range use brd valu
					   chrs 
					   col-num
					   (+ cnt 1))))))
      
  
;Updates the board by putting the modified row
; into its right place making a new board
(defun update-row (brd row row-num n)
  (if (= n brd-length) nil ;finish
  (if (= n row-num)
      (cons  row 
	     (update-row 
	      (cdrbrd) row row-num (+ 1 n)))
      (cons (car brd) 
            (update-row (cdr brd) 
                        row  
                        row-num 
                        (+1 n))))
  ))
      

; Find a need to place letters horizontally
; across the game-board this will do it
(defun plc-horiz (brd word cords)
  (let ((row-num (caar cords))
        (chr-word (str->chr word))
        (y1 (caar cords))
        (y2 (caadr cords))
        (new-row (row-rep chr-word y1 y2  0 row-num))
        (new-brd 
         (update-brd brd new-row row-num 0)))
    new-brd))


; This places words but like up and down
; some would call it vertical                        
(defun plc-vert (brd word cords)
  (let ((col-num (cddr cords))
        (chr-word (str->chr word))
        (x1 (caar cords))
        (x2 (caadr cords))
        (new-row (row-rep chr-word x1 x2  0 row-num))
        (new-brd 
         (update-brd brd new-row row-num 0)))
    new-brd))



;;$$#@$!$!#$#@$#@$!@#$!$!$#!@$#@!$!@$!@ -- Random number Generator !@#
;                                       -- First Fit?
					;-- Best Fit
					;-- depending on type start searching we can use gt column here
; Find an appropriate spot for the 
; word according to its placement 
; type
(defun get-cords (type brd word)
))


(defun ckrow (n row)
  (if (endp row) nil
    (if (= (car row) " ")
	(cons n (ckrow (+ n 1) (cdr row) ))
      (cons nil (ckrow (+ n 1) (cdr)))
  )))

(defun consec (n nums)
  (if (endp nums) nil
    (if (= nums n)
	(cons n (consec 


; Defines if word will fit in given coords
(defun fits (word coords)
  (if (endp coords) nil
    (if ( <= (len words) 
	     (- (cadr (car coords)) (caar coords))
	     (cons (car coords) (fits word (cdr coords)))))))


; Gets the end coordinate for the row
(defun get-end (n nums)
  (if (endp nums) (- n 1) 
      (if (= (car nums) n)
          (get-end (+ n 1) (cdr nums))
          (-  n 1))))


; Gets the start and end coordinates for the row
; This returns a list of coordinates for row
(defun start-end (n nums)
  (if (endp nums) n
      (if (= n (car nums))
          (let ((start (car nums)) ; get the starting point of row
                (end (get-end (+ n 1) (cdr nums)) ;get the ending point of row
                     ))
                (cons (list start end) ;add starting and ending pts
                      (start-end end  (nthcdr (+ 1 end) nums))))
          (start-end (+ n 1) nums))))


; Checks the row and finds all the indices that are blank
(defun ckrow (n row)
  (if (endp row) nil
    (if (char-equal (car row) #\space)
	(cons n (ckrow (+ n 1) (cdr row) ))
      (ckrow (+ n 1) (cdr row))
  )))



; return a list of the avail coordinates
(defun find-fit-h (word brd)
  (if (endp brd) nil
    (

		


; Place word on the board according to random num generator
(defun place (brd word rand)
  (cond (= rand 0) (plc-vert brd word (get-cords 1 brd word )) 
	(= rand 1) (plc-vert brd (reverse word) (get-cords 1 brd word))
	(= rand 2) (plc-horiz brd word (get-cords 2 brd word))
	(= rand 3) (plc-horiz brd (reverse word) (get-cords 2 brd word))
                                                      
))

; Keep track of how the board is created by consing a
; list of boards every time board is updated
(defun plc-wrdsch (brd words)
  (if (endp words) nil
    (let ((new-brd (place brd words rand))) 
	  (cons new-brd (plc-wrdsrch new-brd (cdr words))))
))