;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname dict) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/batch-io)

;; Constants
(define LOCATION "/usr/share/dict/words")

;; Data definitons

; A Letter is one of the following 1Strings:
; -- "a"
; -- ...
; -- "z"
; or, equivalently, a member? of this list:
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))

; A Dictionary is a ListOfString
(define AS-LIST (read-lines LOCATION))

#;
(define (fn-for-dict d)
  (cond
    [(empty? d) ...]
    [else 
     (... (first d)
          (... (fn-for-dict (rest d))))]))

; A Letter-Count is a (make-lc Letter Integer)
(define-struct lc [letter count])
; interp. the letter and it's occurences as a first letter
(define LC0 (make-lc "" 0))
(define LC1 (make-lc "z" 124))
(define LC2 (make-lc "q" 1103))

(define (fn-for-lc lc)
  (... (lc-letter lc) (lc-count lc)))

; A ListOfLetter-Count is one of:
; empty
; -- (cons Letter-Count ListOfLetter-Count)

;; Functions

; Letter Dictionary -> Number
; counts how many words in d start with l

(check-expect (starts-with# "a" (list "ana" "has" "apples")) 2)
(check-expect (starts-with# "q" (list "ana" "has" "apples")) 0)
(check-expect (starts-with# "t" (list "queens" "of" "the" "stone" "age")) 1)

; (define (starts-with# l d) 0) ;stub
; <uses Dictionary template>
(define (starts-with# l d)
  (cond
    [(empty? d) 0]
    [else 
     (if (string=? (string-ith (first d) 0) l)
         (add1 (starts-with# l (rest d)))
         (starts-with# l (rest d)))]))

; Dictionary -> ListOfLetter-Count
; counts how often each letter is used as the first one of a word in d
(check-expect (count-by-letter empty) empty)
(check-expect (count-by-letter (list "ana" "has" "apples")) (list (make-lc "a" 2) (make-lc "h" 1)))
(check-expect (count-by-letter (list "queens" "of" "the" "stone" "age")) (list (make-lc "a" 1)(make-lc "o" 1)(make-lc "q" 1)(make-lc "s" 1)(make-lc "t" 1)))

;(define (count-by-letter d) LC0) ;stub
(define (count-by-letter d)
  (ignore-zeros (count-aux LETTERS d)))

; ListOfLetter Dictionary -> ListOfLetter-Counts
; counts how many times the letters in lol occur as the first letters in words from d
(check-expect (count-aux (list "a" "b") (list "ana" "has" "apples")) (list (make-lc "a" 2) (make-lc "b" 0)))
(check-expect (count-aux (list "a" "b" "c" "d") (list "queens" "of" "the" "stone" "age")) (list (make-lc "a" 1) (make-lc "b" 0) (make-lc "c" 0) (make-lc "d" 0)))

;(define (count-aux lol d) LC0) ;stub
(define (count-aux lol d)
  (cond
    [(empty? lol) empty]
    [else
     (cons (make-lc (first lol) (starts-with# (first lol) d))
           (count-aux (rest lol) d))]))

; ListOfLetter-Count -> ListOfLetter-Count
; produces the same lol but ignores that occur 0 times
(check-expect (ignore-zeros (list (make-lc "a" 0))) empty)
(check-expect (ignore-zeros (list (make-lc "b" 3))) (list (make-lc "b" 3)))
(check-expect (ignore-zeros (list (make-lc "a" 0) (make-lc "b" 3))) (list (make-lc "b" 3)))

(define (ignore-zeros lol)
  (cond
    [(empty? lol) empty]
    [else
     (if (> (lc-count (first lol)) 0)
         (cons (first lol) (ignore-zeros (rest lol)))
         (ignore-zeros (rest lol)))]))

;(starts-with# "e" AS-LIST) ; occurences for "e"
;(starts-with# "z" AS-LIST) ; occurences for "z"
;(count-by-letter AS-LIST)  ; occurences for every letter

; Dictionary -> Letter-Count
; produces lc for letter that occurs most often
(check-expect (most-often (list "ana" "are" "mere")) (make-lc "a" 2))
(check-expect (most-often (list "the" "quick" "brown" "fox" "is" "quick")) (make-lc "q" 2))
;(define (most-often d) LC0) ;stub

(define (most-often d) 
   (most-often-aux
    (count-by-letter d)
    (max-lc (count-by-letter d))))

; ListOfLetter-Count -> Number
; produces the max lc-count of lolc
(check-expect (max-lc (count-by-letter (list "ana" "are" "mere"))) 2)
(define (max-lc lolc)
  (cond
    [(empty? lolc) 0]
    [else
     (max (lc-count (first lolc))
          (max-lc (rest lolc)))]))

; ListOfLetter-Count Number -> LetterCount
; produces the lc for letter that occurs most often
; NOTE: is a wrapper for most-often
(check-expect (most-often-aux (count-by-letter (list "ana" "are" "mere")) 2) (make-lc "a" 2))
(check-expect (most-often-aux (count-by-letter empty) 2) LC0)

;(define (most-often-aux lolc n) LC0); stub
(define (most-often-aux lolc n)
  (cond
    [(empty? lolc) LC0]
    [else
     (if (= (lc-count (first lolc)) n)
         (first lolc)
         (most-often-aux (rest lolc) n))]))

; Dictionary -> ListOfDictionary
; produces a list of dictionarys for every letter
(check-expect (words-by-first-letter (list "ana" "are" "mere")) (list (list "ana" "are") (list "mere")))
(check-expect (words-by-first-letter (list "queens" "of" "the" "stone" "age")) (list (list "queens") (list "of") (list "the") (list "stone") (list "age")))

;(define (words-by-first-letter d) (list d));stub 
(define (words-by-first-letter d) 
  (cond
    [(empty? d) empty])) ;stub 

; current word: ana
; if starts with a:
; add to list
; else check next word
; if next words starts with a:
; add to list
; if there are no other words that start with a:
; search for the next word
; current word: mere
; continue like this

; 1. how do i know if there are still words that start with a, to know when to stop?
; maybe do this:
; 1. count how many words of each letter there are
; 2. check and see if the current list's size is < than the number of words that start with the specific letter
;   if list size < number, search again
;   if list size = number, stop and continue with the next letter 
