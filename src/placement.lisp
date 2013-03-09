; @Author Van Rossum
;
; placement.lisp 
;
; places the words within the word search
;

(in-package "ACL2")

(include-book "rand" :dir :teachpacks)
(include-book "io-utilities" :dir :teachpacks)
(include-book "list-utilities" :dir :teachpacks)
(include-book "fits")

;-------------------------------------------------------------------
;---------Start board elems retrieval and Modification--------------
;-------------------------------------------------------------------


;----------------------------------------------------------------
;---------X,Y placement-----------------------------------------
;---------------------------------------------------------------
(defun get-row (brd n)
  (nth n brd))

; Helper method
(defun plc-indx-helper (n y row char)
  (if (endp row) '()
    (if (= n y )
	(cons char (plc-indx-helper (+ 1 n) y (cdr row) char))
      (cons (car row) (plc-indx-helper (+ 1 n) y (cdr row) char)))))



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

; Places character at specified index
(defun plc-indx (brd x y char)
  (let* ((row (get-row brd x))
	 (new-row (plc-indx-helper 0 y row char))
	 )
     (update-row brd (len brd) new-row x 0)))




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


; Returns the column for replacement
(defun get-column (brd  col)
  (if (endp brd) '()
  (cons (nth col (car brd)) 
        (get-column (cdr brd) col))))

(defun replace-col (brd col col-num)
  (if (endp col) brd
      (cons (row-rep col col-num (+ 1 col-num) 0 (car brd))
            (replace-col (cdr brd) (cdr col) col-num))))


;----------------------------------------------End Board Modifications



(defun rand-start-horiz (range word row-num seed)
  (let* ((new-start (rand range seed))
              (new-end (+ new-start (len word))))
        (list (list row-num new-start) (list row-num new-end)) ))


(defun rand-start-vert (range word row-num seed)
  (let*  ((new-start (rand range seed))
             (new-end (+ new-start (len word)))
             )
        (list (list new-start row-num) (list new-end row-num))))
;word len = 5 
; start 0 
; end 10
; diff 10
; new-start = rand( diff - lenword start anywhere between 0, 5  
(defun rand-start (coords word seed type)
  (if (< type 2)
      (let* ((start (cadar coords))
              (end (cadadr coords))
              (row-num (caar coords))
              (diff (- end start))
              (range (- diff (len word))))
        (if (< range 2)
            coords
            (rand-start-horiz range word row-num (+ 1 seed))))
              
      (let* ((start (caar coords))
             (row-num (cadar coords))
             (end (caadr coords))
             (diff (- end start)
                   )
             (range (- diff (len word))))
     (if (< range 2)
            coords
            (rand-start-vert range word row-num (+ 1 seed))))))
         

; Randomly picks a coord from coords list for placement
(defun rand-coord (seed coords)
  (nth (rand (len coords) seed) coords))

; Function just gathers all needed info
; returns coordinate for where to pla2e
(defun fit-coords (type word brd seed)
  (if (< type 2)
      (let* ((opn (open-brd-coords 0 brd)) ;opn-brd_>final-coords->wd-fits->plc-cord
             (mf (coords-horiz 0 opn))
             (wd-fits (do-fits word mf))
             (rcords (rand-coord seed (remove nil wd-fits)))
             (ret-cords (rand-start (car rcords) word seed type)))
       ret-cords)
      (let* ((opn (open-brd-coords 0 brd))
             (mf (coords-vert 0 (openv 0  opn)))
             (wd-fits (do-fits-vert word mf))
            (rcords (rand-coord seed (remove nil wd-fits)))
            (ret-cords (rand-start (car rcords) word seed type)))
      ret-cords)))




;-------------------------------------------------------------------
;---------Place these words in the Board----------------------------
;-------------------------------------------------------------------

; Place this word vertically dog
(defun plc-vert (brd word coords)
  (let* ((col-num (cadar coords))
         (y1 (caar coords))
         (y2 (caadr coords))
         (col (get-column brd col-num))
         (new-col (row-rep word y1 y2 0 col))
         (new-brd (replace-col brd new-col col-num)))
    new-brd))


;Find a place letters horizontally
;across the game-board this will do it
(defun plc-horiz (brd word coords)
   (let* ((row-num (caar coords))
        (y1 (cadar coords)) ; y1 value for placement
        (y2 (cadadr coords)) ; y2 value for placement
        (new-row (row-rep word y1 y2  0 (nth row-num brd)))
          (new-brd 
         (update-row brd (len brd) new-row row-num 0))) ;upd8 brd row
    new-brd)) ; return new board    


 ;Place word on the board according to random num generator
(defun place (brd word type coord)
  (cond ((= type 0) (plc-horiz brd word coord)) 
	((= type 1) (plc-horiz brd (reverse word) coord))
        ((= type 2) (plc-vert brd word coord))
        ((= type 3) (plc-vert brd (reverse word) coord))))



 ;Main workhorse of this module places word search
(defun plc-wdsrch (words brd seed)
  (if (endp words) '()
      (let* ((word (str->chrs (car words))) ;cnvrt str chrs
             (type (rand 4 seed)) ;get the type we are placing
             (coords (fit-coords type word brd (+ seed 57)))
             (new-brd (place brd word type  coords)));our new updated board
        (cons  new-brd (plc-wdsrch (cdr words) new-brd (+ 39 seed))))))

;-------------------------------------------------------End Placement

;End placement.lisp