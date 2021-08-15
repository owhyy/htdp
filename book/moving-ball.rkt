;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname moving-ball) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; Constant definitions

(define MTS (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))

;; --------------------

;; Data definitions

;; A Posn represents the state of the world.

;; 

;; --------------------

;; Functions

;; Posn -> Posn
(define (main p0)
  (big-bang p0
    [on-tick x+]
    [on-mouse reset-dot]
    [to-draw scene+dot]))

;; Posn -> Image
;; adds a red spot to MTS at p
;(define (scene+dot p) MTS)
(check-expect (scene+dot (make-posn 10 20))
              (place-image DOT 10 20 MTS))
(check-expect (scene+dot (make-posn 88 73))
              (place-image DOT 88 73 MTS))

(define (scene+dot p)
  (place-image DOT (posn-x p) (posn-y p) MTS)) 

;; Posn -> Posn
;; adds 3 to (posn-x p)

(define (x+ p)
  (make-posn
   (+ 3 (posn-x p))
   (posn-y p)))

(check-expect (x+ (make-posn 30 10)) (make-posn (+ 30 3) 10))
(check-expect (x+ (make-posn 0 130)) (make-posn (+ 0 3) 130))

;; Posn -> Posn
;; produces p with n in place of (posn-x p)
#;(define (posn-up-x p n)
  p)

(check-expect (posn-up-x (make-posn 10 30) 50) (make-posn 50 30))
(check-expect (posn-up-x (make-posn 100 60) 10) (make-posn 10 60))

(define (posn-up-x p n)
  (make-posn n (posn-y p)))

;; Posn Number Number MouseEvent -> Posn
;(define (reset-dot p x y me) p)
(check-expect (reset-dot (make-posn 10 50) 30 20 "button-down") (make-posn 30 20))
(check-expect (reset-dot (make-posn 30 15) 3 27 "button-up") (make-posn 30 15))

(define (reset-dot p x y me)
  (if
   (mouse=? me "button-down")
   (make-posn x y)
   p))
;; --------------------
