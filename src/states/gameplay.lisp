(in-package :bag-of-peas)


(defun create-player (&optional location rotation)
  (make-shape :location (or location
                            (gk:vec2 (/ (gk:viewport-width) 2)
                                     (/ (gk:viewport-height) 2)))
              :rotation (or rotation
                            0)
              :colour *special-black*
              :points (<-vec2   20   0
                               -20  15
                               -10   0
                               -20 -15
                                20   0)))


(defvar ASTEROID_NUM_POINTS 10)
(defvar ASTEROID_RAD 15)
(defvar ASTEROID_RAD_PLUS 4)
(defvar ASTEROID_RAD_MINUS 6)


(defun calculate-asteroid-points (scale size)
  (let ((points nil))
    ;; first point
    (push (gk:vec2 (/ ASTEROID_RAD scale) 0)
          points)
    ;; midle points
    (dotimes (index (- ASTEROID_NUM_POINTS 2)) ; index will start in 1 (see 1+)
      (let ((speed (random-between (- ASTEROID_RAD ASTEROID_RAD_MINUS)
                                   (+ ASTEROID_RAD ASTEROID_RAD_PLUS)))
            (direction (* (1+ index)
                          (/ (* pi 2)
                             ASTEROID_NUM_POINTS))))
        (push (gk:mult (vec2-from-speed-and-direction speed direction) size)
              points)))
    ;; last point
    (push (gk:vec2 (/ ASTEROID_RAD scale) 0)
          points)
    points))


(defun create-asteroid (location scale size &optional rotation color)
  (make-shape :location location
              :rotation (or rotation
                            (random-between 0 pi))
              :colour (or color
                          *special-black*)
              :points (calculate-asteroid-points scale size)))


(defun create-asteroids ()
  (list (create-asteroid (gk:vec2 100 200) 1 1)
        (create-asteroid (gk:vec2 100 300) 1 2)
        (create-asteroid (gk:vec2 100 400) 1 3)))


(defclass gameplay ()
  ((player :initform (create-player))
   (asteroids :initform (create-asteroids))))


(defmethod reset ((this gameplay))
  (with-slots (player asteroids) this
    (setf player (create-player))
    (setf asteroids (create-asteroids))))


(defmethod gk:post-initialize ((this gameplay))
  (gk:bind-button :escape :pressed
                  (lambda ()
                    (gk.fsm:transition-to 'main-menu)))
  (gk:bind-button :space :pressed
                  (lambda ()
                    (reset this))))


(defmethod gk:pre-destroy ((this gameplay))
  (gk:bind-button :space :pressed nil)
  (gk:bind-button :escape :pressed nil))


(defmethod gk:draw ((this gameplay))
  (bodge-canvas:antialias-shapes nil)
  (draw-world-border (gk:viewport-width) (gk:viewport-height) 4)
  (with-slots (player asteroids) this
    (draw player)
    (dolist (asteroid asteroids)
      (draw asteroid)))
  (gk:draw-text "Just an initial gameplay with states thing..." (gk:vec2 100 100))
  (gk:draw-text "press space to go reset shapes" (gk:vec2 100 80))
  (gk:draw-text "press esc to go back" (gk:vec2 100 60)))
