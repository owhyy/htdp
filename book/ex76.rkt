;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex76) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct movie [title producer year])
;; (make-movie String String Number)
;; interp. movie with its title, producer and the year it was relesaed in;

(define M1 (make-movie "Kill Bill: Vol. 1" "Quentin Tarantino" 2003))

#;
(define (fn-for-movie m)
  (... (movie-title m) ... (movie-producer m) ... (movie-year m)))


(define-struct person [name hair eyes phone])
;; (make-movie Name String String Phone)
;; interp. person with details such as:
;;   - name - its Name (first and last)
;;   - hair - hair color
;;   - eyes - eye color
;;   - phone - its Phone

;#
(define (fn-for-person p)
  (... (person-name p)
       (person-hair p)
       (person-eyes p)
       (person-phone p)))

(define-struct Name [fn ln])
;; (make-name String String)
;; interp. someone's first (fn) and last (ln) name

(define-struct Phone [area switch num])
;; (make-phone String String String
;; interp. phone number, where
;;   - area is the 3-number area code and a String representation of
;;     Natural[000-999]
;;   - switch is the switch-code of the neighbourhood (next 3 numbers),
;;     and is also a String representation of Natural[000-999]
;;   - num is the String representation of the last 4 numbers (alas N[0000-9999])

(define-struct pet [name number])
;; (make-pet String String)
;; interp. Pet is the name and its ID

#;
(define (fn-for-pet p)
  (... (pet-name p)
       (pet-number p)))

(define-struct CD [artist title p])
;; (make-CD String String Price)
;; interp. CD is the representation of a music CD along with its artist,
;; title and price

#;
(define (fn-for-cd cd)
  (... (CD-artist cd)
       (CD-title cd)
       (CD-price p)))

(define-struct price [currency value])
;; (make-price 1String Number)
;; interp. a object value in a specific currency ($ € £ ¥)

(define-struct sweater [material size producer])
;; (make-sweater String Number String)
;; interp. Sweater with its material, size and brand(producer)

#;
(define (fn-for-sweater s)
  (... (sweater-material s)
       (sweater-size s)
       (sweater-producer s)))

;; 77
(define-struct time-mn [h m s])
;; (make-time-mn Natural Natural Natural)
;; interp. the amout of time since midnight as measured in
;;   h - hours
;;   m - minutes
;;   s - seconds

(define TMN1 (make-time-mn 12 30 2)) 
(define TMN2 (make-time-mn 1 59 21))  

;; Time-MN -> NonnegativeInteger
;; converts from hours, minutes and seconds since midnight to seconds since midnight
;(define (time->seconds t) 0)
(check-expect (time->seconds TMN1) 45002)
(check-expect (time->seconds TMN2) (+ (* 3600 1) (* 60 59) 21))

(define (time->seconds t)
  (+ (* 3600 (time-mn-h t)) (* 60 (time-mn-m t)) (time-mn-s t)))
 
;; 78
(define-struct 3lw [w1 w2 w3])
;; (make-3lw 1String[a-z] 1String[a-z] 1String[a-z])
;; interp. a 3 [a-z] lettered word, along with #false



