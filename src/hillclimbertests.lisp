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
;(check-expect (match-up-to-down 0 3)(list))

