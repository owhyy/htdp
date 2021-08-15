;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname rocket-descend) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 300); distances in pixels
(define WIDTH 100)
(define YDELTA 30)
(define BACKG (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))
(define CENTER (/ (image-height ROCKET) 2))

; An LRCD (for launching rocket countdown) is one of:
; -- "resting"
; -- a Number between -3 and -1
; -- a NonnegativeNumber
; interp. a grounded rocket, in countdown mode,
; a NonnegativeNumber denotes the number of pixels
; between the top of the canvas and the rocket (its height)
; "resting" is the initial position, where the rocket is at
; the bottom of the screen waiting for " " to be pressed
; the negative numbers mean the countdown from when " " was pressed
; untill countdown starts

; LRCD -> Image
; renders the state as a resting or flying rocket
(check-expect
 (show "resting")
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(check-expect
 (show -2)
 (place-image (text "-2" 20 "red")
              10 (* 3/4 WIDTH)
              (place-image ROCKET 10 (- HEIGHT CENTER) BACKG)))

(check-expect
 (show 53)
 (place-image ROCKET 10 (- 53 CENTER) BACKG))

(check-expect
 (show HEIGHT)
 (place-image ROCKET 10 (- HEIGHT CENTER) BACKG))

(check-expect
 (show 0)
 (place-image ROCKET 10 (- CENTER) BACKG))

; LRCD -> Image
; draws the rocket at x
; used to avoid code duplication in the show function

(define (show-aux x)
  (place-image ROCKET 10 (- x CENTER) BACKG))

(define (show x)
  (cond
    [(and (string? x) (string=? x "resting"))
     (show-aux HEIGHT)]
    [(<= -3 x -1)(place-image (text (number->string x) 20 "red")
                              10 (* 3/4 WIDTH)
                              (show-aux HEIGHT))]
    [(>= x 0) (show-aux x)]))

; LRCD KeyEvent -> LRCD
; starts the countdown when space bar is pressed,
; if the rocket is still resting

(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)

(define (launch x ke)
  (cond
    [(string? x) (if (string=? " " ke) -3 x)]
    [(<= -3 x -1) x]
    [(>= x 0) x]))

; LRCD -> LRCD
; raises the rocket by YDELTA,
; if it is moving already

(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT)
(check-expect (fly 10) (- 10 YDELTA))
(check-expect (fly 22) (- 22 YDELTA))

(define (fly x)
  (cond
    [(string? x) x]
    [(<= -3 x -1)(if (= x -1) HEIGHT (+ x 1))]
    [(>= x 0) (- x YDELTA)]))

; LRCD -> LRCD
; stops the program when ROCKET is at (10 0)

(check-expect (stop? (- CENTER)) #true)
(check-expect (stop? 10) #false)
(define (stop? y)
  (if (number? y)
      (<= y (- CENTER))
      #false))
 ; LRCD -> LRDC
; launches the program from a state s
(define (main s)
  (big-bang s
    [to-draw show]
    [on-key launch]
    [on-tick fly 1]
    [stop-when stop?]
    ))