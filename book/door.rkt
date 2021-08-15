;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname door) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
;; Data definitions

;; A DoorState is one of:
;; - LOCKED
;; - CLOSED
;; - OPEN

;; Constants

(define LOCKED "locked")
(define CLOSED "closed")
(define OPEN "open")

;; Functions

;; DoorState -> DoorState
;; closes the door during one tick if the door was open
;(define (door-closer ds) 0)

(check-expect (door-closer LOCKED) LOCKED)
(check-expect (door-closer CLOSED) CLOSED)
(check-expect (door-closer OPEN) CLOSED)

(define (door-closer ds)
  (cond
    [(string=? ds LOCKED) LOCKED]
    [(string=? ds CLOSED) CLOSED]
    [(string=? ds OPEN) CLOSED]))

;; DoorState KeyEvent -> DoorState
;; acts in response to ds and ke
;(define (door-action ds ke) 0)

(check-expect (door-action LOCKED "u") CLOSED)
(check-expect (door-action LOCKED " ") LOCKED)
(check-expect (door-action LOCKED "l") LOCKED)
(check-expect (door-action CLOSED "u") CLOSED)
(check-expect (door-action CLOSED "l") LOCKED)
(check-expect (door-action CLOSED " ") OPEN)
(check-expect (door-action OPEN "u") OPEN)
(check-expect (door-action OPEN " ") OPEN)
(check-expect (door-action OPEN "l") OPEN) ; need to think about this case
(check-expect (door-action LOCKED "a") LOCKED)
(check-expect (door-action CLOSED "a") CLOSED)
(check-expect (door-action OPEN "a") OPEN)

(define (door-action ds ke)
  (cond
    [(and (string=? ds LOCKED) (string=? ke "u")) CLOSED]
    [(and (string=? ds CLOSED) (string=? ke "l")) LOCKED]
    [(and (string=? ds CLOSED) (string=? ke " ")) OPEN]
    [else ds]))

;; DoorState -> Image
;; translates the state of ds into a text image
(check-expect (door-render CLOSED)
              (text CLOSED 40 "red"))
(define (door-render s)
  (text s 40 "red"))

;; DoorState -> DoorState
;; simulates a door with an automatic door closer
(define (door-simulation initial-state)
  (big-bang initial-state
    [on-tick door-closer 3]
    [on-key door-action]
    [to-draw door-render]))