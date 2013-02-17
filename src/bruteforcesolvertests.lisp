;This file contains unit tests for Brute Force solver.
;Authored by Cezar Delucca


(include-book "bruteforcesolver")
(include-book "testing" :dir :teachpacks)


;concat-count tests
;(check-expect (concat-count (list (list "d" "o" "g")(list "r" "a" "t")(list "s" "q" "u" "i" "r" "r" "e" "l")(list "s" "n" "a" "k" "e")))
;                            (list (list "dog" 3) (list "rat" 3) (list "squirrel" 8) (list "snake" 5)))
;
;(check-expect (concat-count (list nil))
;                            (list (list "" 0)))

;nthrdc tests
;(check-expect (nthrdc 3 (list "a" "b" "c" "d" "e" "f" "g")) (list "a" "b" "c" "d"))
;
;(check-expect (nthrdc 300 (list "a" "b" "c" "d" "e" "f" "g")) nil)
;
;(check-expect (nthrdc 3 nil)  nil)

;linear-search tests
;Note: only testing right direction since going left, up, down require other functions.
;(check-expect (linear-search (list "rat" 3) (list (list "r" "p" "p" "r" "a" "t" "r" "g" "o")  
;                                                  (list "e" "p" "t" "o" "g" "r" "a" "z" "a")) "right" -1)
;              (list 0 3 "right" 2))
;
;(check-expect (linear-search (list "rat" 3) (list(list "e" "p" "t" "o" "g" "r" "a" "z" "a")
;                                                  (list "r" "p" "p" "r" "a" "t" "r" "g" "o")) "right" -1)
;              (list 1 3 "right" 2))

;tests for search-left-to-right

;(check-expect (search-left-to-right (list (list "w" "b" "y" "i" "g" "g" "d" "a" "w") 
;                                          (list "m" "l" "i" "d" "i" "q" "p" "u" "o") 
;                                          (list "p" "o" "t" "a" "c" "f" "d" "f" "r") 
;                                          (list "d" "o" "g" "t" "s" "c" "a" "c" "m")
;                                          (list "r" "p" "p" "t" "w" "w" "r" "g" "o")
;                                          (list "e" "p" "t" "o" "g" "o" "x" "z" "a")
;                                          (list "w" "f" "t" "r" "q" "r" "w" "d" "b")
;                                          (list "e" "d" "t" "r" "i" "r" "t" "f" "p")
;                                          (list "h" "d" "g" "a" "r" "a" "t" "f" "p")
;                                          (list "e" "w" "t" "p" "a" "p" "r" "o" "t")
;                                          (list "i" "i" "u" "u" "q" "s" "o" "k" "n")
;                                          (list "a" "u" "q" "s" "y" "f" "p" "s" "p")
;                                          (list "e" "f" "d" "a" "q" "z" "j" "d" "c") )
;                                    (list (list "rat" 3) (list "dog" 3)))
;              (list (list 8 4 "right" 2)
;                    (list 3 0 "right" 2)
;                    )
;              );resulting vectors
;
;(check-expect (search-left-to-right (list (list "w" "b" "y" "i" "g" "g" "d" "a" "w") 
;                                          (list "m" "l" "i" "d" "i" "q" "p" "u" "o") 
;                                          (list "p" "o" "t" "a" "c" "f" "d" "f" "r") 
;                                          (list "d" "o" "g" "t" "s" "c" "a" "c" "m")
;                                          (list "r" "p" "p" "t" "w" "w" "r" "g" "o")
;                                          (list "e" "p" "t" "o" "g" "o" "x" "z" "a")
;                                          (list "w" "f" "t" "r" "q" "r" "w" "d" "b")
;                                          (list "e" "d" "t" "r" "i" "r" "t" "f" "p")
;                                          (list "h" "d" "g" "a" "r" "a" "t" "f" "p")
;                                          (list "e" "w" "t" "p" "a" "p" "r" "o" "t")
;                                          (list "i" "i" "u" "u" "q" "s" "o" "k" "n")
;                                          (list "a" "u" "q" "s" "y" "f" "p" "s" "p")
;                                          (list "e" "f" "d" "a" "q" "z" "j" "d" "c") )
;                                   nil)
;             nil
;              )

;reverse-matrix test
;(check-expect (reverse-matrix (list (list "w" "b" "y" "i" "g" "g" "d" "a" "w") 
;                                          (list "m" "l" "i" "d" "i" "q" "p" "u" "o") 
;                                          (list "p" "o" "t" "a" "c" "f" "d" "f" "r") 
;                                          (list "d" "o" "g" "t" "s" "c" "a" "c" "m")
;                                          (list "r" "p" "p" "t" "w" "w" "r" "g" "o")
;                                          (list "e" "p" "t" "o" "g" "o" "x" "z" "a")
;                                          (list "w" "f" "t" "r" "q" "r" "w" "d" "b")
;                                          (list "e" "d" "t" "r" "i" "r" "t" "f" "p")
;                                          (list "h" "d" "g" "a" "r" "a" "t" "f" "p")
;                                          (list "e" "w" "t" "p" "a" "p" "r" "o" "t")
;                                          (list "i" "i" "u" "u" "q" "s" "o" "k" "n")
;                                          (list "a" "u" "q" "s" "y" "f" "p" "s" "p")
;                                          (list "e" "f" "d" "a" "q" "z" "j" "d" "c") ))
;              
;              (list (list "w" "a" "d" "g" "g" "i" "y" "b" "w")
;                    (list "o" "u" "p" "q" "i" "d" "i" "l" "m")
;                    (list "r" "f" "d" "f" "c" "a" "t" "o" "p")
;                    (list "m" "c" "a" "c" "s" "t" "g" "o" "d")
;                    (list "o" "g" "r" "w" "w" "t" "p" "p" "r")
;                    (list "a" "z" "x" "o" "g" "o" "t" "p" "e")
;                    (list "b" "d" "w" "r" "q" "r" "t" "f" "w")
;                    (list "p" "f" "t" "r" "i" "r" "t" "d" "e")
;                    (list "p" "f" "t" "a" "r" "a" "g" "d" "h")
;                    (list "t" "o" "r" "p" "a" "p" "t" "w" "e")
;                    (list "n" "k" "o" "s" "q" "u" "u" "i" "i")
;                    (list "p" "s" "p" "f" "y" "s" "q" "u" "a")
;                    (list "c" "d" "j" "z" "q" "a" "d" "f" "e"))
;              )

;search-right-to-left test

;(check-expect )






