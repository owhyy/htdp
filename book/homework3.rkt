;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname homework3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; 34
;; String -> String
;; Produces first character of consumed string
; given: "ana", expect: "a"
; given: "smoke", expect: "s"

;(define (string-first s) "")
;(define (string-first s) ;function template
;  (... s))

(define (string-first s)
  (string-ith s 0))

;; 35
;; String -> String
;; Produces last character from non-empty string
; given: "BSL", expect: "L"
; given: "", expect: ""
;given: "design" exepct: "n"

;define (string-last s) "")
;(define (string-last s)
;  (if (...s)
;  (... s)
;  (... s)))
(define (string-last s)
  (if (> (string-length s) 1)
      (string-ith s (- (string-length s) 1))
      ""))

;; 36
;; Image -> Natural Number
;; Counts the number of pixels in consumed image
;; Pixels are nonnegative integers that represent the smallest element of an image
; given: (square 10 "solid" "red"), expect: 100
; given: (rectangle 30 20 "solid" "yellow"), expect: 600

;(define (image-area img) 0)
;(define (image-area img)
;  (... img))

(define (image-area img)
  (* (image-width img) (image-height img)))

;; 37
;; String -> String
;; Produces the consumed string with the first character removed
; given: "Uganda", expect: "ganda"
; given: "pixel", expect: "ixel"
; given: "", expect: ""

;(define (string-rest s) "") ;stub
;(define (string-rest s)
;  (if (... s)
;      (... s)
;      ""))

(define (string-rest s)
  (if (> (string-length s) 1)
      (substring s 1 (string-length s))
      ""))

;; 38
;; String -> String
;; Produces consumed string with the last character removed
; given: "Uganda", expect: "Ugand"
; given: "pixel", expect: "pixe"
; given: "", expect: ""

;(define (string-remove-last s) "")
;(define (string-remove-last s)
;  (if (... s)
;      (... s)
;      ""))

(define (string-remove-last s)
  (if (> (string-length s) 1)
      (substring s 0 (- (string-length s) 1))
      ""))
