;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ticketprice) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; base cost of a performance
(define BASECOST 180)
(define COSTPERATT 0.04)
(define CLEANTICKETCOST 5.0)
(define PRICE_SENSITIVITY (/ 15 0.1))

; general formula of avg attendance
(define (avg-att tp)
  (- 120 (* (- tp CLEANTICKETCOST) PRICE_SENSITIVITY)))

;revenue
(define (revenue tp)
  (* tp (avg-att tp)))

;total cost of a performance
(define (perfcost tp)
  (+ BASECOST (* (avg-att tp) COSTPERATT)))


;profit
(define (profit tp)
  (- (revenue tp)
     (perfcost tp)))

;calculate
(define (how-much x)
  (if (> 10 (profit x))
      (how-much (+ 0.05 x))
      x))

(profit 1)
(profit 2)
(profit 3)
(profit 4)
(profit 5)

;comparison between prices (when BASECOST is 180 and PPA is 0.04 vs BASECOST 0 and PPA 1.5) :
; $1 : 511.2 vs -360
; $2 : 937.2 vs 285
; $3 : 1063.2 vs 630
; $4 : 889.2 vs 675
; $5 : 415.2 vs 420