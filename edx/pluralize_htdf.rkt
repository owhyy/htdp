;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname pluralize_htdf) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; String->String
;; adds "s" to the end of a String

(check-expect (pluralize "apple") "apples")
(check-expect (pluralize "fish") "fishs")

;(define (pluralize s) s) ;stub

;(define (pluralize s) ;definition
;  (... s))

(define (pluralize s)
  (string-append s "s"))