(in-package :bag-of-peas)


(defvar *canvas-width* 640)
(defvar *canvas-height* 480)


(defvar *black* (vec4 0 0 0 1))
(defvar *white* (vec4 1 1 1 1))
(defvar *red* (vec4 1 0 0 1))

(defvar *special-black* (vec4 0 0 0 0.5))


(defgame game () ()
  (:viewport-width *canvas-width*)
  (:viewport-height *canvas-height*)
  (:viewport-title "Bag of Peas"))


(defmethod post-initialize ((game game))
  )


(defmethod act ((game game))
  )


(defun draw-text-centered (string origin &key fill-color font)
  (multiple-value-bind (string-origin width height advance)
      (calc-text-bounds string)
    (declare (ignore advance))
    (draw-text string
               (vec2 (- (x origin) (/ width 2) (/ (x string-origin) 2))
                     (- (- (y origin) (/ height 2) (/ (y string-origin) 2))
                        (/ height 2)))
               :fill-color fill-color
               :font font)))


(defmethod draw ((game game))
  (draw-world-border *canvas-width* *canvas-height* 4)
  (draw-text-centered "BAG OF PEAS" (vec2 (/ *canvas-width* 2) (- *canvas-height* 100)))
  (draw *player-ship*)
  (dolist (asteroid *asteroids*)
    (draw asteroid)))


(defun run ()
  (start 'game))


(defun draw-world-border (width height thickness)
  (let ((thickness-by-2 (/ thickness 2)))
    (draw-rect (vec2 thickness-by-2 thickness-by-2)
               (- width thickness)
               (- height thickness)
               :fill-paint *white*
               :stroke-paint *black*
               :thickness thickness)))


(defclass shape ()
  ((location :initarg :location
             :initform nil
             :accessor location)
   (rotation :initarg :rotation
             :initform nil
             :accessor rotation)
   (colour :initarg :colour
          :initform nil
          :accessor colour)
   (points :initarg :points
           :initform nil
           :accessor points)))


(defun make-shape (&rest args)
  (apply #'make-instance 'shape args))


(defmethod print-object ((obj shape) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((location location)
                     (rotation rotation)
                     (points points))
        obj
      (format stream "location: ~a, rotation: ~a, points: ~{~a~^, ~}" location rotation points))))


(defun rotate-point (point angle)
  (let ((x (x point))
        (y (y point))
        (cos (cos angle))
        (sin (sin angle)))
    (vec2 (- (* x cos) (* y sin))
          (+ (* y cos) (* x sin)))))


(defun vec2-from-speed-and-direction (speed direction)
  (vec2 (* speed (cos direction))
        (* speed (sin direction))))


(defun <-vec2 (&rest args)
  (loop for (x y) on args by #'cddr
        collect (vec2 x y)))


(defvar *player-ship* (make-shape :location (vec2 (/ *canvas-width* 2) (/ *canvas-height* 2))
                                  :rotation 0
                                  :colour *special-black*
                                  :points (<-vec2  20   0
                                                  -20  15
                                                  -10   0
                                                  -20 -15
                                                  20   0)))

(defvar *asteroids* (list (make-shape :location (vec2 100 100)
                                      :rotation 0
                                      :colour *special-black*
                                      :points (spawn-asteroid 1 1))
                          (make-shape :location (vec2 100 200)
                                      :rotation 0
                                      :colour *special-black*
                                      :points (spawn-asteroid 1 2))
                          (make-shape :location (vec2 100 350)
                                      :rotation 0
                                      :colour *special-black*
                                      :points (spawn-asteroid 1 3))))


(defmethod draw ((shape shape))
  (let ((location (location shape))
        (colour (colour shape))
        (last-point nil))
    (dolist (point (points shape))
      (let ((rotated-point (rotate-point point (rotation shape))))
        (when last-point
          (draw-line (add location last-point)
                     (add location rotated-point)
                     colour
                     :thickness 4))
        (setf last-point rotated-point)))
    (draw-circle location 2 :fill-paint *red*)))


(defun random-between (start end)
  (+ start (random (- end start))))


(defvar ASTEROID_NUM_POINTS 10)
(defvar ASTEROID_RAD 15)
(defvar ASTEROID_RAD_PLUS 4)
(defvar ASTEROID_RAD_MINUS 6)


(defun spawn-asteroid (scale size)
  (let ((points nil))
    ;; first point
    (push (vec2 (/ ASTEROID_RAD scale) 0)
          points)
    ;; midle points
    (dotimes (index (- ASTEROID_NUM_POINTS 2)) ; index will start in 1 (see 1+)
      (let ((speed (random-between (- ASTEROID_RAD ASTEROID_RAD_MINUS)
                                   (+ ASTEROID_RAD ASTEROID_RAD_PLUS)))
            (direction (* (1+ index)
                          (/ (* pi 2)
                             ASTEROID_NUM_POINTS))))
        (push (mult (vec2-from-speed-and-direction speed direction) size)
              points)))
    ;; last point
    (push (vec2 (/ ASTEROID_RAD scale) 0)
          points)
    points))
