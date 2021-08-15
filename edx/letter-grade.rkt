;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname letter-grade) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; LetterGrade is one of
;; - "A"
;; - "B"
;; - "C"
;; interp. LetterGrade represents the letter grade in a course
;; <examples are redundant for enumerations>

(define GR1 "A")
(define GR2 "B")
(define GR3 "A")
#;
(define (fn-for-grade-type lg)
  (cond [(string?= lg "A") (...)]
        [(string?= lg "B") (...)]
        [(string?= lg "C") (...)]))

;; Template rules used:
;; - one of: 3 cases
;; - atomic distinct value: "A"
;; - atomic distinct value: "B"
;; - atomic distinct value: "C"

