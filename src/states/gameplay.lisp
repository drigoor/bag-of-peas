(in-package :bag-of-peas)


(defun create-player ()
  (make-shape :location (gk:vec2 (/ (gk:viewport-width) 2)
                                 (/ (gk:viewport-height) 2))
              :velocity (gk:vec2 0 0)
              :points (<-vec2  20   0
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


(defvar ASTEROID_MAX_VEL 0.5)
(defvar ASTEROID_MIN_VEL 0.1)
(defvar ASTEROID_MAX_ROT 0.03)


(defun create-asteroid (location scale size)
  (make-shape :location location
              :velocity (gk:vec2 (random-between ASTEROID_MIN_VEL ASTEROID_MAX_VEL)
                                 (- (* (random 2) (* 2 ASTEROID_MAX_ROT)) ASTEROID_MAX_ROT))
              :rotation (random-between 0 pi)
              :points (calculate-asteroid-points scale size)))


(defun create-asteroids ()
  (list (create-asteroid (gk:vec2 100 200) 1 1)
        (create-asteroid (gk:vec2 100 300) 1 2)
        (create-asteroid (gk:vec2 100 400) 1 3)))





(defun wrap-location (location)
  (let* ((x (gk:x location))
         (y (gk:y location))
         (screen-max-x (gk:viewport-width))
         (screen-max-y (gk:viewport-height))
         (new-x (cond ((>= x screen-max-x)
                       0)
                      ((< x 0)
                       (1- screen-max-x))
                      (t
                       x)))
         (new-y (cond ((>= y screen-max-y)
                       0)
                      ((< y 0)
                       (1- screen-max-x))
                      (t
                       y))))
    (gk:vec2 new-x new-y)))


(defun get-vector-components (vector)
  (let ((speed (gk:x vector))
        (direction (gk:y vector)))
    (vec2-from-speed-and-direction speed direction)))


(defun move-point-by-velocity (shape)
  (gk:add (location shape) (get-vector-components (velocity shape))))


(defun move-asteroids (asteroids)
  (dolist (asteroid asteroids)
    (with-slots (rotation rotation-speed location) asteroid
      ;; (incf rotation rotation-speed)
      (setf location (wrap-location (move-point-by-velocity asteroid))))))


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


(defmethod gk:act ((this gameplay))
  (with-slots (asteroids) this
    (move-asteroids asteroids)))


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
