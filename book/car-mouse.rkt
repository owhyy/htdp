;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname car-mouse) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

; Physical constants
(define BACKGROUND-WIDTH 200)
(define BACKGROUND-HEIGHT (/ BACKGROUND-WIDTH 6))
(define BACKGROUND (empty-scene BACKGROUND-WIDTH BACKGROUND-HEIGHT))
(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5)) 
(define SPEED 1)

; Graphical constans
(define WHEEL
  (circle WHEEL-RADIUS "solid" "black"))
(define SPACE
  (rectangle WHEEL-DISTANCE 0 "solid" "white"))
(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL))
(define BOTTOM-PART(overlay/align/offset
   "left" "center"
   (rectangle (* (+ WHEEL-DISTANCE WHEEL-RADIUS) 2) (* WHEEL-RADIUS 2) "solid" "red")
   (/ (- WHEEL-DISTANCE (* 2 WHEEL-RADIUS)) 2) WHEEL-RADIUS
   BOTH-WHEELS))

(define CAR (overlay/align/offset
   "left" "bottom"
   BOTTOM-PART
   (/ (+ WHEEL-DISTANCE (* 2 WHEEL-RADIUS) ) 2) (- (* WHEEL-RADIUS 3))
   (rectangle WHEEL-DISTANCE (* 2 WHEEL-RADIUS) "solid" "light blue")))

(define Y-CAR  (- BACKGROUND-HEIGHT (/ (image-height CAR) 2)))
(define X-MAX (+ (image-width CAR) BACKGROUND-WIDTH))

(define TREE (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))

; WorldState: data that represents the x-coordinate of the right-most edge of the car

; places the image of the car into BACKGROUND
; according to its state
(define (render-car ws)
  (place-image
    CAR
    ws
    Y-CAR
    (place-image
     TREE
      (/ BACKGROUND-WIDTH 3)
      (- BACKGROUND-HEIGHT (/ (image-height TREE) 2))
      BACKGROUND)))


; WorldState -> WorldState
; moves the car by 3 pixels/clock tick
; given: 20, expect 23
; given: 0, expect 3
(define (tock ws)
  (+ (* SPEED 3) ws))

(define (end ws)
  (>= ws X-MAX))

(check-expect (tock 0) (+ (* SPEED 3) 0))
(check-expect (tock 20) (+ (* SPEED 3) 20))

; WorldState Number Number String -> WorldState
; places the car at x-mouse
; if the given me is "button-down"

(check-expect (hyper 21 10 20 "enter" ) 21)
(check-expect (hyper 42 10 20 "button-down") 10)
(check-expect (hyper 42 10 20 "move") 42)

#;
(define (hyper x-position-of-car x-mouse y-mouse me)
  x-position-of-car) ;stub

#;
(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond [Q A]
        [Q A]
        [else A]))

(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond [(string=? me "button-down") x-mouse]
        [else x-position-of-car]))

; WorldState -> WorldState
; launches the program from a initial state
(define (main ws)
    (big-bang ws
    [on-tick tock]
    [on-mouse hyper]
    [to-draw render-car]
    [stop-when end]))
(main 1)
