;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 3d-dist) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct r3 [x y z])
;; An R3 is a structure:
;;   (make-r3 Number Number Number)
;; interp. R3 represents coordinate in 3 dimentional space

(define ex1 (make-r3 1 12 13))
(define ex2 (make-r3 -1 0 3))

(define (fn-for-r3 p)
  (... (r3-x p)
       (r3-y p)
       (r3-z p)))


;; Template rules used:
;;  - compound: 2 fields

;; R3 -> Number
;; calculates the distance from (0 0 0) to p
;  (define (distance-from-0 p) 0)

(check-within (distance-from-0 ex1)
              (sqrt (+ (sqr (r3-x ex1)) (sqr (r3-y ex1)) (sqr (r3-z ex1)))) 0.1)
(check-within (distance-from-0 ex2)
              (sqrt (+ (sqr (r3-x ex2)) (sqr (r3-y ex2)) (sqr (r3-z ex2)))) 0.1)

;; <Uses template from R3>

(define (distance-from-0 p)
  (sqrt (+ (sqr (r3-x p))
           (sqr (r3-y p))
           (sqr (r3-z p)))))

