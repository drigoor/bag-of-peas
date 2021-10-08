(in-package :bag-of-peas)


(defclass shape ()
  ((location :initarg :location
             :initform nil
             :accessor location)
   (velocity :initarg :velocity
             :initform nil ; speed -> x, direction -> y
             :accessor velocity)
   (rotation :initarg :rotation
             :initform 0
             :accessor rotation)
   (rotation-speed :initarg :rotation
                   :initform 0.07
                   :accessor rotation-speed)
   (colour :initarg :colour
           :initform *special-black*
           :accessor colour)
   (points :initarg :points
           :initform nil
           :accessor points)))


(defun make-shape (&rest args)
  (apply #'make-instance 'shape args))


(defmethod print-object ((obj shape) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((location location)
                     (velocity velocity)
                     (rotation rotation)
                     (points points))
        obj
      (format stream "location: ~a, velocity: ~a, rotation: ~a, points: ~{~a~^, ~}" location velocity rotation points))))


(defmethod draw ((shape shape))
  (let ((location (location shape))
        (colour (colour shape))
        (last-point nil))
    (dolist (point (points shape))
      (let ((rotated-point (rotate-point point (rotation shape))))
        (when last-point
          (gk:draw-line (gk:add location last-point)
                        (gk:add location rotated-point)
                        colour
                        :thickness 4))
        (setf last-point rotated-point)))
    (gk:draw-circle location 2 :fill-paint *red*)))
