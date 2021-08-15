;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname yell_htdf) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; String -> String
;; adds "!" to the end of s

(check-expect (yell "hello") "hello!")
(check-expect (yell "ass") "ass!")

;(define (yell s) s) ;stub

;(define (yell s) ;definition
;  (... s))

(define (yell s)
  (string-append s "!"))
