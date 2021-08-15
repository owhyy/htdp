;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname letter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

(define (main in-fst in-lst in-sig-name out)
  (write-file out (letter (read-file in-fst)
                          (read-file in-lst)
                          (read-file in-sig-name))))

(define (letter fst lst sig-name)
  (string-append
   (opening fst)
   "\n\n"
   (body fst lst)
   "\n\n"
   (closing sig-name)))

(define (opening fst)
  (string-append "Dear " fst ", "))

(define (body fst lst)
  (string-append
   "We have discovered that all people with the" "\n"
   "last name " lst " have won our lottery. So, " "\n"
   fst ", " "hurry and pick up your prize."))

(define (closing sig-name)
  (string-append
   "Sincerely,"
   "\n\n"
   sig-name
   "\n"))
