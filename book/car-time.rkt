;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname car-time) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Constant definitions

; Physical constants
(define BACKGROUND-WIDTH 800) ; width of background
(define BACKGROUND-HEIGHT (/ BACKGROUND-WIDTH 6)) ; height of background (depends on BACKGROUND-WIDTH)
(define BACKGROUND (empty-scene BACKGROUND-WIDTH BACKGROUND-HEIGHT)) ; where images will get rendered
(define WHEEL-RADIUS 5) ; radius of the wheel. car proportions and Y-CAR depend on it
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5)) ; distance between wheels (2.5 wheels)
(define V 5) ; veloctiy constant; how fast the car moves/every clock tick
(define DISTANCE-BETWEEN-CURVES-MULTIPLIER 0.03) ; angular velocity or somthing idk
; Graphical constants
(define WHEEL
  (circle WHEEL-RADIUS "solid" "black")) ;car wheel
(define SPACE
  (rectangle WHEEL-DISTANCE 0 "solid" "white")); white "rectangle" between the center of the 2 wheels
(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL)) ;the 2 wheels situated at WHEEL-DISTANCE one from another

(define WHEELS-AND-BODY
  (overlay/align/offset ; wheels along with red-colored part above representing the body of the car
   "left" "center"
   (rectangle (* (+ WHEEL-DISTANCE WHEEL-RADIUS) 2) (* WHEEL-RADIUS 2) "solid" "red")
   (/ (- WHEEL-DISTANCE (* 2 WHEEL-RADIUS)) 2) WHEEL-RADIUS
   BOTH-WHEELS))

(define WINDOWS
  (rectangle WHEEL-DISTANCE (* 2 WHEEL-RADIUS) "solid" "light blue"))

(define CAR (overlay/align/offset ; main image to be rendered: car with 2 wheels, the body (red rectangle) and the window (light blue rectangle)
   "left" "bottom"
   WHEELS-AND-BODY
   (/ (+ WHEEL-DISTANCE (* 2 WHEEL-RADIUS) ) 2) (- (* WHEEL-RADIUS 3))
   WINDOWS))

(define X-CAR (/ (/ (- BACKGROUND-WIDTH (- BACKGROUND-WIDTH (image-width CAR)))2)V)) ; the x coordinate where CAR's left edge touches the left edge of BACKGROUND
(define Y-CAR  (- BACKGROUND-HEIGHT (/ (image-height CAR) 2))) ; the y coordinate, where CAR is on the down edge of BACKGROUND
(define X-MAX (+ (image-width CAR) BACKGROUND-WIDTH)) ; the x coordinate in which the car dissapears on the right side
(define Y-MAX (- BACKGROUND-HEIGHT Y-CAR)) ; the y coordinate in which the car touches to top edge of BACKGROUND

(define TREE (underlay/xy (circle 10 "solid" "green")
               9 15
               (rectangle 2 20 "solid" "brown")))

;; =============================

;; Data definitions

; An AnimationState is a Natural
; interp. the number of clock ticks
; since the animation started

; (define AS1 1) ; 1 clock tick passed since the animation started

#;
(define (func-for-astate as)
  (... as))

; Template parameters used:
; - atomic non-distinct: Natural

; CoordX is a Natural[X-CAR, X-MAX]
; interp. the x coordinate of CAR for each AnimationState
; based on the value of V, from the left side to the right side of BACKGROUND
; the greater CoordX, the more closer to the right edge CAR is

; (define X1 X-CAR) ; CAR is at beginning of track (left edge of car touches the left edge of BACKGROUND) (X-CAR Y-CAR)
; (define X2 50) ; CAR is at (50 Y-CAR)
; (define X3 X-MAX) ; CAR's right side touches the right side of BACKGROUND (X-MAX Y-CAR)

#;
(define (func-for-xcoord x)
  (... x))

; Template parameters used:
; - atomic non-distinct: Natural[CAR-X, X-MAX]

