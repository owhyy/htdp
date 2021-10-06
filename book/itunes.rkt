;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname itunes) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/itunes)
(require 2htdp/batch-io)

;; Constant definitions
(define ITUNES-LOCATION "~/htdp/itunes.xml")
(define ITUNES-TRACKS
  (read-itunes-as-tracks ITUNES-LOCATION))

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

(define (fn-for-track t)
  (... (track-name t) (track-artist t) (track-album t) (track-time t) (track-track# t) (track-added t) (track-play# t) (track-played t)))

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

(define (fn-for-date d)
  (... (date-year d) (date-month d) (date-day d) (date-hour d) (date-minute d)(date-second d)))

;; Functions

;; Any Any Any Any Any Any Any Any -> Track or #false
;; creates an instance of Track for legitimate inputs
;; otherwise it produces #false
;; NOTE: is a wrapper for (make-track)

(check-expect (create-track "u" "Kendrick Lamar" "To Pimp a Butterfly" (* 4 60000) 12 (make-date 1990 18 3 10 22 19) 4 D2) #false) ;invalid when date is invalid
(check-expect (create-track "u" "Kendrick Lamar" "To Pimp a Butterfly" (* 4 60000) 12 D1 4 D2) T1)

#;(define (create-track name artist album time
                      track# added play# played)
  T0) ;stub

(define (create-track name artist album time track# added play# played)
  (if (and (valid-date? added) (valid-date? played)) ;; !!!
    (make-track name artist album time track# added play# played)
    #false))

;; Any Any Any Any Any Any -> Date or #false
;; creates an instance of Date for legitimate inputs
;; otherwise it produces #false
;; NOTE: is a wrapper for (make-date)
(check-expect (create-date 1990 1 1 0 0 0) (make-date 1990 1 1 0 0 0))
(check-expect (create-date 2003 9 12 29 0 0) #false)

;(define (create-date y mo day h m s) D0) ;stub

(define (create-date y mo day h m s) 
  (if (valid-date? (make-date y mo day h m s))
    (make-date y mo day h m s)
    #false)) 

;; String -> LTracks
;; create a ListOfTracks representation from the
;; text in a file-name (an XML export from iTunes)

(check-expect (read-itunes-as-text "text.xml") (list T1 T2))
(define (read-itunes-as-text file-name) (list T1)) ;stub
;(define (read-itunes-as-text file-name) (read-lines ITUNES-LOCATION))

;; Date -> Boolean
;; produces #true if date is between the specified bounds, #false otherwise
;; !!!
(define (valid-date? d) #false) ;stub
