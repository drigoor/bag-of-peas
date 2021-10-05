(in-package :bag-of-peas)


(defclass gameplay ()
  ())


(defmethod gk:post-initialize ((this gameplay))
  (gk:bind-button :escape :pressed
                  (lambda ()
                    (gk.fsm:transition-to 'main-menu))))


(defmethod gk:pre-destroy ((this gameplay))
  (gk:bind-button :escape :pressed nil))


(defmethod gk:draw ((this gameplay))
  (gk:draw-text "Just an initial gameplay thing..." (gk:vec2 100 100))
  (gk:draw-text "press esc to go back" (gk:vec2 100 80)))
