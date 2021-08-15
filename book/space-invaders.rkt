;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct space-game [ufo tank])
;; SpaceGame is a structure
;;   (make-space-game Number Number)
;; interp. the space invaders game;
;;    - ufo - y coordinate of ufo which only moves vertically
;;    - tank - x coordinate of tank which is at the bottom of the screen
;;      and only moves horizontally

(define SG1(make-space-game (100) (10))) ; tank at the bottom is at 100, ufo is at center and 10
