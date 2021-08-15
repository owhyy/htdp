;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex79) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; 79

; A Color is one of:
; --- "white"
; --- "yellow"
; --- "orange"
; --- "green"
; --- "red"
; --- "blue"
; --- "black"

(define w "white")
(define bk "black")
(define be "blue")

; H is a Number between 0 and 100.
; interpretation represents a happiness value

(define H1 0) 
(define H2 50)
(define H3 100)

(define-struct person [fstname lstname male?])
; A Person is a structure:
;  (make-person String String Boolean)

(define P1 (make-person "John" "Doe" #true))
(define P2 (make-person "Julia" "Applebees" #false))

(define-struct dog [owner name age happiness])
; A Dog is a structure:
;   (make-dog Person String PositiveInteger H)
; interp. represents a dog, its owner, name age and happiness

; A Weapon is one of :
; - #false
; - Posn
; interp. #false means that the missile hasn't
; been fired yet; a Posn means that it is in flight

(define W1 #false)
(define W2 (make-posn 100 20))