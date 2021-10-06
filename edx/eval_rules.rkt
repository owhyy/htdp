;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname eval_rules) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (foo x)
  (local [(define (bar y) (+ x y))]
    (+ x (bar (* 2 x)))))

(list (foo 2) (foo 3))

1. replacing

(list
 (local [(define (bar y) (+ 2 y))]
   (+ 2 (bar (* 2 2))))
 (foo 3))

2. renaming

(list
 (local [(define (bar_0 y) (+ 2 y))]
   (+ 2 (bar_0 (* 2 2))))
 (foo 3))

3. lifting the local into the global scope

(define (bar_0 y) (+ 2 y))
(list
 (local []
   (+ 2 (bar_0 (* 2 2)))
      (foo 3)))

4. replacing the local with the body

(define (bar_0 y) (+ 2 y))
(list
   (+ 2 (+ 2 (* 2 2)))
      (foo 3))

5. continuing evaluation

(define (bar_0 y) (+ 2 y))
(list (+ 2 (+ 2 4)) (foo 3))

(list (+ 2 6) (foo 3))
(list 8 (foo 3))

6. doing the same thing, but for 3:

(list
 8
 (local [(define (bar y) (+ 3 y))]
   (+ 3 (bar (* 2 3)))))

(define (bar_0 y) (+ 3 y))
(list
 8
 (local []
   (+ 3 (bar_0 (* 2 3)))))

(define (bar_0 y) (+ 3 y))
(list
 8
 (+ 3 (+ 3 (* 2 3))))

(define (bar_0 y) (+ 3 y))
(list
 8
 (+ 3 (+ 3 6)))

(define (bar_0 y) (+ 3 y))
(list
 8
 (+ 3 9))

(define (bar_0 y) (+ 3 y))
(list
 8
 12)