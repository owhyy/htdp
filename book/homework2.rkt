;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname homework2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;11
(define (distf x y)
  (sqrt (+ (sqr x) (sqr y))))

;12
(define (cvolume s)
  (* s s s))

;(define (csource s)
;  (
;later

;13
(define (string-first s)
  (if (> (string-length s) 0)
      (string-ith s 0)
      s))

;14
(define (string-last s)
  (if (> (string-length s) 0)
      (string-ith s (- (string-length s) 1))
      s))

;15
(define (==> sunny friday)
  (if (or (not sunny) friday)
      #true
      #false))

;16
(define (image-area img)
  (* (image-height img) (image-width img)))

;17
(define (image-classify img)
  (cond
    [(> (image-height img) (image-width img)) "tall"]
    [(< (image-height img) (image-width img)) "wide"]
    [else "square"]))

;18
(define (string-join s1 s2)
  (string-append s1 "_" s2))

;19
(define (string-insert str i)
  (if (and (string? str) (number? i))
     (cond
       [(= 0 (string-length str)) "_"]
       [(> i (string-length str)) str]
       [else (string-append (substring str 0 i) "_" (substring str i (string-length str)))])
      str))

;20
(define (string-delete str i)
  (if (> (string-length str) 0)
      (string-append (substring str 0 i) (substring str (+ i 1) (string-length str)))
      str))

;21
(define (ff n)
  (* 10 n))

;(ff (ff 1))
;(+ (ff 1) (ff 1))
(string-insert "helloworld" 6)
;(distf 3 4)