;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname worklist-accumulators) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; House is one of:
;; Gryffindor
;; Hufflepuff
;; Ravenclaw
;; Slytherin

;; interp. one of the 4 houses in the Harry Potter world
(define G "Gryffindor")
(define H "Hufflepuff")
(define R "Ravenclaw")
(define S "Slytherin")

(define-struct wt (name house children))
;; WizardTree is a (make-wt String House (listof WizardTree))
;; interp. A Harry Potter Wizard tree, with the name, house and children or false if no children

(define WT0 (make-wt "" G empty)) ; an empty tree
(define WT1 (make-wt "Harry Potter" G empty)) ; Harry Potter with no children
(define WT3 (make-wt "Draco Malfoy" S empty))
(define WT4 (make-wt "Rowena" R empty))
(define HP  (make-wt "Harry Potter" G                       ; Harry Potter with his children
                     (list (make-wt "James" G empty)
                           (make-wt "Albus" S empty)
                           (make-wt "Lily" G empty))))

;; (listof WizardTree) is a self-refential type of data

#;
(define (fn-for-wt wt)
  (local [(define (fn-for-wt wt)
            (... (wt-name wt)
                 (wt-house wt)
                 (fn-for-lowt (wt-children wt))))
          (define (fn-for-lowt lowt)
            (cond [(empty? lowt) ...]
                  [else
                   (... (fn-for-wt (first lowt))
                        (fn-for-lowt (rest lowt)))]))]
    (fn-for-wt wt)))



;; Functions:

;; Wizard -> (listof String)
;; produce the name of every wizard that has the same house as their immediate parent

(check-expect (children-same-house WT0) empty)
(check-expect (children-same-house WT1) empty)
(check-expect (children-same-house HP) (list "James" "Lily"))
(check-expect (children-same-house (make-wt "A" G (list (make-wt "B" G (list (make-wt "C" G empty) (make-wt "D" S empty) (make-wt "E" G empty)))))) (list "B" "C" "E"))

;(define (children-same-house w) "")

(define (children-same-house wt)
  ;; parent-house: House;
  ;; the house of current wizard's immediate parent
  ;; (fn-for-wt WT0 "")
  ;; (fn-for-wt WT1 G)
  ;; (fn-for-wt WT2 S)
  ;; (fn-for-wt WT3 R)
  (local [(define (fn-for-wt wt parent-house)
            (if (string=? parent-house (wt-house wt))
                (cons (wt-name wt)
                      (fn-for-lowt (wt-children wt) (wt-house wt))) 
                (fn-for-lowt (wt-children wt)
                             (wt-house wt))))
          (define (fn-for-lowt lowt parent-house)
            (cond [(empty? lowt) empty]
                  [else
                   (append
                    (fn-for-wt (first lowt) parent-house)
                    (fn-for-lowt (rest lowt) parent-house))]))]
    (fn-for-wt wt "")))