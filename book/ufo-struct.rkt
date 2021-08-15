;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ufo-struct) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Constant definitions


;; --------------------

;; Data definitions

(define-struct vel [deltax deltay])
;; A vel is a structure:
;;  (make-vel dx dy)
;; interp. (make-vel) is amount by which ufo will change its position
;; for each tick in both x and y

(define-struct ufo [loc vel])
;; A UFO is a structure:
;;   (make-ufo Posn Vel)
;; interp. (make-ufo p v) is at location p moving at velocity v

#;(define (fn-for-ufo u)
    (... (ufo-loc u) ... (ufo-vel u) ...))

;; Uses template rules:
;; compound: 2 choices???


(define v1 (make-vel 8 -3))
(define v2 (make-vel -5 -3))

(define p1 (make-posn 22 80))
(define p2 (make-posn 30 77))

(define u1 (make-ufo p1 v1))
(define u2 (make-ufo p1 v2))
(define u3 (make-ufo p2 v1))
(define u4 (make-ufo p2 v2))

;; --------------------

;; Functions

;; UFO -> UFO
;; determines where u moves in one clock tick;
;; does not modify velocity

;define (ufo-move-1 u) u)

(check-expect (ufo-move-1 u1) u3)
(check-expect (ufo-move-1 u2)
              (make-ufo (make-posn 17 77) v2))
;; <uses template from UFO>

(define (ufo-move-1 u)
  (make-ufo (posn+ (ufo-loc u)(ufo-vel u)) (ufo-vel u))) 

;; Posn Vel -> Posn
;; adds v to p
(define (posn+ p v)
  (make-posn
   (+ (posn-x p) (vel-deltax v))
   (+ (posn-y p) (vel-deltay v))))

(check-expect (posn+ (make-posn 10 30) (make-vel 3 5)) (make-posn 13 35)) 


;; --------------------
