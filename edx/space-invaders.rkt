;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders

;; ------------------------------------
;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100) ; spawn rate for invaders

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

;; ------------------------------------
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

;; ListOfInvaders is one of:
;; - empty
;; - (cons Invader ListOfInvaders )
;; interp. a list of Invaders
(define LOI0 empty)
(define LOI1 (cons I1 empty))
(define LOI2 (cons I1 LOI1))
(define LOI3 (cons I3 LOI2))

#;
(define (fn-for-loi loi)
  (cond
    [(empty? loi) ...]
    [else 
     (... (first loi)
          (fn-for-loi (rest loi)))]))

;; template rules used:
;; - one of: 2 fields
;; - atomic distinct: empty
;; - compound: (cons Invader ListOfInvaders)
;; Self-referencial type of data:
;; (... (first loi)
;;      (fn-for-loi (rest loi)))

;; ListOfMissiles is one of:
;; - empty
;; - (cons Missile ListOfMissiles )
;; interp. a list of Missiles
(define LOM0 empty)
(define LOM1 (cons M1 empty))
(define LOM2 (cons M1 LOM1))
(define LOM3 (cons M3 LOM2))

(define (fn-for-lom lom)
  (cond
    [(empty? lom) ...]
    [else 
     (... (first lom)
          (fn-for-lom (rest lom)))]))

;; template rules used:
;; - one of: 2 fields
;; - atomic distinct: empty
;; - compound: (cons Missile ListOfMissiles)
;; Self-referencial type of data:
;; (... (first lom)
;;      (fn-for-lom (rest lom)))


;; ------------------------------------
;; Functions

;; Game -> Game
;; starts the game from a specific Game g
(define (main g)
  (big-bang g
    [on-tick advance-game]   ; Game -> Game
    [on-key handle-key]      ; Game KeyEvent -> Game
    [stop-when end-game?]    ; Game -> Bool
    [to-draw render-game]))  ; Game -> Image


;; Game -> Game
;; handles the movement, spawning of invaders and their death
(define (advance-game g)
  (make-game
   (destroy-invaders (game-missiles g) 
                     (spawn-invaders 
                      (move-invaders 
                       (game-invaders g))))
   (move-missiles (game-missiles g))
   (move-tank (game-tank g))))

;(define (advance-game g) g) ;stub

;; Game KeyEvent -> Game
;; moves tank (left/right) and shoots (space)
(check-expect (handle-key G0 "left")
              (make-game empty 
                         empty 
                         (move-tank-left (game-tank G0)))) 
(check-expect (handle-key G0 "right")
              (make-game empty
                         empty 
                         (move-tank-right (game-tank G0)))) 
(check-expect (handle-key G0 "up")
              (make-game empty 
                         empty 
                         (game-tank G0)))
(check-expect (handle-key G0 " ")
              (make-game empty 
                         (fire-missile (game-missiles G0) (tank-x (game-tank G0))) 
                         (game-tank G0)))
(check-expect (handle-key G2 "left")
              (make-game (list I1) 
                         (list M1)
                         (move-tank-left (game-tank G2))))
(check-expect (handle-key G2 "right")
              (make-game (list I1) 
                         (list M1)
                         (move-tank-right (game-tank G2))))
(check-expect (handle-key G2 " ")
              (make-game (list I1) 
                         (fire-missile (game-missiles G2) (tank-x (game-tank G2)))
                         (game-tank G2)))

;(define (handle-key g ke) g) ;stub
#;
(define (handle-key g ke)
  (cond
    [Q A]
    [Q A]
    [Q A]
    [else (...)]))

(define (handle-key g ke)
  (cond
    [(key=? ke "left") 
     (make-game (game-invaders g)
                (game-missiles g)
                (move-tank-left (game-tank g)))]
    [(key=? ke "right") 
     (make-game (game-invaders g)
                (game-missiles g)
                (move-tank-right (game-tank g)))]
    [(key=? ke " ")
      (make-game (game-invaders g)
                 (fire-missile (game-missiles g) (tank-x (game-tank g)))
                 (game-tank g))]
    [else g]))


