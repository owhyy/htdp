;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname editor) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; Constants

(define WIDTH 200)
(define HEIGHT 20)
(define MTS (empty-scene WIDTH HEIGHT))

(define CURSOR-COLOR "red")
(define CURSOR (rectangle 1 HEIGHT "solid" CURSOR-COLOR))

(define FONT-SIZE 11)
(define FONT-COLOR "black")

;; ----------------

;; Data definitions

(define-struct editor [pre post])

;; An Editor is a structure:
;;   (make-editor String String)
;; interp. (make-editor s t) describes an editor
;; whose visible text is (string-append s t) with
;; the CURSOR displayed between s and t

(define TE (make-editor "mojo" "pin")) ;; test Editor, used in tests
(define TE2 (make-editor "" "")) ;; empty Editor

#;
(define (fn-for-editor ed)
  (... (editor-pre ed)    ; String
       (editor-post ed))) ; String

;; Template rules used:
;; compound: structure with 2 fields

;; ----------------

;; Functions

;; Editor KeyEvent -> Editor
;; handles text operations (adding new text, removing and moving the cursor to left or right)

;(define (edit ed ke) ed) ;stub

(check-expect (edit (make-editor "ur" "dad") "a") (make-editor "ura" "dad")) ; base case 
(check-expect (edit (make-editor "ur" "dad") "A") (make-editor "urA" "dad")) ; upper base case 

(check-expect (edit (make-editor "ur" "dad") "\b") (make-editor "u" "dad"))  ; case of backspace

(check-expect (edit (make-editor "ur" "dad") "\t") (make-editor "ur" "dad")) ; ignore
(check-expect (edit (make-editor "ur" "dad") "\r") (make-editor "ur" "dad"))

(check-expect (edit (make-editor "ur" "dad") "left") (make-editor "u" "rdad"))
(check-expect (edit (make-editor "" "hell") "left") (make-editor "" "hell"))
(check-expect (edit (make-editor "ur" "dad") "right")(make-editor "urd" "ad"))
(check-expect (edit (make-editor "hello" "") "right") (make-editor "hello" ""))

(check-expect (edit (make-editor "ok" "computer") "shift") (make-editor "ok" "computer")) ; >1 string length

#;
(define (edit ed ke)
  (cond
    [Q A]
    [Q A]
    [else A]))

(define (edit ed ke)
  (cond
    [(key=? ke "\b") (remove-pre ed)]           ; if backspace - delete last character from pre
    [(or (key=? ke "\t") (key=? ke "\r")) ed]   ; if tab or enter - ignore
    [(key=? ke "left") (left-handle ed)]        ; if left - move the last pre character to the first post character
    [(key=? ke "right") (right-handle ed)]      ; if right - move the last post character to the first pre character
    [(< (string-length ke) 2)
     (if (> (string-length (editor-pre ed)) 32)
         ed
         (add-char ed ke))] ; if 1String - append to pre
    [else ed]))                                 ; else ignore

;; Editor -> Image
;; produces 200x20 image with cursor and text

(check-expect (render (make-editor "hello" "world"))
              (overlay/align "left" "center"
                             (beside
                              (text "hello" FONT-SIZE FONT-COLOR)
                              CURSOR
                              (text "world" FONT-SIZE FONT-COLOR))
                             MTS))

;(define (render e) (square 10 "solid" "white")) ;stub

;; <uses template from Editor
(define (render e)
  (overlay/align "left" "center"
                 (beside
                  (text (editor-pre e) FONT-SIZE FONT-COLOR)
                  CURSOR
                  (text (editor-post e) FONT-SIZE FONT-COLOR))
                 MTS))

;; String -> String
;; produces the first character of a string

(check-expect (first-string "grace") "g")
(check-expect (first-string " ") " ")
(check-expect (first-string "") "")

;(define (first-char s) s) 

#;(define (first-char s)
    (... s))

(define (first-string s)
  (if (> (string-length s) 0)
      (string-ith s 0)
      ""))

;; String -> String
;; produces the last character of a string

(check-expect (last-string "mojo pin") "n")
(check-expect (last-string " ") " ")
(check-expect (last-string "") "")

;(define (last-char s) s)

#;(define (last-char s)
    (... s))

(define (last-string s)
  (if (> (string-length s) 0)
      (string-ith s (- (string-length s) 1))
      ""))

;; Editor -> Editor
;; moves the first character from post to the last character of pre

(check-expect (right-handle (make-editor "jeff" "buckley"))
              (make-editor
               "jeffb"
               "uckley"))
(check-expect (right-handle (make-editor "jeff" ""))
              (make-editor
               "jeff"
               ""))
(check-expect (right-handle (make-editor "" ""))
              (make-editor
               ""
               ""))
               
#;(define (right-handle ed)
    (... (editor-pre ed) (editor-post ed)))

(define (right-handle ed)
  (make-editor
   (string-append (editor-pre ed) (first-string (editor-post ed)))
   (remove-first (editor-post ed)))) 

;; Editor -> Editor
;; moves the first character of pre to the last character of post

(check-expect (left-handle (make-editor "jeff" "buckley"))
              (make-editor
               "jef"
               "fbuckley"))
(check-expect (left-handle (make-editor "" "jeff"))
              (make-editor
               ""
               "jeff"))
(check-expect (left-handle (make-editor "" ""))
              (make-editor
               ""
               ""))

#;(define (left-handle ed)
    (... (editor-pre ed) (editor-post ed)))

(define (left-handle ed)
  (if (string=? (editor-pre ed) "" )
      ed
      (make-editor
       (remove-last (editor-pre ed))
       (string-append (last-string (editor-pre ed))
                      (editor-post ed)))))
  


;; String -> String
;; removes last character from a string

;(define (remove-last s) s)

(check-expect (remove-last "grace") "grac")
(check-expect (remove-last "a") "")
(check-expect (remove-last "") "")


#;(define (remove-last s)
    (... s))

(define (remove-last s)
  (if (>(string-length s) 0)
      (substring s 0 (- (string-length s) 1))
      s))

;; String -> String
;; removes the first character of a string

(check-expect (remove-first "grace") "race")
(check-expect (remove-first "a") "")
(check-expect (remove-first "") "")

(define (remove-first s)
  (if (> (string-length s) 0)
      (substring s 1 (string-length s))
      ""))

;; Editor -> Editor
;; removes last character from pre

;(define (remove-pre ed) ed)

#;(define (remove-pre ed)
    (... (editor-pre ed) (editor-post ed)))

(check-expect (remove-pre (make-editor "slint" "spiderland"))
              (make-editor "slin" "spiderland"))
(check-expect (remove-pre (make-editor "" "spiderland"))
              (make-editor "" "spiderland"))

(define (remove-pre ed)
  (make-editor (remove-last (editor-pre ed)) (editor-post ed)))

;; Editor String -> Editor
;; appends s to last character of ed

(check-expect (add-char (make-editor "cag" "the elephant") "e" )
              (make-editor "cage" "the elephant"))
(check-expect (add-char (make-editor "cag" "the elephant") "" )
              (make-editor "cag" "the elephant"))

;(define (add-char ed s) ed)

#;(define (add-char ed s)
    (... (editor-pre ed) (...s) (editor-post ed)))

(define (add-char ed s)
  (make-editor (string-append (editor-pre ed) s) (editor-post ed)))

;; String -> Editor
;; starts the editor from an initial string
(define (run pre)
  (big-bang (make-editor pre "") 
    [on-key edit]
    [to-draw render]))