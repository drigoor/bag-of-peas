(in-package #:bag-of-peas)


(defvar *canvas-width* 640)
(defvar *canvas-height* 480)


(defvar *black* (vec4 0 0 0 1))
(defvar *white* (vec4 1 1 1 1))
(defvar *red* (vec4 1 0 0 1))


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
  (draw-text-centered "BAG OF PEAS" (vec2 (/ *canvas-width* 2) (- *canvas-height* 100))); :font (make-font 'courier-new 20))
  (draw *player-ship*))


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
   (paint :initarg :paint
          :initform nil
          :accessor paint)
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



(defun <-vec2 (&rest args)
  (loop for (x y) on (mapcar #'(lambda (i)
                                 (/ i 4))
                             args) by #'cddr
        collect (vec2 x y)))


(defvar *player-ship* (make-shape :location (vec2 (/ *canvas-width* 2) (/ *canvas-height* 2))
                                  :rotation 0
                                  :paint (vec4 0 0 0 0.5)
                                  :points (<-vec2  80   0
                                                  -80  60
                                                  -40   0
                                                  -80 -60
                                                   80   0)))

(defmethod draw ((shape shape))
  (let ((location (location shape))
        (paint (paint shape))
        (last-point nil))
    (dolist (point (points shape))
      (let ((rotated-point (rotate-point point (rotation shape))))
        (when last-point
          (draw-line (add location last-point)
                     (add location rotated-point)
                     paint
                     :thickness 5))
        (setf last-point rotated-point)))
    (draw-circle location 3 :fill-paint *red*)))


(defun rotate-point (point angle)
  (let ((x (x point))
        (y (y point))
        (cos (cos angle))
        (sin (sin angle)))
    (vec2 (- (* x cos) (* y sin))
          (+ (* y cos) (* x sin)))))
