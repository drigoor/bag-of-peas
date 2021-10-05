(in-package :bag-of-peas)


(defclass loading-screen ()
  ((started-at :initform nil)))


(defmethod gk:post-initialize ((this loading-screen))
  (with-slots (started-at) this
    (setf started-at (bodge-util:real-time-seconds))))


(defmethod gk:act ((this loading-screen))
  (with-slots (started-at) this
    (when (> (- (bodge-util:real-time-seconds) started-at) 2)
      ;; if enough seconds passed since we reached current state
      ;; transition to main-menu
      (gk.fsm:transition-to 'main-menu))))


(defmethod gk:draw ((this loading-screen))
  (let ((canvas-scale 2))
    (gk:with-pushed-canvas ()
      (gk:scale-canvas canvas-scale canvas-scale)
      (draw-text-centered "BAG OF PEAS" (gk:vec2 (/ (/ (gk:viewport-width) 2) canvas-scale)
                                                 (/ (- (gk:viewport-height) 150) canvas-scale)))))
  (let* ((amplitude 50)
         (x-coord (* amplitude (cos (* (bodge-util:real-time-seconds) 3)))))
    (gk:draw-circle (gk:vec2 (+ x-coord (/ (gk:viewport-width) 2))
                             (/ (gk:viewport-height) 2))
                    3
                    :fill-paint (gk:vec4 0 0 0 1)))
  (gk:with-pushed-canvas ()
    (gk:scale-canvas 0.8 0.8)
    (gk:draw-text "version: 0.0.0ervilhas" (gk:vec2 2 2))))
