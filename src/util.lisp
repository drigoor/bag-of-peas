(in-package :bag-of-peas)


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
