;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname tail-recursive) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; (listof Number) -> Number
;; produces sum of all numbers in lon

(check-expect (sum (list 1 2 3 4 5)) 15)
(check-expect (sum empty) 0)

#;
(define (sum lon)
  (cond
    [(empty? lon) 0]
    [else
     (+ (first lon)
        (sum (rest lon)))]))

(define (sum lon0)
  (local
    [(define (sum lon acc)
       (cond
         [(empty? lon) acc]
         [else
          (sum (rest lon)
               (+ acc (first lon)))]))]

    (sum lon0 0)))

;; (listof Number) -> Number
;; produces product of every number in lon

(check-expect (product (list 1 2 3 4)) 24)
(check-expect (product empty) 1)

#;
(define (product lon)
  (cond
    [(empty? lon) 1]
    [else
     (* (first lon)
        (product (rest lon)))]))

(define (product lon0)
  ; acc: Number; is the product of elements of (product lon0) seen so far
  ; (product (list 1 2 3) 6) ; outer call 

  ; (product (list 1 2 3) 1)
  ; (product (list   2 3) 1)
  ; (product (list     3) 2)
  ; (product (list      ) 6)
  
  (local
    [(define (product lon acc)
       (cond
         [(empty? lon) acc]
         [else
          (product (rest lon) (* acc (first lon)))]))]

    (product lon0 1)))

;; (list Number) -> Number
;; produce average of all numbers in lon

(check-expect (average empty) 0)
(check-expect (average (list 2 3 4)) 3)

(define (average lon0)
  (local
    [(define (average lon acc1 acc2)
       (cond
         [(empty? lon) (if (zero? acc2) 0
                           (/ acc1 acc2))]
         [else
          (average (rest lon)
                   (+ acc1 (first lon))
                   (add1 acc2))]))]

    (average lon0 0 0)))