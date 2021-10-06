;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname fold-dir-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; fold-dir-starter.rkt


;In this exercise you will be need to remember the following DDs 
;for an image organizer.


;; =================
;; Data definitions:

(define-struct dir (name sub-dirs images))
;; Dir is (make-dir String ListOfDir ListOfImage)
;; interp. An directory in the organizer, with a name, a list
;;         of sub-dirs and a list of images.
;; NOTE: is mutually recursive

(define (fn-for-dir dir)
  (... (dir-name dir)
       (fn-for-lod (sub-dirs dir))
       (fn-for-loi (images dir))))

;; ListOfDir is one of:
;;  - empty
;;  - (cons Dir ListOfDir)
;; interp. A list of directories, this represents the sub-directories of
;;         a directory.

(define (fn-for-lod lod)
  (cond [(empty? lod) ...]
        [else (...
                (fn-for-dir (first lod))
                (fn-for-lod (rest lod)))]))

;; ListOfImage is one of:
;;  - empty
;;  - (cons Image ListOfImage)
;; interp. a list of images, this represents the sub-images of a directory.
(define (fn-for-loi loi)
  (cond [(empty? loi) ...]
        [else (... (first loi)
                   (fn-for-loi (rest loi)))]))
;; NOTE: Image is a primitive type, but ListOfImage is not.

(define I1 (square 10 "solid" "red"))
(define I2 (square 12 "solid" "green"))
(define I3 (rectangle 13 14 "solid" "blue"))
(define D4 (make-dir "D4" empty (list I1 I2)))
(define D5 (make-dir "D5" empty (list I3)))
(define D6 (make-dir "D6" (list D4 D5) empty))

;; =================
;; Functions:


;PROBLEM A:

;Design an abstract fold function for Dir called fold-dir. 

(define (fn-for-dir dir)
  (... (dir-name dir)
       (fn-for-lod (sub-dirs dir))
       (fn-for-loi (images dir))))

(define (fn-for-lod lod)
  (cond [(empty? lod) ...]
        [else (...
                (fn-for-dir (first lod))
                (fn-for-lod (rest lod)))]))

(define (fold-dir dir base dir) ; !!!
  (cond
    [(empty? dir) base]
    [else (count-images  )]))

;(check-expect (fold-dir 
;; (Dir -> X) Dir (listof Dir) -> X
;
;(define (fold-dir fn base dir)
;  (cond [(empty? (sub-dirs dir)) base]
;        [else
;         (fn (first (sub-dirs dir))
;             (fold-dir fn base (rest (sub-dirs dir))))]))
               

;PROBLEM B:
;
;Design a function that consumes a Dir and produces the number of 
;images in the directory and its sub-directories. 
;Use the fold-dir abstract function.


(check-expect (img-cnt-dir D4) 2)
(define (img-cnt-dir dir)
  (fold-dir + 0 (build-list 1 (length (dir-images dir)))))
;  (fold-dir + 0 (build-list (length (dir-sub-dirs dir)) (length (dir-images dir)))))


;PROBLEM C:

;Design a function that consumes a Dir and a String. The function looks in
;dir and all its sub-directories for a directory with the given name. If it
;finds such a directory it should produce true, if not it should produce false. 
;Use the fold-dir abstract function.



;PROBLEM D:
;
;Is fold-dir really the best way to code the function from part C? Why or 
;why not?



