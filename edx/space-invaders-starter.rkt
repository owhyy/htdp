;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders-starter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders

;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100) ; ???

(define MTS (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))

;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))

(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))

(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;>landed, moving right

#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))

(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))

(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))

;; Functions

;; Game -> Game
;; starts the program from a specific game state
(define (run s)
  (big-bang s
  [on-tick advance-game]   ; Game -> Game
  [to-draw render-stuff])) ; Game -> Image
 ; [on-key handle-key]))  ; Game KeyEvent -> Game

;; Game -> Game
;; handles movement, spawning of Invaders, and their "death"
(check-expect (advance-game (make-game empty empty (make-tank 100 -1)))
              (make-game
                (remove-inv(spawn-inv empty)) empty (make-tank 100 -1)))
;;               !!!         !!!

(check-expect (advance-game G2)
              (make-game
                (remove-inv(spawn-inv (game-invaders G2))) (game-invaders G2) (game-tank G2)))

;(define (advance-game s) s);stub

(define (advance-game s)
  (move-stuff
     (remove-inv
      (make-game
      (spawn-inv (game-invaders s))
      (game-missiles s)
      (game-tank s))))); Game -> Game  !!!

;; Game -> Game
;; handles the movement of Invaders, Missiles and of the Tank
(check-expect (move-stuff (make-game empty empty (make-tank 100 1)))
              (make-game
               (move-invaders empty)
               (move-missiles empty)
               (move-tank (make-tank 100 1))))

(check-expect (move-stuff (make-game (list (make-invader 100 100 -15) (make-invader 50 200 10))
                                     (list (make-missile 10 200) (make-missile 20 100))
                                     (make-tank 50 -1)))
              (make-game (move-invaders (list (make-invader 100 100 -15) (make-invader 50 200 10)))
                         (move-missiles (list (make-missile 10 200) (make-missile 20 100)))
                         (move-tank (make-tank 50 -1))))

;(define (move-stuff s) s) ;stub

(define (move-stuff s)
  (make-game
   (move-invaders (game-invaders s))
   (move-missiles (game-missiles s))
   (move-tank     (game-tank s))))

;; ListOfInvaders -> ListOfInvaders
;; creates new Invaders
(check-expect (spawn-inv empty)
              (if (> (random 150) 100)
                (list (make-invader (random WIDTH) 0 (random-direction 1)) empty)
                empty))

(check-expect (spawn-inv (list (make-invader 100 100 -15)(make-invader 50 200 10)))
              (if (> (random 150) 100)
                (list (make-invader (random WIDTH) 0 (random-direction 1)) (make-invader 100 100 -15)(make-invader 50 200 10))
              (list (make-invader 100 100 -15)(make-invader 50 200 10))))

(define (spawn-inv s) s);stub

;; Integer Intger -> Integer
;; produces a random number between [10, 15] and [-10, -15]

;(define (random-direction n) n) ;stub

(define (random-direction n)
  (if (>  n 10)
    (random-sign n)
    (random-direction (random 15))))

;; Integer -> Integer
;; produces -n with a 50% chance

(define (random-sign n) 
              (if (= (random 1) 0)
                n
                (- 0 n)))


;; Game -> Image
;; renders the invaders, missiles and the tank

(check-expect (render-stuff (make-game
                             empty
                             empty
                             (make-tank 100 1)))
              (place-image
               TANK
               100
               (- HEIGHT TANK-HEIGHT/2)
               (render-inv-and-mis empty empty))) ; !!!
(check-expect (render-stuff G3)
              (place-image
                TANK
                (tank-x (game-tank G3))
                (- HEIGHT TANK-HEIGHT/2)
                (render-inv-and-mis (game-invaders G3)(game-missiles G3))))

(define (render-stuff s) 
  (place-image
    TANK
    (tank-x (game-tank s))
    (- HEIGHT TANK-HEIGHT/2)
    (render-inv-and-mis (game-invaders s)(game-missiles s)))); stub


;; Tank -> Tank
;; moves t by TANK-SPEED in a specific direction
(check-expect (move-tank T0) (make-tank (+ (tank-x T0) (* (tank-dir T0) TANK-SPEED)) (tank-dir T0)))
(check-expect (move-tank T2) (make-tank (+ (tank-x T2) (* (tank-dir T2) TANK-SPEED)) (tank-dir T2)))
(check-expect (move-tank (make-tank WIDTH 1)) (make-tank WIDTH 1))
(check-expect (move-tank (make-tank 0 -1)) (make-tank 0 -1))

;(define (move-tank t) t) ;stub
;<uses Tank template>
(define (move-tank t)
  (if (and (> (tank-x t) 0)
           (< (tank-x t) WIDTH))
      (make-tank (+ (tank-x t) (* TANK-SPEED (tank-dir t))) (tank-dir t))
      t))

;; Tank -> Tank
;; changes the direction of movement
(check-expect (change-tank-dir T0) (make-tank (tank-x T0) (- (tank-dir T0))))
(check-expect (change-tank-dir T2) (make-tank (tank-x T2) (- (tank-dir T2))))

;(define (change-tank-dir t) t) ;stub
;<uses Tank template>
(define (change-tank-dir t)
  (make-tank (tank-x t) (- (tank-dir t))))

;; Invader -> Invader
;; moves the invader
(check-expect (move-invader I1)
              (make-invader
               (+ (invader-x I1) (+ (invader-dx I1) INVADER-X-SPEED))
               (+ (invader-y I1) INVADER-Y-SPEED)
               (invader-dx I1)))

