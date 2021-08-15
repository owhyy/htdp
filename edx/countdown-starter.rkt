;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname countdown-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; CountDown is one of:
;; - false
;; - Natural[1, 10]
;; - "complete"

;; interp.
;; false means countdown has not yet started
;; Natural[1, 10] means countdown is running and how many seconds left
;; "complete" means coundown is over

(define CD1 #false)
(define CD2 3) ; 3 more seconds
(define CD3 "complete")
#;
(define (fn-for-countdown c)
  (cond [(false? c) (...)]
        [(number? c) (... c)]
        [else (...)]))

;; Template rules used:
;; - one of: 3 cases
;; - atomic distinct: #false
;; - atomic non-distinct: Natural[1, 10]
;; - atomic distinct: "complete"

;; Fucntions
;; Countdown -> Image
;; produce image of current state of countdown

(check-expect (countdown->image false) (square 0 "solid" "white"))
(check-expect (countdown->image 3) (text (number->string 3) 24 "black"))
(check-expect (countdown->image "complete") (text "Happy New Year!!!" 24 "red") )

; (define (countdown-to-image c) (square 0 "solid" "white")) ;stub

;<use template from Countdown>

(define (countdown->image c)
  (cond [(false? c) (square 0 "solid" "white")]
        [(number? c) (text (number->string c) 24 "black")]
        [else (text "Happy New Year!!!" 24 "red")]))
