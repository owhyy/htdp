;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ufo-status) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

; A WorldState is a Number.
; interpretation number of pixels between the top and the UFO
(define WIDTH 300) ; distances in terms of pixels
(define HEIGHT 800)
(define CLOSE (/ HEIGHT 3))
(define MTSCN (empty-scene WIDTH HEIGHT))
(define UFO (overlay (circle 10 "solid" "green") (rectangle 40 5 "solid" "green")))

; WorldState -> WorldState
(define (main y0)
  (big-bang y0
    [on-tick nxt]
    [to-draw render/status]))

; WorldState -> WorldState
; computes next location of UFO
(check-expect (nxt 11) 14)
(define (nxt y)
  (+ y 3))

; WorldState -> Image
; places UFO at given height into the center of MTSCN
(check-expect (render 11) (place-image UFO (/ WIDTH 2) 11 MTSCN))
(define (render y)
  (place-image UFO (/ WIDTH 2) y MTSCN))

; WorldState -> Image
; adds a status line to the scene created by render

(check-expect (render/status 10)
              (place-image (text "descending" 11 "green")
                           30 20
                           (render 10)))

; here place-image is redundant, as it is used 3 times when it can be used only once
; for all 3 cases
#; (define (render/status y)
  (cond
    [(<= 0 y CLOSE)
     (place-image (text "descending" 11 "green")
                        10 10
                        (render y))]
    [(and (< CLOSE y) (<= y HEIGHT))
     (place-image (text "closing in" 11 "orange")
                  10 10
                  (render y))]
    [(> y HEIGHT)
     (place-image (text "landed" 11 "red")
                  10 10
                  (render y))]))

(define (render/status y)
  (place-image
   (cond
    [(<= 0 y CLOSE)
     (text "descending" 11 "green")]
    [(and (< CLOSE y) (<= y HEIGHT))
     (text "closing in" 11 "orange")]
    [(> y HEIGHT)
     (text "landed" 11 "red")])
   30 20
   (render y)))