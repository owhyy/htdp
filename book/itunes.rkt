;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname itunes) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/itunes)
(require 2htdp/batch-io)

;; Data definitions

;; An LTracks is one of:
;; - '()
;; - (cons Track LTracks)

(define-struct track
  [name artist album time track# added play# played])
;; A Track is a (make-track String String String Integer Integer Date Integer Date)
;; interp. An instance records in order: the track's title, artist and album names
;; its playing time in milliseconds, its position within the
;; album, the date it was added, how often it has been played
;; and the date when it was last played

(define T0
  (make-track "" "" "" 0 0 D0 0 D0))
(define T1
  (make-track "Screen Shot" "To Be Kind" "Swans" (* 4 60000) 1 D1 3 D2))
                                           ; minute 4 ^^^
(define T2
  (make-track "u" "To Pimp a Butterfly" "Kendrick Lamar" (* 3.25 60000) 12 D1 9 D3))
                                                         ; minute 3:15

(define-struct date [year month day hour minute second])
;; A Date is a (make-date Integer Integer Integer Integer Integer Integer)
;; interp. An instance records six pieces of information:
;; the date's year, month [1, 12], day [1, 31], hour [0, 23], minute [0, 59]
;;             and second [0, 59]
(define D0
  (make-date 1990 1 1 0 0 0))
(define D1
  (make-date 2004 10 20 20 11 50))
(define D2
  (make-date 2004 10 21 21 1 29))
(define D3
  (make-date 2020 6 13 11 33 10))

;; Functions

;; Any Any Any Any Any Any Any Any -> Track or #false
;; creates an instance of Track for legitimate inputs
;; otherwise it produces #false
(define (create-track name artist album time
                      track# added play# played)
  T0)

;; Any