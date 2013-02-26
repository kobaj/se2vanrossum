(include-book "list-utilities" :dir :teachpacks)
(include-book "io-utilities" :dir :teachpacks)
(set-state-ok t)

; (bunch-of-chrs filename state)
; This function takes in a file and a state and returns a list of
; lists of characters
; filename = string representation of the file to read
; state = file->string state
(defun bunch-of-chrs (filename state)
  (let* ((rawinput (car (file->string filename state)))
         (chrs (str->chrs rawinput)))
    (tokens '(#\return #\newline #\>) chrs)))

; (just-words xs)
; This function takes in a list of lists of characters and returns
; a list of lists of words of the form (("word1") ... ("wordN"))
; xs = list of lists of characters
(defun just-words (xs)
  (if (consp xs)
      (let* ((first (chrs->str (car xs)))
             (rest (just-words (cdr xs))))
        (cons (list first) rest))
      nil))

; (words-hints xs)
; This function takes in a list of lists of characters and returns
; a list of lists of strings of the form (("word1" "hint1") ...
; ("wordN" "hintN"))
; xs = list of lists of characters
(defun words-hints (xs)
  (if (consp xs)
      (let* ((word (chrs->str (car xs)))
             (hint (chrs->str (cadr xs)))
             (rest (words-hints (cddr xs))))
        (cons (list word hint) rest))
      nil))

; (create-words-list gametype filename state)
; This function takes in a type of game, a file, and a state and
; returns a list of lists of strings
; gametypes: 0 = wordsearch
; 1 = crossword
; 2 = something completely different
; gametype = type of game to create lists for
; filename = string representation of file to be read
; state = file->str state
(defun create-words-list (gametype filename state)
  (if (= gametype 0)
      (just-words (bunch-of-chrs filename state))
      (if (= gametype 1)
          (words-hints (bunch-of-chrs filename state))
          nil)))