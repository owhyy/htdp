;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname happy-bar) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; Constant definitions

;; Happiness constants
;; minimum happiness
(define MIN-HAPPINESS 0)
;; maximum ammount of happiness
(define MAX-HAPPINESS 100)
;; amount of happiness decreasing/tick
(define DECREASE-RATE -1.3)
;; happiness increase when pressing down key
(define INCREASE-DOWN-KEY (/ MAX-HAPPINESS 5))
;; happiness increase when pressing up
(define INCREASE-UP-KEY (/ MAX-HAPPINESS 3))

;; Bar constants
;; width
(define BAR-WIDTH 400)
;; height
(define BAR-HEIGHT (/ BAR-WIDTH 6))
;; how many times is width > max-happines
(define WIDTH-COEFFICIENT (/ BAR-WIDTH MAX-HAPPINESS))
;; color of BAR fill
(define HAPPINESS-COLOR "red")
;; outline thickness
(define BAR-THICKNESS 7)
(define BAR-OUTLINE (rectangle BAR-WIDTH BAR-HEIGHT "outline" (pen "black" BAR-THICKNESS "solid" "round" "round")))
(define BAR-FILL (rectangle BAR-WIDTH BAR-HEIGHT "solid" HAPPINESS-COLOR))

;; Background constants
(define BACKGROUND (empty-scene BAR-WIDTH BAR-HEIGHT))

;; Data definitions
;; interp. HappinessState is a Natural[MIN-HAPPINESS, MAX-HAPINESS]
;; representing the fill of the bar
;; decreases from right to left

;; (define HP1 MIN-HAPPINESS) ; bar's smallest possible value
;; (define HP2 (/ MAX-HAPPINESS 2)) ; bar filled untill the middle
;; (define HP3 MAX-HAPPINESS) ; bar's filled up to the top

#;
(define (fn-for-happiness bs)
  (... bs))

;; Template properties used:
;; - atomic distinct: Natural[MIN-HAPPINESS, MAX-HAPPINESS]

#;
(place-image (overlay
                BAR-OUTLINE
                BAR-FILL)
               (/ BAR-WIDTH 2)
               (/ BAR-HEIGHT 2)
               BACKGROUND)
;; Function defintions

;; HappinessState -> HappinessState
;; increases bs by DECREASE-RATE for every clock tick

(check-expect (tock MIN-HAPPINESS) MIN-HAPPINESS)
(check-expect (tock MAX-HAPPINESS) (+ MAX-HAPPINESS (* WIDTH-COEFFICIENT DECREASE-RATE)))
(check-expect (tock (/ MAX-HAPPINESS 2)) (+ (/ MAX-HAPPINESS 2) (* WIDTH-COEFFICIENT DECREASE-RATE)))

; (define (tock bs) 0) ;stub
#;
(define (tock bs)
  (cond [Q A]
        [else A]))

(define (tock bs)
  (cond [(<= bs MIN-HAPPINESS) MIN-HAPPINESS]
        [else (+ bs (* WIDTH-COEFFICIENT DECREASE-RATE) )]))

;; HappinessState -> Image
;; displays bar-fill based on bs

;(define (draw-bar bs) (square 0 "solid" "white")) ;stub
;;<uses HappinessState template>
(define (draw-bar bs)
  (cond [(> bs (* WIDTH-COEFFICIENT MIN-HAPPINESS))
         (place-image (overlay/align
                       "left" "center"
                       BAR-OUTLINE
                       (rectangle
                        bs
                        BAR-HEIGHT
                        "solid"
                        HAPPINESS-COLOR))
                      (/ BAR-WIDTH 2)
                      (/ BAR-HEIGHT 2)
                      BACKGROUND)]
        [else
         (place-image (overlay/align
                       "left" "center"
                       BAR-OUTLINE
                       (rectangle
                        (* WIDTH-COEFFICIENT MIN-HAPPINESS)
                        BAR-HEIGHT
                        "solid"
                        HAPPINESS-COLOR))
                      (/ BAR-WIDTH 2)
                      (/ BAR-HEIGHT 2)
                      BACKGROUND)]))

;; HappinessState String -> HappinessState
;; increases bs by 1/3 if ks is "up" and 1/5 if ks is "down", produces bs otherwise
;; but first checks that adding won't produce a result bigger than the maximum result
;(define (key-func bs ks) bs) ;stub
(check-expect (key-func 50 "up") (+ 50 ( * WIDTH-COEFFICIENT INCREASE-UP-KEY)))
(check-expect (key-func 30 "down") (+ 30 (* WIDTH-COEFFICIENT INCREASE-DOWN-KEY)))
(check-expect (key-func (* WIDTH-COEFFICIENT MAX-HAPPINESS) "up") (* WIDTH-COEFFICIENT MAX-HAPPINESS))
(check-expect (key-func 200 "left") 200) 

(define (key-func bs ks)
  (cond
    [(key=? ks "up")
     (if (> (+ bs (* WIDTH-COEFFICIENT INCREASE-UP-KEY)) (* WIDTH-COEFFICIENT MAX-HAPPINESS))
         bs
         (+ bs(* WIDTH-COEFFICIENT INCREASE-UP-KEY)))] 
    [(key=? ks "down")
     (if (> (+ bs( * WIDTH-COEFFICIENT INCREASE-DOWN-KEY)) (* WIDTH-COEFFICIENT MAX-HAPPINESS))
         bs
         (+ bs(* WIDTH-COEFFICIENT INCREASE-DOWN-KEY)))]
    [else bs]))


;; HappinessState -> HappinessState
;; function that launches the program from a specific state

(define (main bs)
  (big-bang bs
    [on-tick tock]
    [to-draw draw-bar]
    [on-key key-func]))

(main (* MAX-HAPPINESS WIDTH-COEFFICIENT))