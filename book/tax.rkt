;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname tax) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Constants
(define LOW-PRICE-MIN 0)
(define MID-PRICE-MIN 1000)
(define HIGH-PRICE-MIN 10000)

(define LOW-PRICE-TAX 0)
(define MID-PRICE-TAX 0.05)
(define HIGH-PRICE-TAX 0.08)

;; Price is one of:
;; - Number[0-1000]
;; - Number[1000-10000]
;; - 10000 and above
;; interp. the price of an item

;; Price -> Number
;; computes the amount of tax charged for p

(check-expect (sales-tax 0) 0)
(check-expect (sales-tax 537) 0)
(check-expect (sales-tax 1000) (* 0.05 1000))
(check-expect (sales-tax 1282) (* 0.05 1282))
(check-expect (sales-tax 10000) (* 0.08 10000))
(check-expect (sales-tax 12017) (* 0.08 12017))

;(define (sales-tax p) 0)

#;(define (sales-tax p)
  (cond
    [(and (<= 0 p) (< p LOW-PRICE-MIN)) ...]
    [(and (<= LOW-PRICE-MIN p) (< p MID-PRICE-MIN)) ...]
    [(>= p MID-PRICE-MIN) ...]))

(define (sales-tax p)
  (cond
    [(and (<= LOW-PRICE-MIN p) (< p MID-PRICE-MIN)) (* LOW-PRICE-TAX p)]
    [(and (<= MID-PRICE-MIN p) (< p HIGH-PRICE-MIN)) (* MID-PRICE-TAX p)]
    [(>= p HIGH-PRICE-MIN) (* HIGH-PRICE-TAX p)]))