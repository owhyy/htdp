;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname listofstring) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ListOfString is one of:
;; - empty
;; - (cons String ListOfString) ;; self-reference
;; interp. a list of strings

(define LOS1 empty)
(define LOS2 (cons "UBC" empty))
(define LOS3 (cons "McGill" (cons "UBC" empty)))
#;
(define (fn-for-los los)
  (cond [(empty? los) (...)]
        [else
         (... (first los)                 ;String
              (fn-for-los (rest los)))])) ;ListOfString

;; Template rules used:
;; - one of: 2 cases
;; - atomic distinct: empty
;; - compound: (cons String ListOfString)
;; - self-reference: (rest los) is ListOfString

;; ListOfString -> Boolean
;; produces #true if los includes "UBC"

(check-expect (contains-ubc? empty) #false)
(check-expect (contains-ubc? (cons "McGill" empty)) #false)
(check-expect (contains-ubc? (cons "UBC" empty)) #true)
(check-expect (contains-ubc? (cons "McGill" (cons "UBC" empty))) #true)

;(define (contains-ubc? los) false) ;stub

(define (contains-ubc? los)
  (cond [(empty? los) #false]
        [else
         (if (string=? (first los) "UBC")
             #true
             (contains-ubc? (rest los)))]))

