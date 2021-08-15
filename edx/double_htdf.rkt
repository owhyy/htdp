;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname double_htdf) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Number -> Number
;; returns double the number consumed

(check-expect (double 2) 4)
(check-expect (double 3.2) 6.4)

;(define (double n) 0) ;stub

;(define (double n) ; this is the template
;  (... n))

(define (double n)
  (* 2 n))
