;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname seat) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; SeatNum is Natural[1, 32]
;; interp. seat numbers in a row, 1 and 32 are aisle seats
(define SN 1)   ;aisle
(define SN2 12) ;middle
(define SN3 32) ;aisle

#;
(define (fun-for-seat-num sn)
  (... sn))

;; template rules used:
;; - atomic non-distinct: Natural[1, 32]

;; Functions:

;; SeatNum -> Boolean
;; prodce true if sn is 1 or 32, false otherwise

;(define (aisle? sn) #false); stub

(check-expect (aisle? 1) #true)
(check-expect (aisle? 15) #false)
(check-expect (aisle? 32) #true)

;<use template from SeatNum>
(define (aisle? sn)
  (or (= sn 1)
  (= sn 32)))