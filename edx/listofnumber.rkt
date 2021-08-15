;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname listofnumber) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ListOfNumber is one of:
;; - empty
;; (cons Number ListOfNumber)
;; interp. a list of numbers

(define LON1 empty)
(define LON2 (cons 1 empty))
(define LON3 (cons 2 (cons 1 empty)))

#;
(define (fn-for-lon lon)
  (cond [(empty? lon) (...)]
        [else
         (... (first lon)
              (fn-for-lon (rest lon)))]))

;; Template rules used:
;; - one of: 2 cases:
;; - atomic distinct: empty
;; - compound: (cons Number ListOfNumber)
;; - self-reference: (rest lon) is ListOfString

;; ListOfNumbers -> Boolean
;; produces true if lon contains a negative number, false otherwise

(check-expect (contains-neg? empty) #false)
(check-expect (contains-neg? (cons 1 empty)) #false)
(check-expect (contains-neg? (cons -5 empty)) #true)
(check-expect (contains-neg? (cons 3 (cons -7 empty))) #true)

;(define (contains-neg? lon) #false)

(define (contains-neg? lon)
  (cond [(empty? lon) #false]
        [else
         (if (< (first lon) 0) #true
              (contains-neg? (rest lon)))]))