; CoordY is a Natural[Y-CAR, Y-MAX]
; interp. the y coordinate of CAR for each AnimationState
; starting from the point in which CAR touches the bottom edge
; of BACKGROUND, and untill the top part of CAR touches the top edge of BACKGROUND
; the greater CoordY, the closer to the bottom edge CAR is
; NOTE: because CoordY grows differently than in mathematics,
; Y-CAR will be greater than Y-MAX

; (define Y1 Y-CAR) ; CAR touches the bottom edge of BACKGROUND
; (define Y2 50) ; CAR is at (CoordX 50)
; (define Y3 Y-MAX) ; CAR's right side touches the right side of BACKGROUND (X-MAX Y-CAR)

#;
(define (func-for-ycoord y)
  (... y))

; Template parameters used:
; - atomic non-distinct: Natural[Y-CAR, Y-MAX]

;; =============================

;; Function definitions

; AnimationState -> CoordX
; produces the x coordinate of CAR based on t and V

(check-expect (state->coordX 30) (* 30 V))
(check-expect (state->coordX 5) (* 5 V))

; (define (state->coordX s) 0) ;stub

;<uses AnimationState template>
(define (state->coordX s)
  (* s V))

; AnimationState -> Image
; places the image of the car and tree into BACKGROUND
; according to its state and velocity

; NOTE: CAR starts with its left edge touching the left edge
; of BACKGROUND, and the wheels touching the bottom edge
; CAR's movement stops when it dissapears on the right side

(check-expect (render-car 0)
             (
              place-image
              CAR
              (state->coordX 0)
              Y-CAR
              (place-image
               TREE
               (/ BACKGROUND-WIDTH 3)
               (- BACKGROUND-HEIGHT (/ (image-height TREE) 2))
               BACKGROUND)))

; (define (render-car as) (square 0 "solid" "white));stub

; <uses AnimationState template>

(define (render-car as)
  (place-image
    CAR
    (state->coordX as)
    (state->sinY as) ; sin movement
    ; Y-CAR ; uncomment for normal movement
    (place-image
     TREE
      (/ BACKGROUND-WIDTH 3)
      (- BACKGROUND-HEIGHT (/ (image-height TREE) 2))
      BACKGROUND)))


; AnimationState -> AnimationState
; increment the previous AnimationState for every tick
; (define (tock as) 0) ;stub
; <uses AnimationState template>

(check-expect (tock 0) 1)
(check-expect (tock 20) 21)

(define (tock as)
  (add1 as))

; AnimationState -> Boolean
; return #true if car's left side is outside the right side of the screen, #false otherwise
; (define(end? as) #true) ;stub

(check-expect (end? 0) #false)
(check-expect (end? X-MAX) #true)
(check-expect (end? (+ X-MAX 100)) #true)
              
#; (define(end? as)
     (if (Q A)
         #true
         #false))

(define (end? as)
  (>= (state->coordX as) X-MAX))

; AnimationState -> CoordY
; generates the y coordinate of a sine driving path for CAR

(check-within (state->sinY 0)  (- Y-CAR (* (- BACKGROUND-HEIGHT (image-height CAR))(abs(sin (* 0 0.03))))) 0.1)
(check-within (state->sinY 50) (- Y-CAR (* (- BACKGROUND-HEIGHT (image-height CAR))(abs(sin (* 50 0.03))))) 0.1)

;define (state->sinY as) 0) ;stub

; <uses CoordY template>

(define
  (state->sinY as)
  (- Y-CAR                                       ; start from the bottom edge of BACKGROUND
     (* (- BACKGROUND-HEIGHT (image-height CAR)) ; start descending when top edge of CAR hits top edge of BACKGROUND
        (abs(sin (* as DISTANCE-BETWEEN-CURVES-MULTIPLIER))))))                ; * 0.03 so it does not go "weoweoweoweoweo" like crazy :P , abs so it only includes the rising of the curve

; source: http://www.cs.uni.edu/~jacobson/maya/mel/SineBounce.html


; AnimationState -> AnimationState
; launches the program the first tick state
(define (main ws)
    (big-bang ws
    [on-tick tock]
    [to-draw render-car]
    [stop-when end?]))

(main X-CAR)