;; Game -> Bool
;; returns #true if any invader touched the bottom edge of the screen
(check-expect (end-game? G0) #false)
(check-expect (end-game? G1) #false)
(check-expect (end-game? G2) #false)
(check-expect (end-game? G3) #true) 
(check-expect (end-game? (make-game
                          (list (make-invader 100 (- HEIGHT 5) -12))
                          empty
                          T0)) #true)

;(define (end-game? g) #false) ;stub
(define (end-game? g)
  (if (touches? (game-invaders g))
    #true
    #false))

;; Game -> Image
;; renders the tank, invaders and the missiles
(check-expect (render-game G0)
              (render-tank (game-tank G0)))

(check-expect (render-game G2)
              (render-invaders   (game-invaders G2) 
                                 (render-missiles (game-missiles G2)
                                                  (render-tank   (game-tank G2)))))

; (define (render-game g) MTS) ;stub
; <uses Game template>

(define (render-game g)
  (render-invaders (game-invaders g) 
                   (render-missiles (game-missiles g) 
                                    (render-tank (game-tank g)))))

;; ListOfMissiles ListOfInvaders -> ListOfInvaders
;; destroys the invaders if they are hit by missiles
(check-expect (destroy-invaders LOM0 LOI0) LOI0)
(check-expect (destroy-invaders LOM1 LOI1) LOI1)
(check-expect (destroy-invaders 
               (list (make-missile (missile-x M2) (+ (missile-y M2) HIT-RANGE)))
               (list I1))
              (list I1))
(check-expect (destroy-invaders 
               (list (make-missile (missile-x M2) (missile-y M2)))
               (list I1))
              empty)

(check-expect (destroy-invaders 
               (list (make-missile (missile-x M2) (missile-y M2) )
                     M1)
               (list I1))
              empty)

;(define (destroy-invaders lom loi) loi) ;stub
; <uses ListOfMissiles/ListOfInvaders template>
(define (destroy-invaders lom loi) 
  (cond 
    [(empty? lom) loi]
    [(empty? loi) empty]
    [else
     (if (hit? (first loi) lom)
         (rest loi)
         (cons (first loi) (destroy-invaders lom (rest loi))))]))

;; ListOfInvaders -> ListOfInvaders
;; spawns new invaders
;(define (spawn-invaders loi) loi) ;stub
; <uses ListOfInvaders template>
(define (spawn-invaders loi)
  (if (> (random 104) INVADE-RATE)
      (cons (make-invader (random WIDTH) 0 (random-direction 10)) loi)
      loi))

;; ListOfInvaders -> ListOfInvaders
;; moves the invaders
(check-expect (move-invaders LOI0) empty)

(check-expect (move-invaders LOI1) (list (move-invader I1)))
(check-expect (move-invaders LOI3) (cons (move-invader I3) (move-invaders LOI2)))
;(define (move-invaders loi) loi) ;stub

; <uses ListOfInvaders template>
(define (move-invaders  loi)
  (cond
    [(empty? loi) empty]
    [else 
     (cons (move-invader (first loi))
           (move-invaders (rest loi)))]))

;; ListOfMissiles -> ListOfMissiles
;; moves the missiles
(check-expect (move-missiles LOM1) (list (move-missile M1)))
(check-expect (move-missiles LOM3) (cons (move-missile M3) (move-missiles LOM2))) 

;(define (move-missiles lom) lom) ;stub
; <uses ListOfInvaders template>
(define (move-missiles  lom)
  (cond
    [(empty? lom) empty]
    [else 
     (cons (move-missile (first lom))
           (move-missiles (rest lom)))]))

;; Tank -> Tank
;; moves the tank
(check-expect (move-tank T0) 
              (make-tank (+ (tank-x T0) (* TANK-SPEED (tank-dir T0))) (tank-dir T0)))
(check-expect (move-tank (make-tank WIDTH 1)) 
              (make-tank WIDTH 1))

;(define (move-tank t) t) ;stub
; <uses Tank template>

(define (move-tank t)
  (if (< (/ (image-width TANK) 2) (tank-x t) (- WIDTH (/ (image-width TANK) 2)))
    (make-tank
      (+ (tank-x t) (* TANK-SPEED (tank-dir t))) (tank-dir t))
    t))

;; Tank -> Tank
;; changes the direction of tank to left
(check-expect (move-tank-left T0) (make-tank (tank-x T0) (- (tank-dir T0))))
(check-expect (move-tank-left T2) T2)
;(define (move-tank-left t) t) ;stub
; <uses Tank template>

(define (move-tank-left t)
  (if (= (tank-dir t) 1) 
      (make-tank (+ (tank-x t) (* TANK-SPEED (- (tank-dir t)))) (- (tank-dir t)))
      t))

;; Tank -> Tank
;; changes the direction of tank to right
(check-expect (move-tank-right T0) T0)
(check-expect (move-tank-right T2) (make-tank (tank-x T2) (- (tank-dir T2))))
;(define (move-tank-right t) t) ;stub
; <uses Tank template>

(define (move-tank-right t)
  (if (= (tank-dir t) -1) 
      (make-tank (+ (tank-x t) (* TANK-SPEED (- (tank-dir t)))) (- (tank-dir t)))
      t))

;; ListOfMissiles Number -> LitOfMissiles
;; adds a new missile to lom with the initial position of
;; outside the tank's gun
(check-expect (fire-missile empty 100)
              (cons (make-missile 100 (- HEIGHT TANK-HEIGHT/2 (image-height MISSILE)))empty))
;(define (fire-missile lom x) lom) ;stub
; <uses ListOfMissiles template>

(define (fire-missile lom x)
  (cond
    [(empty? lom) (cons (make-missile x (- HEIGHT TANK-HEIGHT/2 (image-height MISSILE))) empty)]
    [else 
     (cons (make-missile x (- HEIGHT TANK-HEIGHT/2 (image-height MISSILE))) lom)]))

;; ListOfInvaders Image -> Image
;; renders the invaders on bg
(check-expect (render-invaders LOI0 (render-tank T0)) (render-tank T0))

(check-expect (render-invaders LOI1 (render-tank T0)) 
              (place-image
               INVADER
               (invader-x I1)
               (invader-y I1)
               (render-tank T0)))

(check-expect (render-invaders LOI3 (render-tank T0))
              (place-image
               INVADER
               (invader-x I3)
               (invader-y I3)
               (place-image
                INVADER
                (invader-x I1)
                (invader-y I1)
                (place-image
                 INVADER
                 (invader-x I1)
                 (invader-y I1)
                 (render-tank T0)))))

(check-expect (render-invaders LOI3 (render-missiles LOM1 (render-tank T0)))
              (place-image
               INVADER
               (invader-x I3)
               (invader-y I3)
               (place-image
                INVADER
                (invader-x I1)
                (invader-y I1)
                (place-image
                 INVADER
                 (invader-x I1)
                 (invader-y I1)
                 (render-missiles LOM1 (render-tank T0))))))

;(define (render-invaders loi bg) MTS) ;stub
; <uses ListOfInvaders template>

(define (render-invaders loi bg)
  (cond
    [(empty? loi) bg]
    [else 
     (place-image
      INVADER
      (invader-x (first loi))
      (invader-y (first loi))
      (render-invaders (rest loi) bg))]))

;; ListOfMissiles Image -> Image
;; renders the missiles on bg
(check-expect (render-missiles LOM0 (render-tank T0)) (render-tank T0))

(check-expect (render-missiles LOM1 (render-tank T0)) 
              (place-image
               MISSILE
               (missile-x M1)
               (missile-y M1)
               (render-tank T0)))
(check-expect (render-missiles LOM3 (render-tank T1)) 
              (place-image
               MISSILE
               (missile-x M3)
               (missile-y M3)
               (place-image
                MISSILE
                (missile-x M1)
                (missile-y M1)
                (place-image
                 MISSILE
                 (missile-x M1)
                 (missile-y M1)
                 (render-tank T1)))))

;(define (render-missiles lom bg) MTS) ;stub
; <uses ListOfMissiles template>
(define (render-missiles lom bg)
  (cond
    [(empty? lom) bg]
    [else 
     (place-image
      MISSILE
      (missile-x (first lom))
      (missile-y (first lom))
      (render-missiles (rest lom) bg))]))

;; Tank -> Image
;; renders the tank on MTS
(check-expect (render-tank T0)
              (place-image
               TANK
               (tank-x T0)
               (- HEIGHT TANK-HEIGHT/2)
               MTS))

; (define (render-tank t) MTS) ;stub
; <uses Tank template>
(define (render-tank t)
  (place-image
   TANK
   (tank-x t)
   (- HEIGHT TANK-HEIGHT/2)
   MTS))

;; Invader ListOfMissiles -> Boolean
;; produces #true if Invader's x and y coordinates 
;; are the same as any one of lom's missile coordinates
(check-expect (hit? I1 LOM0) #false)

(check-expect (hit? I1 LOM1) #false)
(check-expect (hit? I1 (list (make-missile (missile-x M2) (missile-y M2)))) #true)

;(define (hit? i lom) #true) ;stub
;<uses ListOfMissiles template>
(define (hit? i lom)
  (cond
    [(empty? lom) #false]
    [else
     (if (and
          (<= (- (missile-x (first lom)) HIT-RANGE) (invader-x i) (+ (missile-x (first lom)) HIT-RANGE))
          (<= (- (missile-y (first lom)) HIT-RANGE) (invader-y i) (+ (missile-y (first lom)) HIT-RANGE)))
         #true
         (hit? i (rest lom)))]))

;; Number -> Number
;; randomly produces -n 
(define (random-direction n) 
  (if (= (random 1) 1)
      (- n)
      n))

;; Invader -> Invader
;; moves the invader's x position by (* INVADER-Y-SPEED dx) and y by INVADER-Y-SPEED
(check-expect (move-invader I1) (make-invader (+ (invader-x I1) (invader-dx I1)) (+ (invader-y I1) INVADER-Y-SPEED) (invader-dx I1)))
(check-expect (move-invader (make-invader WIDTH 100 10)) (make-invader (+ WIDTH -10) (+ 100 INVADER-Y-SPEED) -10))
;(define (move-invader i) i) ;stub

#;(define (move-invader i) 
    (... i))

(define (move-invader i)
  (cond
    [(>= (invader-x i) WIDTH)
    (make-invader 
          (+ (invader-x i) (- (invader-dx i)))
          (+ (invader-y i) INVADER-Y-SPEED)
          (- (invader-dx i)))]
    [(<= (invader-x i) 0)
         (make-invader 
          (+ (invader-x i) (- (invader-dx i)))
          (+ (invader-y i) INVADER-Y-SPEED)
          (- (invader-dx i)))]
    [else 
      (make-invader 
          (+ (invader-x i) (invader-dx i))
          (+ (invader-y i) INVADER-Y-SPEED)
          (invader-dx i))]))   
  
;; Missile -> Missile
;; moves the missile's x position by (* INVADER-Y-SPEED dx) and y by INVADER-Y-SPEED
;(define (move-missile m) m) ;stub

#;(define (move-missile m) 
    (... m))

(define (move-missile m)
  (if (< 0 (missile-y m) HEIGHT)
    (make-missile 
      (missile-x m)
      (- (missile-y m) MISSILE-SPEED))
    m))

;; ListOfInvaders -> Bool
;; produces #true if any Invader touches (- HEIGHT (image-height INVADER))

(check-expect (touches? empty) #false)
(check-expect (touches? LOI1) #false)
(check-expect (touches? (list I2)) #true)

;(define (touches? loi) #true) ;stub

; <uses ListOfInvaders template>

(define (touches? loi)
  (cond
    [(empty? loi) #false]
    [else 
     (if (>= (invader-y (first loi)) 
             (- HEIGHT (/ (image-height INVADER) 2)))
          #true
         (touches? (rest loi)))]))


