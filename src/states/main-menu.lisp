(in-package :bag-of-peas)


(defparameter *options* '(("LOAD" loading-screen)
                          ("START" gameplay)
                          ("QUIT")))


(defclass main-menu ()
  ((selected :initform 0)))


(defmethod gk:post-initialize ((this main-menu))
  (let ((nr-of-options (length *options*)))
    (with-slots (selected) this
      (gk:bind-button :down :pressed
                      (lambda ()
                        (setf selected (mod (1+ selected) nr-of-options))))
      (gk:bind-button :up :pressed
                      (lambda ()
                        (setf selected (mod (1- selected) nr-of-options))))
      (gk:bind-button :enter :pressed
                      (lambda ()
                        (let ((next-state (second (nth selected *options*))))
                          (if next-state
                              (gk.fsm:transition-to next-state)
                              (gk:stop))))))))


(defmethod gk:pre-destroy ((this main-menu))
  (gk:bind-button :down :pressed nil)
  (gk:bind-button :up :pressed nil)
  (gk:bind-button :enter :pressed nil))


(defmethod gk:draw ((this main-menu))
  (with-slots (selected) this
    (gk:with-pushed-canvas ()
      (gk:scale-canvas 2 2)
      (loop for text in *options*
            for i from 0
            do (gk:draw-text (if (= i selected)
                                 (format nil "~A~4T~A" "=>" (first text))
                                 (format nil "~4T~A" (first text)))
                             (gk:vec2 140 (+ 130 (- (* i 20)))))))))
