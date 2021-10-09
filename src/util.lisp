(in-package :bag-of-peas)


(defun random-between (start end)
  (+ start (random (+ 1 (- end start)))))


(defun <-vec2 (&rest args)
  (loop for (x y) on args by #'cddr
        collect (gk:vec2 x y)))


(defun vec2-from-speed-and-direction (speed direction)
  (gk:vec2 (* speed (cos direction))
           (* speed (sin direction))))


(defun rotate-point (point angle)
  (let ((x (gk:x point))
        (y (gk:y point))
        (cos (cos angle))
        (sin (sin angle)))
    (gk:vec2 (- (* x cos) (* y sin))
             (+ (* y cos) (* x sin)))))


(defun draw-text-centered (string origin &key fill-color font)
  (multiple-value-bind (string-origin width height advance)
      (gk:calc-text-bounds string)
    (declare (ignore advance))
    (gk:draw-text string
               (gk:vec2 (- (gk:x origin) (/ width 2) (/ (gk:x string-origin) 2))
                     (- (- (gk:y origin) (/ height 2) (/ (gk:y string-origin) 2))
                        (/ height 2)))
               :fill-color fill-color
               :font font)))


(defun draw-world-border (width height thickness)
  (let ((thickness-by-2 (/ thickness 2)))
    (gk:draw-rect (gk:vec2 thickness-by-2 thickness-by-2)
                  (- width thickness)
                  (- height thickness)
                  :fill-paint *white*
                  :stroke-paint *black*
                  :thickness thickness)))
