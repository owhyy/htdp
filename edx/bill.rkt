;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname bill) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Data definitions
;; MoneyBill is one of:
;; 1
;; 2
;; 5
;; 10
;; 25
;; 50
;; 100
;; 250
;; 500
;; 1000
;; 2000

;; interp. the value of the bill in an arbitrary currency - 1 is bill of 1, 2 is bill of 2 ...
;; (define b-one 1) ; bill of 1
;; (define b-five 5) ; bill of 5

#;
(define (money-function bill)
  (... bill))

; Template rules used:
; - atomic non-distinct: Integer[1, 2, 5, 10, 25, 50, 100, 250, 500, 1000, 2000]

;; Functions:
;; Natural Number -> Boolean

;; checks if n is one of 1 2 5 10 25 100 250 500 1000 2000

;(define (bill? n) 0) ; stub 

(check-expect (bill? 1) #true)
(check-expect (bill? 20) #false)

; took template from MoneyBill

(define (bill? n)
  (or (= 1 n)
      (= 2 n)
      (= 5 n)
      (= 10 n)
      (= 25 n)
      (= 50 n)
      (= 100 n)
      (= 250 n)
      (= 500 n)
      (= 1000 n)
      (= 2000 n)))