(check-expect (move-invader I2) I2) ;stop (won't be rendered)
(check-expect (move-invader I3) I3) ;stop (won't be rendered)

;(define (move-invader i) i) ;stub
(define (move-invader i)
  (if (< (invader-y i) HEIGHT)
      (if (or (= (invader-x i) WIDTH) (= (invader-x i) 0))
          (make-invader (+ (invader-x i) (+ (- (invader-dx i)) INVADER-X-SPEED))
                        (+ (invader-y i) INVADER-Y-SPEED)
                        (- (invader-dx i)))
          (make-invader (+ (invader-x i) (+ (invader-dx i) INVADER-X-SPEED))
                        (+ (invader-y i) INVADER-Y-SPEED)
                        (invader-dx i)))
      i))


;; Missile -> Missile
;; handles missile movement

(check-expect (move-missile M1) (make-missile (missile-x M1) (- (missile-y M1) MISSILE-SPEED)))
(check-expect (move-missile M2) (make-missile (missile-x M2) (- (missile-y M2) MISSILE-SPEED))) ;won't get rendered
(check-expect (move-missile M3) (make-missile (missile-x M3) (- (missile-y M3) MISSILE-SPEED))) ;won't get rendered

;(define (move-missile m) m) ;stub

(define (move-missile m)
  (make-missile (missile-x m) (- (missile-y m) MISSILE-SPEED)))

;; listof Invader -> listof Invader
;; moves all of the envaders inside the list
(check-expect (move-invaders empty) empty)
(check-expect (move-invaders (list (make-invader 100 100 -10) (make-invader 50 90 12)))
              (list (move-invader (make-invader 100 100 -10)) (move-invader (make-invader 50 90 12))))

;(define (move-invaders il) il) ;stub
(define (move-invaders il)
  (cond
    [(empty? il) empty]
    [else (cons (move-invader (first il)) (move-invaders (rest il)))])) 

;; listof Missile -> listof Missile
;; moves all of the missiles
(check-expect (move-missiles empty) empty)
(check-expect (move-missiles (list (make-missile 100 100) (make-missile 50 90)))
              (list (move-missile (make-missile 100 100)) (move-missile (make-missile 50 90))))
(define (move-missiles ml)
  (cond
    [(empty? ml) empty]
    [else
     (cons (move-missile (first ml)) (move-missiles (rest ml)))]))

;(define (move-missiles ml) ml) ;stub

;; listof Invader listof Missile -> Image
;; renders invaders and missiles on MTS
(check-expect (render-inv-and-mis empty empty)
              (place-images
               (list (square 0 "solid" "white")
                     (square 0 "solid" "white"))
               (list (make-posn 0 0)
                     (make-posn 0 0))
               MTS))

(check-expect (render-inv-and-mis empty (list (make-missile 10 200)))
              (place-images
               (list (square 0 "solid" "white")
                     MISSILE)
               (list (make-posn 0 0)
                     (make-posn 10 200))
               MTS))

(check-expect (render-inv-and-mis (list (make-invader 100 100 -12)) empty )
              (place-images
               (list
                INVADER
                (square 0 "solid" "white"))
               (list
                (make-posn 100 100)
                (make-posn 0 0)) 
               MTS))

(check-expect (render-inv-and-mis (list (make-invader 100 100 -12) (make-invader 20 105 10) (make-invader 50 150 -10)) empty)
              (place-images
               (list
                INVADER
                INVADER
                INVADER
                (square 0 "solid" "white"))
               (list
                (make-posn 100 100)
                (make-posn 20 105)
                (make-posn 50 150)
                (make-posn 0 0)) 
               MTS))

(check-expect (render-inv-and-mis empty (list (make-missile 30 50) (make-missile 100 15) (make-missile 25 30)))
              (place-images
               (list
                (square 0 "solid" "white")
                MISSILE
                MISSILE
                MISSILE)
               (list
                (make-posn 0 0) 
                (make-posn 30 50)
                (make-posn 100 15)
                (make-posn 25 30))
               MTS))

(check-expect (render-inv-and-mis (list (make-invader 100 100 -12) (make-invader 50 100 10) (make-invader 5 25 11))
                                  (list (make-missile 30 50) (make-missile 100 15) (make-missile 25 30)))
              (place-images
               (list
                INVADER
                INVADER
                INVADER
                MISSILE
                MISSILE
                MISSILE)
               (list
                (make-posn 100 100) 
                (make-posn 50 100) 
                (make-posn 5 25) 
                (make-posn 30 50)
                (make-posn 100 15)
                (make-posn 25 30))
               MTS))

;(define (render-inv-and-mis li lm) (square 0 "solid" "white"));stub

;; renders one invader and one missile
(define (render-inv-and-mis li lm)
  (render-loinvader li (render-lomissile lm)))

(define (render-loinvader loinvader bg)
  (cond
    [(empty? loinvader) bg]
    [else
      (place-image
        INVADER
        (invader-x (first loinvader))
        (invader-y (first loinvader))
        (render-loinvader (rest loinvader ) bg))]))

(define (render-lomissile lomissile)
  (cond
    [(empty? lomissile) MTS]
    [else
      (place-image
        MISSILE
        (missile-x (first lomissile))
        (missile-y (first lomissile))
        (render-lomissile (rest lomissile)))]))

(define (hit? i m)
  (and
    (= (invader-x i)(missile-x m))
    (= (invader-y i)(missile-y m))))


