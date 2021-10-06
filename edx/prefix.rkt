;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname prefix) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ListOfString ListOfString -> Boolean
;;  produce true if lsta is a prefix of lstb

(check-expect (prefix=? empty empty) true)
(check-expect (prefix=? (list "x") empty) false)
(check-expect (prefix=? empty (list "x")) true)
(check-expect (prefix=? (list "x") (list "x")) true)
(check-expect (prefix=? (list "x") (list "y")) false)
(check-expect (prefix=? (list "x" "y") (list "x" "y")) true)
(check-expect (prefix=? (list "x" "x") (list "x" "y")) false)
(check-expect (prefix=? (list "x") (list "x" "y")) true)
(check-expect (prefix=? (list "x" "y" "z") (list "x" "y")) false)

;(define (prefix=? lsta lsbt) #false) ;stub

#;
(define (prefix=? lsta lstb)
   (cond
     [(and (empty? lsta) (empty? lstb)) (...)]
     [(and (cons? lsta)  (empty? lstb)) (... lsta ...)]
     [(and (cons? lstb)  (empty? lstb)) (... lstb ...)]
     [(and (cons? lsta)  (cons? lstb))  (... lsta lstb ...)]))


(define (prefix=? lsta lstb)
  (cond
    [(empty? lsta) #true]
    [(empty? lstb) #false]
    [else (and (string=? (first lsta) 
                         (first lstb))
               (prefix=? (rest lsta) (rest lstb)))])) 
