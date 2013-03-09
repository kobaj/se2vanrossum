;This file contains unit tests for Hill Climbing Solver.

(include-book "hillclimbingsolver")
(include-book "testing" :dir :teachpacks)


;char-concat-count tests
(check-expect (char-concat-count 
               (list (list "c" "a" "t")
                     (list "d" "o" "g")
                     (list "t" "u" "r" "t" "l" "e")
                     ( list "s" "n" "a" "k" "e")))
             (list(list "c" "cat" 3) 
                  (list "d" "dog" 3) 
                  (list "t" "turtle" 6)
                  (list"s" "snake" 5))) 

(check-expect (char-concat-count (list nil))
                            (list (list nil "" 0)))

;match-left-to-right
(check-expect (match-left-to-right 0 2 (list "a" "b" "c" "d" "e") (list "cd" 2)) 
             (list 0 2 "right" 1))

(check-expect (match-left-to-right 0 2 nil (list "cd" 2)) 
             nil)

;match-right-to-left
(check-expect (match-right-to-left 0 2 (reverse (list "a" "b" "c" "d" "e")) (list "cb" 2)) 
             (list 0 2 "left" 1))

(check-expect (match-right-to-left 0 3 (list "s" "a" "s" "d" "g") (list "cd" 2)) 
             nil)

;match-up-to-down
(check-expect (match-up-to-down 0 1 (transpose(list (list "s" "c" "g" "j" ) (list "s" "d" "y" "u" )) 4 0) (list "cd" 2))
              (list 0 1 "down" 1))

(check-expect (match-up-to-down 0 2 (transpose(list (list "s" "c" "g" "j" ) (list "s" "d" "y" "u" )) 4 0) (list "gy" 2))
              (list 0 2 "down" 1))

;match-down-to-up
;(check-expect (match-down-to-up 1 1 (reverse (transpose(list (list "s" "d" "g" "j" ) (list "s" "c" "y" "u" )) 4 0)) (list "cd" 2))
;              (list 0 1 "up" 1))
;
;(check-expect (match-down-to-up 1 2 (reverse(transpose(list (list "s" "c" "y" "j" ) (list "s" "d" "g" "u" )) 4 0)) (list "gy" 2))
;              (list 0 2 "up" 1))

