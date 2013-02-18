; SE2 Van Rossum
;
;placement.lisp 
;
; places the words within the word search
;


(include-book "rand" :dir :teachpacks)
(include-book "io-utilities" :dir :teachpacks)
(include-book "list-utilities" :dir :teachpacks)


;Updates the board by putting the modified row
; into its right place making a new board
(defun update-row (brd brd-length row row-num n)
  (if (= n brd-length) nil ;finish
  (if (= n row-num)
      (cons  row 
	     (update-row 
	      (cdr brd) brd-length row row-num (+ 1 n)))
      (cons (car brd) 
            (update-row (cdr brd) brd-length 
                        row  
                        row-num 
                        (+ 1 n)))) ))
      


;;;;;;;;;;;;;;;------------------------------------------Get Star and END t Coord
; Gets the end coordinate for the row
(defun get-end (n nums)
  (if (endp nums) n
      (if (= (car nums) n)
          (get-end (+ n 1) (cdr nums))
          (-  n 1))))


; Gets the start and end coordinates for the row
; This returns a list of consec coordinates for row
(defun start-end (n nums)
  (if (endp nums) '()
      (if (= n (car nums))
          (let ((start (car nums)) ; get the starting point of row
                (end (get-end (+ n 1) (cdr nums)) ;get the ending point of row
                     ))
                (cons (list start end) ;add starting and ending pts
                      (start-end end  (nthcdr (+ 1 end) nums))))
          (start-end (+ n 1) nums))))
(defun do-start-end (nums)
  (if (endp nums) '()
      (cons (start-end 0 (car nums)) (do-start-end (cdr nums)))))


; now we will have the form for the coordinates
;((0,3) (0,6))
(defun mtx-form-helper (n coord)
  (list (list n (car coord)) (list n (cadr coord))))
  
(defun mtx-form (n coords)
  (if (endp coords) '()
      (cons (mtx-form-helper n (car coords)) 
            (mtx-form n (cdr coords)))))

(defun final-coords (n nums)
  (if (endp nums) '()
      (if (equal nil (car nums)) ;nothing open here
          (final-coords (+ n 1) (cdr nums))
      (let* ((vects (start-end 0 (car nums)))
             (tx (mtx-form n vects)))
        (cons tx (final-coords (+ n 1) (cdr nums)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Checks the row and finds all the indices that are blank
(defun ckrow (n row)
  (if (endp row) '()
    (if (char-equal (car row) #\space)
	(cons n (ckrow (+ n 1) (cdr row) ))
      (ckrow (+ n 1) (cdr row))
  )))


; Gets all open coords for board
(defun open-brd-coords (n brd)
  (if (endp brd) '()
    (cons (ckrow 0 (car brd) ) 
	  ( open-brd-coords (+ n 1) (cdr brd)))))



;------------------------------------------------ Find fits
; Filter list down to coordinates that fit
(defun fitsp (word coords)
    (if ( <= (len word) 
             (- (cadr (cadr coords)) 
                    (cadr (car coords))))
	 t
         nil)) 


(defun fits (word coords)
  (if (endp coords) '()
      (if (fitsp word (car coords))
          (cons (car coords) (fits word (cdr coords)))
          (fits word (cdr coords)))))

; Find all the areas that the word will fit given co
(defun do-fits (word coords)
  (if (endp coords) '()
      (cons (fits word (car coords)) 
            (do-fits word (cdr coords)))))    
    
;-----------------------------------------------------




; randomly picks a coord from coords list for placement
(defun rand-coord (seed coords)
  (nth (rand (len coords) seed) coords))

; function just gathers all needed info
; returns coordinate for where to place
(defun fit-coords (word brd seed)
  (let* ((opn (open-brd-coords 0 brd)) ;opn-brd_>final-coords->wd-fits->plc-cord
         (mf (final-coords 0 opn))
         (wd-fits (do-fits word mf))
         (pcords (rand-coord seed (remove nil wd-fits))))
    pcords))

; Changing values of a row puts the
; correct spot utilizing coordinates
(defun row-rep (chrs y1 y2 cnt row)
  (if (= (+ 1 cnt) (len row)) (last row) ;we reached end of row
  (if  (and (not (endp chrs)) (and (>= cnt y1) (< cnt y2)))
      (cons (car chrs) ; where we put characters into board
            (row-rep (cdr chrs) y1 y2 (+ 1 cnt) row)) 
    (cons (nth cnt  row) ; kee going until we are in range
         (row-rep chrs y1 y2 (+ 1 cnt) row)
  
))))

;(defun update-column (col y1 y2 brd)
;  (if (endp brd)

(defun get-column (brd  col)
  (if (endp brd) '()
  (cons (nth col (car brd)) 
        (get-column (cdr brd) col))))

;(defun plc-vert (brd word coords)
;  (let* ((cords (car coords)
;                )
;         (col-num (cadar cords))
;         (y1 (caar cords))
;         (y2 (cadr cords))
;         (cons (plc-vert-helper y1 y2 col word) (plc-vert brd word coords)))))

;Find a need to place letters horizontally
;across the game-board this will do it
(defun plc-horiz (brd word coords)
   (let* ((cords (car coords))
        (row-num (caar cords))
        (y1 (cadar cords)) ; y1 value for placement
        (y2 (cadadr cords)) ; y2 value for placement
        (new-row (row-rep word y1 y2  0 (nth row-num brd)))
          (new-brd 
         (update-row brd (len brd) new-row row-num 0))) ;update board with new row
    new-brd)) ; return new board    


; Place word on the board according to random num generator
(defun place (brd word type coord)
  (cond ((= type 0) (plc-horiz brd word coord)) 
	((= type 1) (plc-horiz brd (reverse word) coord))))
;TODO do for verticals and diagonals


; Main workhorse of this module places word search
(defun plc-wdsrch (words brd seeds)
  (if (endp words) '()
  (let* ((word (coerce (car words) 'list)) ;convert the word to a list of characters
	(type (rand 2 (car seeds))) ;get the type we are placing
	(coords (fit-coords word brd (car seeds)))
 	(new-brd (place brd word type  coords)));our new updated board after we place the word
    (cons new-brd (plc-wdsrch (cdr words) new-brd (cdr seeds))))))